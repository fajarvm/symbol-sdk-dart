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
  static const int MOSAIC_DEFINITION = 3;

  /// Change an existent mosaic supply.
  static const int MOSAIC_SUPPLY_CHANGE = 2;

  /// Change the levy of a mosaic.
  static const int MOSAIC_LEVY_CHANGE = 1;

  //
  // Namespace
  //
  /// Register a namespace.
  static const int NAMESPACE_REGISTRATION = 2;

  /// Attach a namespace name to an account.
  static const int NAMESPACE_ATTACH_TO_ACCOUNT = 1;

  /// Attach a namespace name to a mosaic.
  static const int NAMESPACE_ATTACH_TO_MOSAIC = 1;

  //
  // Transfer
  //
  /// Transfer mosaics and messages between two accounts.
  static const int TRANSFER = 3;

  //
  // Multi-signature
  //
  /// Create or modify a multi-signature contract.
  static const int MULTISIG_MODIFY = 3;

  //
  // Aggregate
  //
  /// Send transactions in batches to different accounts.
  static const int AGGREGATE_COMPLETE = 2;

  /// Propose many transactions between different accounts.
  static const int AGGREGATE_BONDED = 2;

  //
  // Hash lock / Lock funds
  //
  /// Lock the funds to allow deposit before announcing aggregate bonded transactions.
  static const int HASH_LOCK = 1;

  //
  // Account filters
  //
  /// Allow or block incoming transactions for a given a set of addresses.
  static const int ACCOUNT_FILTER_ADDRESS = 1;

  /// Allow or block incoming transactions containing a given set of mosaics.
  static const int ACCOUNT_FILTER_MOSAIC = 1;

  /// Allow or block incoming transactions by transaction type.
  static const int ACCOUNT_FILTER_ENTITY_TYPE = 1;

  //
  // Cross-chain swaps
  //
  /// The secret lock transaction type.
  static const int SECRET_LOCK = 1;

  /// The secret proof transaction type.
  static const int SECRET_PROOF = 1;

  //
  // Account link / Remote harvesting
  //
  /// Delegates the account importance to a proxy account to enable delegated harvesting.
  static const int ACCOUNT_LINK = 2;

  static final TransactionVersion _singleton = new TransactionVersion._();

  TransactionVersion._();

  factory TransactionVersion() {
    return _singleton;
  }
}
