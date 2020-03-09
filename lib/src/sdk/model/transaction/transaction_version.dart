//
// Copyright (c) 2020 Fajar van Megen
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

library symbol_sdk_dart.sdk.model.transaction.transaction_version;

/// The format version of the available transaction types.
class TransactionVersion {
  //
  // Mosaic
  //
  /// Register a new mosaic.
  static const TransactionVersion MOSAIC_DEFINITION = TransactionVersion._(1);

  /// Change an existent mosaic supply.
  static const TransactionVersion MOSAIC_SUPPLY_CHANGE = TransactionVersion._(1);

  //
  // Namespace
  //
  /// Register a namespace.
  static const TransactionVersion NAMESPACE_REGISTRATION = TransactionVersion._(1);

  /// Attach a namespace name to an account.
  static const TransactionVersion ADDRESS_ALIAS = TransactionVersion._(1);

  /// Attach a namespace name to a mosaic.
  static const TransactionVersion MOSAIC_ALIAS = TransactionVersion._(1);

  //
  // Transfer
  //
  /// Transfer mosaics and messages between two accounts.
  static const TransactionVersion TRANSFER = TransactionVersion._(1);

  //
  // Multi-signature
  //
  /// Create or modify a multi-signature contract.
  static const TransactionVersion MODIFY_MULTISIG_ACCOUNT = TransactionVersion._(1);

  //
  // Aggregate
  //
  /// Send transactions in batches to different accounts.
  static const TransactionVersion AGGREGATE_COMPLETE = TransactionVersion._(1);

  /// Propose many transactions between different accounts.
  static const TransactionVersion AGGREGATE_BONDED = TransactionVersion._(1);

  //
  // Hash lock / Lock funds
  //
  /// Lock the funds to allow deposit before announcing aggregate bonded transactions.
  static const TransactionVersion LOCK = TransactionVersion._(1);

  //
  // Cross-chain swaps
  //
  /// The secret lock transaction type.
  static const TransactionVersion SECRET_LOCK = TransactionVersion._(1);

  /// The secret proof transaction type.
  static const TransactionVersion SECRET_PROOF = TransactionVersion._(1);

  //
  // Account filters
  //
  /// Allow or block incoming transactions for a given a set of addresses.
  static const TransactionVersion ACCOUNT_RESTRICTION_ADDRESS = TransactionVersion._(1);

  /// Allow or block incoming transactions containing a given set of mosaics.
  static const TransactionVersion ACCOUNT_RESTRICTION_MOSAIC = TransactionVersion._(1);

  /// Allow or block incoming transactions by transaction type.
  static const TransactionVersion ACCOUNT_RESTRICTION_OPERATION = TransactionVersion._(1);

  //
  // Account link / Remote harvesting
  //
  /// Delegates the account importance to a proxy account to enable delegated harvesting.
  static const TransactionVersion ACCOUNT_LINK = TransactionVersion._(1);

  //
  // Mosaic restriction
  //
  /// Allow or block mosaic transaction from a certain address.
  static const TransactionVersion MOSAIC_RESTRICTION_ADDRESS = TransactionVersion._(1);

  /// Allow or block mosaic transaction globally.
  static const TransactionVersion MOSAIC_RESTRICTION_GLOBAL = TransactionVersion._(1);

  //
  // Metadata
  //
  /// Associate a key-value state to an account.
  static const TransactionVersion METADATA_ACCOUNT = TransactionVersion._(1);

  /// Associate a key-value state to a mosaic.
  static const TransactionVersion METADATA_MOSAIC = TransactionVersion._(1);

  /// Associate a key-value state to a namespace.
  static const TransactionVersion METADATA_NAMESPACE = TransactionVersion._(1);

  /// The int value of this version.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const TransactionVersion._(this.value);

  @override
  String toString() {
    return 'TransactionVersion{value: $value}';
  }
}
