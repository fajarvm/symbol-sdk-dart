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

library nem2_sdk_dart.test.sdk.model.transaction.transaction_type_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show TransactionType;

void main() {
  group('TransactionType', () {
    test('valid transaction types', () {
      expect(TransactionType.AGGREGATE_BONDED, 0x4241);
      expect(TransactionType.AGGREGATE_COMPLETE, 0x4141);
      expect(TransactionType.MOSAIC_DEFINITION, 0x414d);
      expect(TransactionType.MOSAIC_LEVY_CHANGE, 0x434d);
      expect(TransactionType.MOSAIC_SUPPLY_CHANGE, 0x424d);
      expect(TransactionType.MODIFY_MULTISIG_ACCOUNT, 0x4155);
      expect(TransactionType.REGISTER_NAMESPACE, 0x414e);
      expect(TransactionType.TRANSFER, 0x4154);
      expect(TransactionType.LOCK_FUND, 0x414C);
      expect(TransactionType.SECRET_LOCK, 0x424C);
      expect(TransactionType.SECRET_PROOF, 0x434C);
    });

    test('Can retrieve a valid transaction types', () {
      expect(TransactionType.getTransactionType(0x4241), TransactionType.AGGREGATE_BONDED);
      expect(TransactionType.getTransactionType(0x4141), TransactionType.AGGREGATE_COMPLETE);
      expect(TransactionType.getTransactionType(0x414d), TransactionType.MOSAIC_DEFINITION);
      expect(TransactionType.getTransactionType(0x434d), TransactionType.MOSAIC_LEVY_CHANGE);
      expect(TransactionType.getTransactionType(0x424d), TransactionType.MOSAIC_SUPPLY_CHANGE);
      expect(TransactionType.getTransactionType(0x4155), TransactionType.MODIFY_MULTISIG_ACCOUNT);
      expect(TransactionType.getTransactionType(0x414e), TransactionType.REGISTER_NAMESPACE);
      expect(TransactionType.getTransactionType(0x4154), TransactionType.TRANSFER);
      expect(TransactionType.getTransactionType(0x414C), TransactionType.LOCK_FUND);
      expect(TransactionType.getTransactionType(0x424C), TransactionType.SECRET_LOCK);
      expect(TransactionType.getTransactionType(0x434C), TransactionType.SECRET_PROOF);
    });

    test('Trying to retrieve an invalid transaction type will throw an error', () {
      expect(() => TransactionType.getTransactionType(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'invalid transaction type')));
      expect(() => TransactionType.getTransactionType(0x0000),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'invalid transaction type')));
    });
  });
}
