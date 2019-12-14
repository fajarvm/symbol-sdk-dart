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
class ResolutionStatement<T> {
  /// The type of this resolution.
  final ResolutionType resolutionType;

  /// The block height.
  final Uint64 height;

  /// The unresolved object. It must be either an [Address], a [MosaicId] or a [NamespaceId].
  final T unresolved;

  /// A list of resolution entries linked to the unresolved object.
  ///
  /// It is a list instead of a single UInt64 field since within one block the resolution might
  /// change for different sources due to alias related transactions.
  final List<ResolutionEntry> resolutionEntries;

  // private constructor
  ResolutionStatement._(this.resolutionType, this.height, this.unresolved, this.resolutionEntries);

  factory ResolutionStatement(
      ResolutionType resolutionType, Uint64 height, T unresolved, List<ResolutionEntry> entries) {
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
    ByteData data = new ByteData(12);
    // version part
    data.setUint16(0, ReceiptVersion.RESOLUTION_STATEMENT.value, Endian.little);

    // type part
    final ReceiptType receiptType = resolutionType.isAddress
        ? ReceiptType.ADDRESS_ALIAS_RESOLUTION
        : ReceiptType.MOSAIC_ALIAS_RESOLUTION;
    data.setUint16(2, receiptType.value, Endian.little);

    // unresolved part
    final Uint8List unresolvedBytes = _getResolvedBytes(networkType);
    final ByteData idData = ByteData.view(unresolvedBytes.buffer);
    data.setUint64(4, idData.getUint64(0));

    // entry bytes
    List<int> input;
    resolutionEntries.forEach((entry) {
      final Uint8List bytes = entry.serialize();
      input.addAll(bytes.toList());
    });

    // hash SHA3-256
    final Uint8List hash =
        SHA3Hasher.hash(Uint8List.fromList(input), SignSchema.SHA3, SignSchema.HASH_SIZE_32_BYTES);
    return HexUtils.bytesToHex(hash).toUpperCase();
  }

  // ------------------------------ private / protected functions ------------------------------ //

  /// Validates an unresolved object against a list of resolution entry.
  ///
  /// The [unresolved] object must either be an [Address], a [MosaicId] or a [NamespaceId].
  static bool _isValid(
      ResolutionType resolutionType, dynamic unresolved, List<ResolutionEntry> entries) {
    final bool isUnresolvedAddress = unresolved is Address ? true : false;
    final bool isUnresolvedMosaic = unresolved is MosaicId ? true : false;

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

    return Uint64.fromHex((unresolved as Id).toHex());
  }

  /// Generates unresolved bytes for a given [networkType].
  Uint8List _getResolvedBytes(final NetworkType networkType) {
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
}
