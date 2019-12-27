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

library nem2_sdk_dart.sdk.model.receipt.statement;

import '../account/address.dart';
import '../mosaic/mosaic.dart';
import '../mosaic/mosaic_id.dart';
import '../namespace/namespace_id.dart';
import 'resolution_entry.dart';
import 'resolution_statement.dart';
import 'resolution_type.dart';
import 'transaction_statement.dart';

/// This class hold multiple lists of statements.
class Statement {
  /// A collection of transaction statements.
  final List<TransactionStatement> transactionStatements;

  /// A collection of address resolution statements.
  final List<ResolutionStatement> addressResolutionStatements;

  /// A collection of mosaic resolution statements.
  final List<ResolutionStatement> mosaicResolutionStatements;

  Statement(this.transactionStatements, this.addressResolutionStatements,
      this.mosaicResolutionStatements);

  /// Resolve an [unresolvedAddress] from a statement object.
  dynamic resolveAddress(final dynamic unresolvedAddress, String height, int transactionIndex,
      [int aggregateTransactionIndex = 0]) {
    if (unresolvedAddress is Address) {
      // return as it is
      return unresolvedAddress;
    }

    if (unresolvedAddress is NamespaceId) {
      // resolve the unresolved address object
      return _resolve(
          type: ResolutionType.ADDRESS,
          height: height,
          unresolved: unresolvedAddress,
          transactionIndex: transactionIndex,
          aggregateTransactionIndex: aggregateTransactionIndex) as Address;
    }

    throw new StateError('Invalid type of unresolvedAddress. '
        'An Address or NamespaceId is expected. '
        'Received: $unresolvedAddress');
  }

  /// Resolve an [unresolvedMosaicId] from a statement object.
  dynamic resolveMosaicId(final dynamic unresolvedMosaicId, String height, int transactionIndex,
      [int aggregateTransactionIndex = 0]) {
    if (unresolvedMosaicId is MosaicId) {
      // return as it is
      return unresolvedMosaicId;
    }

    if (unresolvedMosaicId is NamespaceId) {
      // resolve the unresolved mosaic object
      return _resolve(
          type: ResolutionType.MOSAIC,
          height: height,
          unresolved: unresolvedMosaicId,
          transactionIndex: transactionIndex,
          aggregateTransactionIndex: aggregateTransactionIndex) as MosaicId;
    }

    throw new StateError('Invalid type of unresolvedMosaicId. '
        'A MosaicId or NamespaceId is expected. '
        'Received: $unresolvedMosaicId');
  }

  /// Resolve an [unresolvedMosaic] from a statement object.
  dynamic resolveMosaic(final Mosaic unresolvedMosaic, String height, int transactionIndex,
      [int aggregateTransactionIndex = 0]) {
    ArgumentError.checkNotNull(unresolvedMosaic);

    MosaicId mosaicId;
    if (unresolvedMosaic.id is MosaicId) {
      mosaicId = unresolvedMosaic.id;
    }

    if (unresolvedMosaic.id is NamespaceId) {
      // resolve the unresolved mosaic object
      mosaicId = _resolve(
          type: ResolutionType.MOSAIC,
          height: height,
          unresolved: unresolvedMosaic.id as NamespaceId,
          transactionIndex: transactionIndex,
          aggregateTransactionIndex: aggregateTransactionIndex) as MosaicId;
    }

    return new Mosaic(mosaicId, unresolvedMosaic.amount);
  }

  // ------------------------------ private / protected functions ------------------------------ //

  /// Resolves an [unresolved] object of the given [type] with the given block [height],
  /// [transactionIndex] and optionally [aggregateTransactionIndex]. The Default value for
  /// [aggregateTransactionIndex] is 0.
  dynamic _resolve(
      {ResolutionType type,
      NamespaceId unresolved,
      String height,
      int transactionIndex,
      int aggregateTransactionIndex}) {
    ArgumentError.checkNotNull(type);
    ArgumentError.checkNotNull(unresolved);
    ArgumentError.checkNotNull(height);

    // Determines which resolution statements we look into
    List<ResolutionStatement> resolutionStatements;
    if (ResolutionType.ADDRESS == type) {
      resolutionStatements = addressResolutionStatements;
    } else if (ResolutionType.MOSAIC == type) {
      resolutionStatements = mosaicResolutionStatements;
    } else {
      throw new ArgumentError('unsupported resolution type: $type');
    }

    final ResolutionStatement resolutionStatement = resolutionStatements.firstWhere(
        (statement) =>
            statement.resolutionType == type &&
            statement.height.toString() == height &&
            statement.unresolved is NamespaceId &&
            statement.unresolved == unresolved,
        orElse: () => throw new ArgumentError('No resolution statement found on block: $height '
            'for unresolved: ${unresolved.toHex()}'));

    // If only one entry exists on the statement, just return
    if (resolutionStatement.resolutionEntries.length == 1) {
      return resolutionStatement.resolutionEntries[0].resolved;
    }

    // Get the most recent resolution entry
    final ResolutionEntry entry = resolutionStatement.getResolutionEntryById(
        aggregateTransactionIndex == null ? transactionIndex + 1 : aggregateTransactionIndex + 1,
        aggregateTransactionIndex == null ? 0 : transactionIndex + 1);
    if (entry == null) {
      throw new ArgumentError(
          'No resolution entry found on block: $height for unresolved: ${unresolved.toHex()}');
    }

    return entry.resolved;
  }
}
