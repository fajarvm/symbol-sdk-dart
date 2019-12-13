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
import 'resolution_statement.dart';
import 'transaction_statement.dart';

/// This class hold multiple lists of statements.
class Statement {
  /// A collection of transaction statements.
  final List<TransactionStatement> transactionStatements;

  /// A collection of address resolution statements.
  final List<ResolutionStatement<Address>> addressResolutionStatements;

  /// A collection of mosaic resolution statements.
  final List<ResolutionStatement<MosaicId>> mosaicResolutionStatements;

  Statement(this.transactionStatements, this.addressResolutionStatements,
      this.mosaicResolutionStatements);

  /// Resolves an [unresolved] object using the given block [height], [transactionIndex] and
  /// optionally [aggregateTransactionIndex]. Default value for [aggregateTransactionIndex] is 0.
  ///
  /// The [unresolved] object can either be an [Address], a [Mosaic], [MosaicId] or a
  /// [NamespaceId]. The type of the object returned corresponds to the type of the given
  /// [unresolved] object.
  dynamic resolve(
      {dynamic unresolved,
      String height,
      int transactionIndex,
      int aggregateTransactionIndex = 0}) {
    // Determines which resolution statements we look into
    List<ResolutionStatement> resolutionStatements;
    if (unresolved is Address) {
      resolutionStatements = addressResolutionStatements;
    } else if (unresolved is Mosaic || unresolved is MosaicId || unresolved is NamespaceId) {
      resolutionStatements = mosaicResolutionStatements;
    } else {
      throw new ArgumentError('unsupported unresolved object: $unresolved');
    }

    // Attempt to find a resolution statement
    var resolved;
    resolutionStatements.forEach((statement) {
      if (statement.height.toString() == height && statement.unresolved == unresolved) {
        if (statement.resolutionEntries.length == 1) {
          resolved = statement.resolutionEntries[0].resolved;
        }

        statement.resolutionEntries.forEach((entry) {
          // TODO: find most recent resolution entry
        });
      }
    });

    // Can't find any resolution
    if (resolved == null) {
      throw new ArgumentError(
          'No resolution entry found on block: $height for unresolved: $unresolved');
    }
  }
}
