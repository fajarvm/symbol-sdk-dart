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

library nem2_sdk_dart.sdk.model.transaction.transaction_version;

/// The format version of the available transaction types.
class TransactionVersion {
  //
  // Mosaic
  //
  /// Register a new mosaic.
  static const TransactionVersion MOSAIC_DEFINITION = TransactionVersion._(3);

  /// Change an existent mosaic supply.
  static const TransactionVersion MOSAIC_SUPPLY_CHANGE = TransactionVersion._(2);

  /// Change the levy of a mosaic.
  static const TransactionVersion MOSAIC_LEVY_CHANGE = TransactionVersion._(1);

  //
  // Namespace
  //
  /// Register a namespace.
  static const TransactionVersion NAMESPACE_REGISTRATION = TransactionVersion._(2);

  /// Attach a namespace name to an account.
  static const TransactionVersion NAMESPACE_ATTACH_TO_ACCOUNT = TransactionVersion._(1);

  /// Attach a namespace name to a mosaic.
  static const TransactionVersion NAMESPACE_ATTACH_TO_MOSAIC = TransactionVersion._(1);

  //
  // Transfer
  //
  /// Transfer mosaics and messages between two accounts.
  static const TransactionVersion TRANSFER = TransactionVersion._(3);

  //
  // Multi-signature
  //
  /// Create or modify a multi-signature contract.
  static const TransactionVersion MULTISIG_MODIFY = TransactionVersion._(3);

  //
  // Aggregate
  //
  /// Send transactions in batches to different accounts.
  static const TransactionVersion AGGREGATE_COMPLETE = TransactionVersion._(2);

  /// Propose many transactions between different accounts.
  static const TransactionVersion AGGREGATE_BONDED = TransactionVersion._(2);

  //
  // Hash lock / Lock funds
  //
  /// Lock the funds to allow deposit before announcing aggregate bonded transactions.
  static const TransactionVersion HASH_LOCK = TransactionVersion._(1);

  //
  // Account filters
  //
  /// Allow or block incoming transactions for a given a set of addresses.
  static const TransactionVersion ACCOUNT_FILTER_ADDRESS = TransactionVersion._(1);

  /// Allow or block incoming transactions containing a given set of mosaics.
  static const TransactionVersion ACCOUNT_FILTER_MOSAIC = TransactionVersion._(1);

  /// Allow or block incoming transactions by transaction type.
  static const TransactionVersion ACCOUNT_FILTER_ENTITY_TYPE = TransactionVersion._(1);

  //
  // Cross-chain swaps
  //
  /// The secret lock transaction type.
  static const TransactionVersion SECRET_LOCK = TransactionVersion._(1);

  /// The secret proof transaction type.
  static const TransactionVersion SECRET_PROOF = TransactionVersion._(1);

  //
  // Account link / Remote harvesting
  //
  /// Delegates the account importance to a proxy account to enable delegated harvesting.
  static const TransactionVersion ACCOUNT_LINK = TransactionVersion._(2);

  final int _value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const TransactionVersion._(this._value);

  /// The int value of this version.
  int get value => _value;
}
