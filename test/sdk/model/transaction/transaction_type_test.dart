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

import 'package:nem2_sdk_dart/sdk.dart' show TransactionType;
import 'package:test/test.dart';

void main() {
  group('TransactionType', () {
    test('valid transaction types', () {
      // Mosaic
      expect(TransactionType.MOSAIC_DEFINITION.value, 0x414d);
      expect(TransactionType.MOSAIC_SUPPLY_CHANGE.value, 0x424d);

      // Namespace
      expect(TransactionType.NAMESPACE_REGISTRATION.value, 0x414e);
      expect(TransactionType.ADDRESS_ALIAS.value, 0x424e);
      expect(TransactionType.MOSAIC_ALIAS.value, 0x434e);

      // Transfer
      expect(TransactionType.TRANSFER.value, 0x4154);

      // Multi-signature
      expect(TransactionType.MODIFY_MULTISIG_ACCOUNT.value, 0x4155);

      // Aggregate
      expect(TransactionType.AGGREGATE_COMPLETE.value, 0x4141);
      expect(TransactionType.AGGREGATE_BONDED.value, 0x4241);

      // Hash lock / Lock funds
      expect(TransactionType.LOCK.value, 0x4148);

      // Cross-chain swaps
      expect(TransactionType.SECRET_LOCK.value, 0x4152);
      expect(TransactionType.SECRET_PROOF.value, 0x4252);

      // Account restriction
      expect(TransactionType.ACCOUNT_RESTRICTION_ADDRESS.value, 0x4150);
      expect(TransactionType.ACCOUNT_RESTRICTION_MOSAIC.value, 0x4250);
      expect(TransactionType.ACCOUNT_RESTRICTION_OPERATION.value, 0x4350);

      // Account link / remote harvesting
      expect(TransactionType.ACCOUNT_LINK.value, 0x414C);

      // Mosaic restriction
      expect(TransactionType.MOSAIC_RESTRICTION_ADDRESS.value, 0x4251);
      expect(TransactionType.MOSAIC_RESTRICTION_GLOBAL.value, 0x4151);

      // Metadata
      expect(TransactionType.METADATA_ACCOUNT.value, 0x4144);
      expect(TransactionType.METADATA_MOSAIC.value, 0x4244);
      expect(TransactionType.METADATA_NAMESPACE.value, 0x4344);

      expect(TransactionType.TRANSFER.toString(),
          equals('TransactionType{value: ${TransactionType.TRANSFER.value}}'));
    });

    test('Can retrieve a valid transaction types', () {
      // Mosaic
      expect(TransactionType.fromInt(0x414d), TransactionType.MOSAIC_DEFINITION);
      expect(TransactionType.fromInt(0x424d), TransactionType.MOSAIC_SUPPLY_CHANGE);

      // Namespace
      expect(TransactionType.fromInt(0x414e), TransactionType.NAMESPACE_REGISTRATION);
      expect(TransactionType.fromInt(0x424e), TransactionType.ADDRESS_ALIAS);
      expect(TransactionType.fromInt(0x434e), TransactionType.MOSAIC_ALIAS);

      // Transfer
      expect(TransactionType.fromInt(0x4154), TransactionType.TRANSFER);

      // Multi-signature
      expect(TransactionType.fromInt(0x4155), TransactionType.MODIFY_MULTISIG_ACCOUNT);

      // Aggregate
      expect(TransactionType.fromInt(0x4141), TransactionType.AGGREGATE_COMPLETE);
      expect(TransactionType.fromInt(0x4241), TransactionType.AGGREGATE_BONDED);

      // Hash lock / Lock funds
      expect(TransactionType.fromInt(0x4148), TransactionType.LOCK);

      // Cross-chain swaps
      expect(TransactionType.fromInt(0x4152), TransactionType.SECRET_LOCK);
      expect(TransactionType.fromInt(0x4252), TransactionType.SECRET_PROOF);

      // Account restriction
      expect(TransactionType.fromInt(0x4150), TransactionType.ACCOUNT_RESTRICTION_ADDRESS);
      expect(TransactionType.fromInt(0x4250), TransactionType.ACCOUNT_RESTRICTION_MOSAIC);
      expect(TransactionType.fromInt(0x4350), TransactionType.ACCOUNT_RESTRICTION_OPERATION);

      // Account link / remote harvesting
      expect(TransactionType.fromInt(0x414C), TransactionType.ACCOUNT_LINK);

      // Mosaic restriction
      expect(TransactionType.fromInt(0x4251), TransactionType.MOSAIC_RESTRICTION_ADDRESS);
      expect(TransactionType.fromInt(0x4151), TransactionType.MOSAIC_RESTRICTION_GLOBAL);

      // Metadata
      expect(TransactionType.fromInt(0x4144), TransactionType.METADATA_ACCOUNT);
      expect(TransactionType.fromInt(0x4244), TransactionType.METADATA_MOSAIC);
      expect(TransactionType.fromInt(0x4344), TransactionType.METADATA_NAMESPACE);
    });

    test('Valid aggregate transaction types', () {
      expect(TransactionType.aggregate.length, 2);
      expect(TransactionType.aggregate[0], equals(TransactionType.AGGREGATE_COMPLETE));
      expect(TransactionType.aggregate[1], equals(TransactionType.AGGREGATE_BONDED));
    });

    test('Can determine aggregate transaction types', () {
      expect(TransactionType.isAggregate(TransactionType.AGGREGATE_COMPLETE), isTrue);
      expect(TransactionType.isAggregate(TransactionType.AGGREGATE_BONDED), isTrue);

      expect(TransactionType.isAggregate(TransactionType.TRANSFER), isFalse);
    });

    test('Trying to retrieve an invalid transaction type will throw an error', () {
      String errorMessage = TransactionType.UNKNOWN_TRANSACTION_TYPE;
      expect(() => TransactionType.fromInt(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => TransactionType.fromInt(0x0000),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });
  });
}
