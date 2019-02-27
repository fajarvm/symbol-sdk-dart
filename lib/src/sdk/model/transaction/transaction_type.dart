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

/// The Transaction type.
class TransactionType {
  /// The aggregate bonded transaction type.
  static const int AGGREGATE_BONDED = 0x4241;

  /// The aggregate complete transaction type.
  static const int AGGREGATE_COMPLETE = 0x4141;

  /// The mosaic definition transaction type.
  static const int MOSAIC_DEFINITION = 0x414d;

  /// The mosaic levy change transaction type.
  static const int MOSAIC_LEVY_CHANGE = 0x434d;

  /// The mosaic supply change transaction type.
  static const int MOSAIC_SUPPLY_CHANGE = 0x424d;

  /// The modify multi-signature account transaction type.
  static const int MODIFY_MULTISIG_ACCOUNT = 0x4155;

  /// The register namespace transaction type.
  static const int REGISTER_NAMESPACE = 0x414e;

  /// The transfer transaction type.
  static const int TRANSFER = 0x4154;

  /// The lock fund transaction type.
  static const int LOCK_FUND = 0x414C;

  /// The secret lock transaction type.
  static const int SECRET_LOCK = 0x424C;

  /// The secret proof transaction type.
  static const int SECRET_PROOF = 0x434C;

  static final TransactionType singleton = new TransactionType._();

  TransactionType._();

  factory TransactionType() {
    return singleton;
  }

  static int getTransactionType(final int transactionType) {
    switch (transactionType) {
      case AGGREGATE_BONDED:
        return TransactionType.AGGREGATE_BONDED;
      case AGGREGATE_COMPLETE:
        return TransactionType.AGGREGATE_COMPLETE;
      case MOSAIC_DEFINITION:
        return TransactionType.MOSAIC_DEFINITION;
      case MOSAIC_LEVY_CHANGE:
        return TransactionType.MOSAIC_LEVY_CHANGE;
      case MOSAIC_SUPPLY_CHANGE:
        return TransactionType.MOSAIC_SUPPLY_CHANGE;
      case MODIFY_MULTISIG_ACCOUNT:
        return TransactionType.MODIFY_MULTISIG_ACCOUNT;
      case REGISTER_NAMESPACE:
        return TransactionType.REGISTER_NAMESPACE;
      case TRANSFER:
        return TransactionType.TRANSFER;
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
