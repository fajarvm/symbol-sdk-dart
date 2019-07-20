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

library nem2_sdk_dart.sdk.model.transaction.transaction_type;

/// The available transaction types.
class TransactionType {
  static const String UNKNOWN_TRANSACTION_TYPE = 'unknown transaction type';

  //
  // Mosaic
  //
  /// Register a new mosaic.
  static const TransactionType MOSAIC_DEFINITION = TransactionType._(0x414D);

  /// Change an existent mosaic supply.
  static const TransactionType MOSAIC_SUPPLY_CHANGE = TransactionType._(0x424D);

  //
  // Namespace
  //
  /// Register a namespace.
  static const TransactionType NAMESPACE_REGISTRATION = TransactionType._(0x414E);

  /// Attach a namespace name to an account.
  static const TransactionType NAMESPACE_ATTACH_TO_ACCOUNT = TransactionType._(0x424E);

  /// Attach a namespace name to a mosaic.
  static const TransactionType NAMESPACE_ATTACH_TO_MOSAIC = TransactionType._(0x434E);

  //
  // Transfer
  //
  /// Transfer mosaics and messages between two accounts.
  static const TransactionType TRANSFER = TransactionType._(0x4154);

  //
  // Multi-signature
  //
  /// Create or modify a multi-signature contract.
  static const TransactionType MULTISIG_MODIFY = TransactionType._(0x4155);

  //
  // Aggregate
  //
  /// Send transactions in batches to different accounts.
  ///
  /// An aggregate transaction is complete when all the required participants have signed it.
  static const TransactionType AGGREGATE_COMPLETE = TransactionType._(0x4141);

  /// Propose many transactions between different accounts.
  ///
  /// An aggregate transaction is bonded when it requires signatures from other participants.
  static const TransactionType AGGREGATE_BONDED = TransactionType._(0x4241);

  //
  // Hash lock / Lock funds
  //
  /// Lock the funds to allow deposit before announcing aggregate bonded transactions.
  ///
  /// Announce a hash lock transaction before sending a signed aggregate bonded transaction.
  /// This mechanism is required to prevent network spamming.
  static const TransactionType HASH_LOCK = TransactionType._(0x4148);

  //
  // Account filters
  //
  /// Allow or block incoming transactions for a given a set of addresses.
  static const TransactionType ACCOUNT_FILTER_ADDRESS = TransactionType._(0x4150);

  /// Allow or block incoming transactions containing a given set of mosaics.
  static const TransactionType ACCOUNT_FILTER_MOSAIC = TransactionType._(0x4250);

  /// Allow or block incoming transactions by transaction type.
  static const TransactionType ACCOUNT_FILTER_ENTITY_TYPE = TransactionType._(0x4350);

  //
  // Cross-chain swaps
  //
  /// The secret lock transaction type.
  static const TransactionType SECRET_LOCK = TransactionType._(0x4152);

  /// The secret proof transaction type.
  static const TransactionType SECRET_PROOF = TransactionType._(0x4252);

  //
  // Account link / Remote harvesting
  //
  /// Delegates the account importance to a proxy account to enable delegated harvesting.
  static const TransactionType ACCOUNT_LINK = TransactionType._(0x414C);

  static final List<TransactionType> values = <TransactionType>[
    MOSAIC_DEFINITION,
    MOSAIC_SUPPLY_CHANGE,
    NAMESPACE_REGISTRATION,
    NAMESPACE_ATTACH_TO_ACCOUNT,
    NAMESPACE_ATTACH_TO_MOSAIC,
    TRANSFER,
    MULTISIG_MODIFY,
    AGGREGATE_COMPLETE,
    AGGREGATE_BONDED,
    HASH_LOCK,
    ACCOUNT_FILTER_ADDRESS,
    ACCOUNT_FILTER_MOSAIC,
    ACCOUNT_FILTER_ENTITY_TYPE,
    SECRET_LOCK,
    SECRET_PROOF,
    ACCOUNT_LINK
  ];

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const TransactionType._(this.value);

  /// Returns a [TransactionType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static TransactionType getType(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_TRANSACTION_TYPE);
  }

  /// Returns true if the given [transactionType] is an aggregate transaction type.
  static bool isAggregateType(final TransactionType transactionType) {
    switch (transactionType) {
      case AGGREGATE_BONDED:
      case AGGREGATE_COMPLETE:
        return true;
      default:
        return false;
    }
  }
}
