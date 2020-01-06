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

  /// Attach a namespace name to an address.
  static const TransactionType ADDRESS_ALIAS = TransactionType._(0x424E);

  /// Attach a namespace name to a mosaic.
  static const TransactionType MOSAIC_ALIAS = TransactionType._(0x434E);

  //
  // Transfer
  //
  /// Send mosaics and messages between two accounts.
  static const TransactionType TRANSFER = TransactionType._(0x4154);

  //
  // Multi-signature
  //
  /// Create or modify a multi-signature contract.
  static const TransactionType MODIFY_MULTISIG_ACCOUNT = TransactionType._(0x4155);

  //
  // Aggregate
  //
  /// Send transactions in batches to different accounts.
  ///
  /// An aggregate transaction is complete when all the required participants have signed it.
  static const TransactionType AGGREGATE_COMPLETE = TransactionType._(0x4141);

  /// Propose an arrangement of transactions between different accounts.
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
  static const TransactionType LOCK = TransactionType._(0x4148);

  //
  // Cross-chain swaps
  //
  /// Start a token swap between different chains.
  static const TransactionType SECRET_LOCK = TransactionType._(0x4152);

  /// Conclude a token swap between different chains.
  static const TransactionType SECRET_PROOF = TransactionType._(0x4252);

  //
  // Account restriction
  //
  /// Allow or block incoming and outgoing transactions for a given a set of addresses.
  static const TransactionType ACCOUNT_RESTRICTION_ADDRESS = TransactionType._(0x4150);

  /// Allow or block incoming transactions containing a given set of mosaics.
  static const TransactionType ACCOUNT_RESTRICTION_MOSAIC = TransactionType._(0x4250);

  /// Allow or block outgoing transactions by transaction type.
  static const TransactionType ACCOUNT_RESTRICTION_OPERATION = TransactionType._(0x4350);

  //
  // Account link / Remote harvesting
  //
  /// Delegate the account importance to a proxy account to enable delegated harvesting.
  static const TransactionType ACCOUNT_LINK = TransactionType._(0x414C);

  //
  // Mosaic restriction
  //
  /// Set a mosaic restriction to an specific address.
  static const TransactionType MOSAIC_RESTRICTION_ADDRESS = TransactionType._(0x4251);

  /// Set a global restriction to a mosaic.
  static const TransactionType MOSAIC_RESTRICTION_GLOBAL = TransactionType._(0x4151);

  //
  // Metadata
  //
  /// Associate a key-value state to an account.
  static const TransactionType METADATA_ACCOUNT = TransactionType._(0x4144);

  /// Associate a key-value state to a mosaic.
  static const TransactionType METADATA_MOSAIC = TransactionType._(0x4244);

  /// Associate a key-value state to a namespace.
  static const TransactionType METADATA_NAMESPACE = TransactionType._(0x4344);

  /// Supported transaction types.
  static final List<TransactionType> values = <TransactionType>[
    MOSAIC_DEFINITION,
    MOSAIC_SUPPLY_CHANGE,
    NAMESPACE_REGISTRATION,
    ADDRESS_ALIAS,
    MOSAIC_ALIAS,
    TRANSFER,
    MODIFY_MULTISIG_ACCOUNT,
    AGGREGATE_COMPLETE,
    AGGREGATE_BONDED,
    LOCK,
    SECRET_LOCK,
    SECRET_PROOF,
    ACCOUNT_RESTRICTION_ADDRESS,
    ACCOUNT_RESTRICTION_MOSAIC,
    ACCOUNT_RESTRICTION_OPERATION,
    ACCOUNT_LINK,
    MOSAIC_RESTRICTION_ADDRESS,
    MOSAIC_RESTRICTION_GLOBAL,
    METADATA_ACCOUNT,
    METADATA_MOSAIC,
    METADATA_NAMESPACE
  ];

  /// A collection of aggregate transaction types.
  static final List<TransactionType> aggregate = <TransactionType>[
    AGGREGATE_COMPLETE,
    AGGREGATE_BONDED
  ];

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const TransactionType._(this.value);

  /// Returns a [TransactionType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static TransactionType fromInt(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_TRANSACTION_TYPE);
  }

  /// Returns true if the given [type] is of an aggregate transaction type.
  static bool isAggregate(final TransactionType type) {
    return aggregate.contains(type);
  }

  @override
  String toString() {
    return 'TransactionType{value: $value}';
  }
}
