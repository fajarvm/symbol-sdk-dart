//
// Copyright (c) 2019 Fajar van Megen
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

library nem2_sdk_dart.sdk.model.receipt.resolution_statement;

import 'dart:math' show max;
import 'dart:typed_data' show ByteData, Endian, Uint8List;

import 'package:nem2_sdk_dart/core.dart' show HexUtils, SHA3Hasher, SignSchema;

import '../account/address.dart';
import '../blockchain/network_type.dart';
import '../common/id.dart';
import '../common/uint64.dart';
import '../common/unresolved_utils.dart';
import '../mosaic/mosaic_id.dart';
import '../namespace/namespace_id.dart';
import 'receipt_type.dart';
import 'receipt_version.dart';
import 'resolution_entry.dart';
import 'resolution_type.dart';

/// A resolution statement keeps the relation between a namespace alias used in a transaction and
/// the real [Address] or [mosaicId].
///
/// When a transaction includes an alias, a so called resolution statement reflects the resolved
/// value for that block:
/// - Address Resolution: An account alias was used in the block.
/// - Mosaic Resolution: A mosaic alias was used in the block.
class ResolutionStatement {
  /// The type of this resolution.
  final ResolutionType resolutionType;

  /// The block height.
  final Uint64 height;

  /// The unresolved object. It must be either an [Address], a [MosaicId] or a [NamespaceId].
  final dynamic unresolved;

  /// A list of resolution entries linked to the unresolved object.
  ///
  /// It is a list instead of a single UInt64 field since within one block the resolution might
  /// change for different sources due to alias related transactions.
  final List<ResolutionEntry> resolutionEntries;

  // private constructor
  ResolutionStatement._(this.resolutionType, this.height, this.unresolved, this.resolutionEntries);

  factory ResolutionStatement(final ResolutionType resolutionType, final Uint64 height,
      final dynamic unresolved, final List<ResolutionEntry> entries) {
    ArgumentError.checkNotNull(resolutionType);
    ArgumentError.checkNotNull(unresolved);

    if (!_isValid(resolutionType, unresolved, entries)) {
      throw new ArgumentError('Invalid ResolutionStatement: ['
          'resolutionType="$resolutionType",'
          'unresolvedObject="$unresolved",'
          'resolutionEntries="$entries",'
          ']');
    }
    return ResolutionStatement._(resolutionType, height, unresolved, entries);
  }

  /// Generates the receipt hash for a given [networkType].
  String generateHash(final NetworkType networkType) {
    // version
    ByteData versionData = ByteData(2);
    versionData.setUint16(0, ReceiptVersion.RESOLUTION_STATEMENT.value, Endian.little);
    final Uint8List versionBytes = versionData.buffer.asUint8List();

    // type
    final ReceiptType type = resolutionType.isAddress
        ? ReceiptType.ADDRESS_ALIAS_RESOLUTION
        : ReceiptType.MOSAIC_ALIAS_RESOLUTION;
    ByteData typeData = ByteData(2);
    typeData.setUint16(0, type.value, Endian.little);
    final Uint8List typeBytes = typeData.buffer.asUint8List();

    // unresolved part
    final Uint8List unresolvedBytes = _getUnresolvedBytes(networkType);

    // entry bytes
    List<int> results = [];
    results.addAll(versionBytes.toList());
    results.addAll(typeBytes.toList());
    results.addAll(unresolvedBytes.toList());

    resolutionEntries.forEach((entry) {
      final Uint8List bytes = entry.serialize();
      results.addAll(bytes.toList());
    });
    final resultsBytes = Uint8List.fromList(results);

    final Uint8List hash =
        SHA3Hasher.hash(resultsBytes, SignSchema.SHA3, SignSchema.HASH_SIZE_32_BYTES);
    return HexUtils.bytesToHex(hash).toUpperCase();
  }

  /// Returns a resolution entry for given [primaryId] and [secondaryId].
  ///
  /// May return null when no matched entry can be found.
  ResolutionEntry getResolutionEntryById(int primaryId, int secondaryId) {
    // Primary id and secondary id do not specifically map to the exact transaction index on
    // the same block. The ids are just the order of the resolution reflecting on the order of
    // transactions (ordered by index).
    // E.g. 1 - Bob -> 1 random.token -> Alice
    //      2 - Carol -> 1 random.token > Denis
    // Based on above example, 2 transactions (index 0 & 1) are created on the same block, however,
    // only 1 resolution entry get generated for both.
    final int resolvedPrimaryId = _getMaxAvailablePrimaryId(primaryId);

    // If no primaryId found, it means there's no resolution entry available for the process.
    // Invalid entry.
    // E.g. Given:
    // Entries: [{P:2, S:0}, {P:5, S:6}]
    // Transaction: [Inx:1(0+1), AggInx:0]
    // It should return Entry: null
    if (resolvedPrimaryId == 0) {
      return null;
    } else if (primaryId > resolvedPrimaryId) {
      // If the transaction index is greater than the overall most recent source primary id.
      // Use the most recent resolution entry (Max.PrimaryId + Max.SecondaryId)
      //
      // e.g. Given:
      // Entries: [{P:1, S:0}, {P:2, S:0}, {P:4, S:2}, {P:4, S:4} {P:7, S:6}]
      // Transaction: [Inx:5(4+1), AggInx:0]
      //  It should return Entry: {P:4, S:4}
      //
      // e.g. Given:
      // Entries: [{P:1, S:0}, {P:2, S:0}, {P:4, S:2}, {P:4, S:4}, {P:7, S:6}]
      // Transaction: [Inx:3(2+1), AggInx:0]
      // It should return Entry: {P:2, S:0}
      return resolutionEntries.firstWhere((entry) =>
          entry.source.primaryId == resolvedPrimaryId &&
          entry.source.secondaryId == _getMaxSecondaryIdByPrimaryId(resolvedPrimaryId));
    }

    // When transaction index matches a primaryId, get the most recent secondaryId
    // (resolvedPrimaryId can only <= primaryId)
    final int resolvedSecondaryId =
        _getMaxSecondaryIdByPrimaryIdAndSecondaryId(resolvedPrimaryId, secondaryId);

    // If no most recent secondaryId matched transaction index, find previous resolution entry
    // (most recent). This means the resolution entry for the specific inner transaction (inside
    // Aggregate) was generated previously outside the aggregate. It should return the previous
    // entry (previous primaryId)
    //
    // e.g. Given:
    // Entries: [{P:1, S:0}, {P:2, S:0}, {P:5, S:6}]
    // Transaction: [Inx:5(4+1), AggInx:3(2+1)]
    // It should return Entry: {P:2, S:0}
    if (resolvedSecondaryId == 0 && resolvedSecondaryId != secondaryId) {
      final int lastPrimaryId = _getMaxAvailablePrimaryId(resolvedPrimaryId - 1);
      return resolutionEntries.firstWhere((entry) =>
          entry.source.primaryId == lastPrimaryId &&
          entry.source.secondaryId == _getMaxSecondaryIdByPrimaryId(lastPrimaryId));
    }

    // Found a matched resolution entry on both primaryId and secondaryId
    //
    // e.g. Given:
    // Entries: [{P:1, S:0}, {P:2, S:0}, {P:5, S:6}]
    // Transaction: [Inx:5(4+1), AggInx:6(2+1)]
    // It should return Entry: {P:5, S:6}
    return this.resolutionEntries.firstWhere((entry) =>
        entry.source.primaryId == resolvedPrimaryId &&
        entry.source.secondaryId == resolvedSecondaryId);
  }

  // ------------------------------ private / protected functions ------------------------------ //

  /// Validates an unresolved object against a list of resolution entry.
  ///
  /// The [unresolved] object must either be an [Address], a [MosaicId] or a [NamespaceId].
  static bool _isValid(
      ResolutionType resolutionType, dynamic unresolved, List<ResolutionEntry> entries) {
    final bool isUnresolvedAddress =
        unresolved is Address || unresolved is NamespaceId ? true : false;
    final bool isUnresolvedMosaic =
        unresolved is MosaicId || unresolved is NamespaceId ? true : false;

    if (!isUnresolvedAddress && !isUnresolvedMosaic) {
      return false;
    }

    if (resolutionType.isAddress && !isUnresolvedAddress) {
      return false;
    }

    if (resolutionType.isMosaic && !isUnresolvedMosaic) {
      return false;
    }

    for (var entry in entries) {
      if (isUnresolvedAddress && (entry.resolved is Address || entry.resolved is NamespaceId)) {
        // OK. Match found.
        return true;
      }
      if (isUnresolvedMosaic && (entry.resolved is MosaicId || entry.resolved is NamespaceId)) {
        // OK. Match found.
        return true;
      }
    }

    // No match found.
    return false;
  }

  /// Returns the artifactId value as [Uint64].
  Uint64 _getArtifactIdValue() {
    if (unresolved is! Id) {
      throw new StateError('unresolved should be a valid artifactId');
    }

    return (unresolved as Id).id;
  }

  /// Generates unresolved bytes for a given [networkType].
  Uint8List _getUnresolvedBytes(final NetworkType networkType) {
    // address resolution
    if (resolutionType.isAddress) {
      return UnresolvedUtils.toUnresolvedAddressBytes(unresolved, networkType);
    }

    // mosaic resolution
    // the buffer size for a big integer value is 8
    ByteData data = new ByteData(8);
    final Uint64 artifactIdValue = _getArtifactIdValue();
    final ByteData idData = ByteData.view(artifactIdValue.toBytes().buffer);
    data.setUint64(0, idData.getUint64(0));

    return data.buffer.asUint8List();
  }

  /// Get most `recent` primary source id by a given id (transaction index) as PrimaryId might not
  /// be the same as block transaction index.
  int _getMaxAvailablePrimaryId(int primaryId) {
    return resolutionEntries
        .map((entry) => primaryId >= entry.source.primaryId ? entry.source.primaryId : 0)
        .reduce(max);
  }

  /// Get max secondary id by a given [primaryId].
  int _getMaxSecondaryIdByPrimaryId(int primaryId) {
    return resolutionEntries
        .where((entry) => entry.source.primaryId == primaryId)
        .map((filtered) => filtered.source.secondaryId)
        .reduce(max);
  }

  /// Get most `recent` available secondary id by a given primaryId.
  int _getMaxSecondaryIdByPrimaryIdAndSecondaryId(int primaryId, int secondaryId) {
    return resolutionEntries
        .where((entry) => entry.source.primaryId == primaryId)
        .map((filtered) =>
            secondaryId >= filtered.source.secondaryId ? filtered.source.secondaryId : 0)
        .reduce(max);
  }
}
