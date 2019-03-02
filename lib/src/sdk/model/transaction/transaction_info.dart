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

library nem2_sdk_dart.sdk.model.transaction.transaction_info;

import 'uint64.dart';

/// The transaction information model included in all transactions.
class TransactionInfo {
  /// The block height in which the transaction was included.
  final Uint64 height;

  /// The index representing either transaction index/position within a block or within an
  /// aggregate transaction.
  final int index;

  /// The transaction id.
  final String id;

  /// The transaction hash.
  final String hash;

  /// The transaction merkle component hash.
  final String merkleComponentHash;

  /// The hash of the aggregate transaction.
  final String aggregateHash;

  /// The id of the aggregate transaction.
  final String aggregateId;

  // private constructor
  TransactionInfo._(this.height, this.index, this.id, this.hash, this.merkleComponentHash,
      this.aggregateHash, this.aggregateId);

  /// Creates transaction info object for aggregate transaction inner transaction.
  static TransactionInfo createAggregate(final Uint64 height, final int index, final String id,
      final String aggregateHash, final String aggregateId) {
    return TransactionInfo._(height, index, id, null, null, aggregateHash, aggregateId);
  }

  /// Creates transaction info object as that is retrieved by listener OR for a transaction.
  ///
  /// Provide the [index] and the [id] to create a transaction info for a transaction. If they are
  /// not provided, a transaction info as retrieved by listener will be created.
  static TransactionInfo create(
      final Uint64 height, final String hash, final String merkleComponentHash,
      {final int index, final String id}) {
    if ((index != null || id != null) && (index == null || id == null)) {
      throw new ArgumentError(
          'Both the index and the id are required to create a transaction info for a transaction.');
    }

    return TransactionInfo._(height, index, id, hash, merkleComponentHash, null, null);
  }
}
