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
      // Account filters
      expect(TransactionType.ACCOUNT_FILTER_ADDRESS.value, 0x4150);
      expect(TransactionType.ACCOUNT_FILTER_MOSAIC.value, 0x4250);
      expect(TransactionType.ACCOUNT_FILTER_ENTITY_TYPE.value, 0x4350);

      // Mosaic
      expect(TransactionType.MOSAIC_DEFINITION.value, 0x414d);
      expect(TransactionType.MOSAIC_SUPPLY_CHANGE.value, 0x424d);

      // Namespace
      expect(TransactionType.NAMESPACE_REGISTRATION.value, 0x414e);
      expect(TransactionType.NAMESPACE_ATTACH_TO_ACCOUNT.value, 0x424e);
      expect(TransactionType.NAMESPACE_ATTACH_TO_MOSAIC.value, 0x434e);

      // Transfer
      expect(TransactionType.TRANSFER.value, 0x4154);

      // Multi-signature
      expect(TransactionType.MULTISIG_MODIFY.value, 0x4155);

      // Aggregate
      expect(TransactionType.AGGREGATE_COMPLETE.value, 0x4141);
      expect(TransactionType.AGGREGATE_BONDED.value, 0x4241);

      // Hash lock / Lock funds
      expect(TransactionType.HASH_LOCK.value, 0x4148);

      // Cross-chain swaps
      expect(TransactionType.SECRET_LOCK.value, 0x4152);
      expect(TransactionType.SECRET_PROOF.value, 0x4252);

      // Account link / remote harvesting
      expect(TransactionType.ACCOUNT_LINK.value, 0x414C);
    });

    test('Can retrieve a valid transaction types', () {
      // Account filters
      expect(TransactionType.getType(0x4150), TransactionType.ACCOUNT_FILTER_ADDRESS);
      expect(TransactionType.getType(0x4250), TransactionType.ACCOUNT_FILTER_MOSAIC);
      expect(TransactionType.getType(0x4350), TransactionType.ACCOUNT_FILTER_ENTITY_TYPE);

      // Mosaic
      expect(TransactionType.getType(0x414d), TransactionType.MOSAIC_DEFINITION);
      expect(TransactionType.getType(0x424d), TransactionType.MOSAIC_SUPPLY_CHANGE);

      // Namespace
      expect(TransactionType.getType(0x414e), TransactionType.NAMESPACE_REGISTRATION);
      expect(TransactionType.getType(0x424e), TransactionType.NAMESPACE_ATTACH_TO_ACCOUNT);
      expect(TransactionType.getType(0x434e), TransactionType.NAMESPACE_ATTACH_TO_MOSAIC);

      // Transfer
      expect(TransactionType.getType(0x4154), TransactionType.TRANSFER);

      // Multi-signature
      expect(TransactionType.getType(0x4155), TransactionType.MULTISIG_MODIFY);

      // Aggregate
      expect(TransactionType.getType(0x4141), TransactionType.AGGREGATE_COMPLETE);
      expect(TransactionType.getType(0x4241), TransactionType.AGGREGATE_BONDED);

      // Hash lock / Lock funds
      expect(TransactionType.getType(0x4148), TransactionType.HASH_LOCK);

      // Cross-chain swaps
      expect(TransactionType.getType(0x4152), TransactionType.SECRET_LOCK);
      expect(TransactionType.getType(0x4252), TransactionType.SECRET_PROOF);

      // Account link / remote harvesting
      expect(TransactionType.getType(0x414C), TransactionType.ACCOUNT_LINK);
    });

    test('Can determine aggregate transaction types', () {
      expect(TransactionType.isAggregateType(TransactionType.AGGREGATE_COMPLETE), isTrue);
      expect(TransactionType.isAggregateType(TransactionType.AGGREGATE_BONDED), isTrue);

      expect(TransactionType.isAggregateType(TransactionType.TRANSFER), isFalse);
    });

    test('Trying to retrieve an invalid transaction type will throw an error', () {
      String errorMessage = TransactionType.UNKNOWN_TRANSACTION_TYPE;
      expect(() => TransactionType.getType(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => TransactionType.getType(0x0000),
                 throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });
  });
}
