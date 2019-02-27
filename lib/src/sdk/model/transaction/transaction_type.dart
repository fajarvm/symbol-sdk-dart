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
  //
  // Mosaic
  //
  /// Register a new mosaic.
  static const int MOSAIC_DEFINITION = 0x414d;

  /// Change an existent mosaic supply.
  static const int MOSAIC_SUPPLY_CHANGE = 0x424d;

  /// Change the levy of a mosaic.
  static const int MOSAIC_LEVY_CHANGE = 0x434d;

  //
  // Namespace
  //
  /// Register a namespace.
  static const int NAMESPACE_REGISTRATION = 0x414e;

  /// Attach a namespace name to an account.
  static const int NAMESPACE_ATTACH_TO_ACCOUNT = 0x424e;

  /// Attach a namespace name to a mosaic.
  static const int NAMESPACE_ATTACH_TO_MOSAIC = 0x434e;

  //
  // Transfer
  //
  /// Transfer mosaics and messages between two accounts.
  static const int TRANSFER = 0x4154;

  //
  // Multi-signature
  //
  /// Create or modify a multi-signature contract.
  static const int MULTISIG_MODIFY = 0x4155;

  /// Send transactions in batches to different accounts.
  ///
  /// An aggregate transaction is complete when all the required participants have signed it.
  static const int MULTISIG_AGGREGATE_COMPLETE = 0x4141;

  /// Propose many transactions between different accounts.
  ///
  /// An aggregate transaction is bonded when it requires signatures from other participants.
  static const int MULTISIG_AGGREGATE_BONDED = 0x4241;

  /// As deposit before announcing aggregate bonded transactions.
  static const int MULTISIG_HASH_LOCK = 0x4148;

  //
  // Account filters
  //
  /// Allow or block incoming transactions for a given a set of addresses.
  static const int ACCOUNT_FILTER_ADDRESS = 0x4150;

  /// Allow or block incoming transactions containing a given set of mosaics.
  static const int ACCOUNT_FILTER_MOSAIC = 0x4250;

  /// Allow or block incoming transactions by transaction type.
  static const int ACCOUNT_FILTER_ENTITY_TYPE = 0x4350;

  //
  // Cross-chain swaps
  //
  /// The secret lock transaction type.
  static const int SECRET_LOCK = 0x424C; // TODO: new id is 0x4152 according to nemtech

  /// The secret proof transaction type.
  static const int SECRET_PROOF = 0x434C; // TODO: new id is 0x4252 according to nemtech

  //
  // Account link / Remote harvesting
  //
  /// Delegates the account importance to a proxy account to enable delegated harvesting.
  static const int LOCK_FUND = 0x414C;

  static final TransactionType singleton = new TransactionType._();

  TransactionType._();

  factory TransactionType() {
    return singleton;
  }

  static int getTransactionType(final int transactionType) {
    switch (transactionType) {
      case ACCOUNT_FILTER_ADDRESS:
        return TransactionType.ACCOUNT_FILTER_ADDRESS;
      case ACCOUNT_FILTER_ENTITY_TYPE:
        return TransactionType.ACCOUNT_FILTER_ENTITY_TYPE;
      case ACCOUNT_FILTER_MOSAIC:
        return TransactionType.ACCOUNT_FILTER_MOSAIC;
      case MOSAIC_DEFINITION:
        return TransactionType.MOSAIC_DEFINITION;
      case MOSAIC_LEVY_CHANGE:
        return TransactionType.MOSAIC_LEVY_CHANGE;
      case MOSAIC_SUPPLY_CHANGE:
        return TransactionType.MOSAIC_SUPPLY_CHANGE;
      case NAMESPACE_REGISTRATION:
        return TransactionType.NAMESPACE_REGISTRATION;
      case NAMESPACE_ATTACH_TO_ACCOUNT:
        return TransactionType.NAMESPACE_ATTACH_TO_ACCOUNT;
      case NAMESPACE_ATTACH_TO_MOSAIC:
        return TransactionType.NAMESPACE_ATTACH_TO_MOSAIC;
      case TRANSFER:
        return TransactionType.TRANSFER;
      case MULTISIG_MODIFY:
        return TransactionType.MULTISIG_MODIFY;
      case MULTISIG_AGGREGATE_BONDED:
        return TransactionType.MULTISIG_AGGREGATE_BONDED;
      case MULTISIG_AGGREGATE_COMPLETE:
        return TransactionType.MULTISIG_AGGREGATE_COMPLETE;
      case MULTISIG_HASH_LOCK:
        return TransactionType.MULTISIG_HASH_LOCK;
      case LOCK_FUND:
        return TransactionType.LOCK_FUND;
      case SECRET_LOCK:
        return TransactionType.SECRET_LOCK;
      case SECRET_PROOF:
        return TransactionType.SECRET_PROOF;
      default:
        throw new ArgumentError('invalid transaction type');
    }
  }
}
