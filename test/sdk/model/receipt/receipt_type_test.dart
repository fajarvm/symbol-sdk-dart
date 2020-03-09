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

library symbol_sdk_dart.test.sdk.model.receipt.receipt_type_test;

import 'package:symbol_sdk_dart/sdk.dart' show ReceiptType;
import 'package:test/test.dart';

void main() {
  group('ReceiptType', () {
    group('All types', () {
      test('Check all types', () {
        // check collection size
        expect(ReceiptType.values.length, 16);
        // check values
        expect(ReceiptType.HARVEST_FEE.value, 0x2143);
        expect(ReceiptType.ADDRESS_ALIAS_RESOLUTION.value, 0xF143);
        expect(ReceiptType.MOSAIC_ALIAS_RESOLUTION.value, 0xF243);
        expect(ReceiptType.TRANSACTION_GROUP.value, 0xE143);
        expect(ReceiptType.MOSAIC_EXPIRED.value, 0x414D);
        expect(ReceiptType.MOSAIC_RENTAL_FEE.value, 0x124D);
        expect(ReceiptType.NAMESPACE_EXPIRED.value, 0x414E);
        expect(ReceiptType.NAMESPACE_RENTAL_FEE.value, 0x124E);
        expect(ReceiptType.NAMESPACE_DELETED.value, 0x424E);
        expect(ReceiptType.LOCKHASH_CREATED.value, 0x3148);
        expect(ReceiptType.LOCKHASH_COMPLETED.value, 0x2248);
        expect(ReceiptType.LOCKHASH_EXPIRED.value, 0x2348);
        expect(ReceiptType.LOCKSECRET_CREATED.value, 0x3152);
        expect(ReceiptType.LOCKSECRET_COMPLETED.value, 0x2252);
        expect(ReceiptType.LOCKSECRET_EXPIRED.value, 0x2352);
        expect(ReceiptType.INFLATION.value, 0x5143);
        // check names
        expect(ReceiptType.HARVEST_FEE.name, 'HARVEST_FEE');
        expect(ReceiptType.ADDRESS_ALIAS_RESOLUTION.name, 'ADDRESS_ALIAS_RESOLUTION');
        expect(ReceiptType.MOSAIC_ALIAS_RESOLUTION.name, 'MOSAIC_ALIAS_RESOLUTION');
        expect(ReceiptType.TRANSACTION_GROUP.name, 'TRANSACTION_GROUP');
        expect(ReceiptType.MOSAIC_EXPIRED.name, 'MOSAIC_EXPIRED');
        expect(ReceiptType.MOSAIC_RENTAL_FEE.name, 'MOSAIC_RENTAL_FEE');
        expect(ReceiptType.NAMESPACE_EXPIRED.name, 'NAMESPACE_EXPIRED');
        expect(ReceiptType.NAMESPACE_RENTAL_FEE.name, 'NAMESPACE_RENTAL_FEE');
        expect(ReceiptType.NAMESPACE_DELETED.name, 'NAMESPACE_DELETED');
        expect(ReceiptType.LOCKHASH_CREATED.name, 'LOCKHASH_CREATED');
        expect(ReceiptType.LOCKHASH_COMPLETED.name, 'LOCKHASH_COMPLETED');
        expect(ReceiptType.LOCKHASH_EXPIRED.name, 'LOCKHASH_EXPIRED');
        expect(ReceiptType.LOCKSECRET_CREATED.name, 'LOCKSECRET_CREATED');
        expect(ReceiptType.LOCKSECRET_COMPLETED.name, 'LOCKSECRET_COMPLETED');
        expect(ReceiptType.LOCKSECRET_EXPIRED.name, 'LOCKSECRET_EXPIRED');
        expect(ReceiptType.INFLATION.name, 'INFLATION');

        // check toString()
        final expected =
            'ReceiptType{value: ${ReceiptType.HARVEST_FEE.value}, name: ${ReceiptType.HARVEST_FEE.name}}';
        expect(ReceiptType.HARVEST_FEE.toString(), equals(expected));
      });

      test('Can retrieve a valid type from an int value', () {
        expect(ReceiptType.fromInt(0x2143), ReceiptType.HARVEST_FEE);
        expect(ReceiptType.fromInt(0xF143), ReceiptType.ADDRESS_ALIAS_RESOLUTION);
        expect(ReceiptType.fromInt(0xF243), ReceiptType.MOSAIC_ALIAS_RESOLUTION);
        expect(ReceiptType.fromInt(0xE143), ReceiptType.TRANSACTION_GROUP);
        expect(ReceiptType.fromInt(0x414D), ReceiptType.MOSAIC_EXPIRED);
        expect(ReceiptType.fromInt(0x124D), ReceiptType.MOSAIC_RENTAL_FEE);
        expect(ReceiptType.fromInt(0x414E), ReceiptType.NAMESPACE_EXPIRED);
        expect(ReceiptType.fromInt(0x124E), ReceiptType.NAMESPACE_RENTAL_FEE);
        expect(ReceiptType.fromInt(0x424E), ReceiptType.NAMESPACE_DELETED);
        expect(ReceiptType.fromInt(0x3148), ReceiptType.LOCKHASH_CREATED);
        expect(ReceiptType.fromInt(0x2248), ReceiptType.LOCKHASH_COMPLETED);
        expect(ReceiptType.fromInt(0x2348), ReceiptType.LOCKHASH_EXPIRED);
        expect(ReceiptType.fromInt(0x3152), ReceiptType.LOCKSECRET_CREATED);
        expect(ReceiptType.fromInt(0x2252), ReceiptType.LOCKSECRET_COMPLETED);
        expect(ReceiptType.fromInt(0x2352), ReceiptType.LOCKSECRET_EXPIRED);
        expect(ReceiptType.fromInt(0x5143), ReceiptType.INFLATION);
      });

      test('invalid or unknown type should throw an error', () {
        String errorMessage = ReceiptType.UNKNOWN_RECEIPT_TYPE;
        expect(() => ReceiptType.fromInt(null),
            throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
        expect(() => ReceiptType.fromInt(-1),
            throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
        expect(() => ReceiptType.fromInt(0),
            throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      });
    });

    group('Categorized types', () {
      test('ArtifactExpiry collection', () {
        // check collection size
        expect(ReceiptType.ArtifactExpiry.length, 3);

        // check collection values
        expect(ReceiptType.ArtifactExpiry.contains(ReceiptType.MOSAIC_EXPIRED), isTrue);
        expect(ReceiptType.ArtifactExpiry.contains(ReceiptType.NAMESPACE_EXPIRED), isTrue);
        expect(ReceiptType.ArtifactExpiry.contains(ReceiptType.NAMESPACE_DELETED), isTrue);

        expect(ReceiptType.ArtifactExpiry.contains(ReceiptType.HARVEST_FEE), isFalse);
      });

      test('BalanceChange collection', () {
        // check collection size
        expect(ReceiptType.BalanceChange.length, 7);

        // check collection values
        expect(ReceiptType.BalanceChange.contains(ReceiptType.HARVEST_FEE), isTrue);
        expect(ReceiptType.BalanceChange.contains(ReceiptType.LOCKHASH_COMPLETED), isTrue);
        expect(ReceiptType.BalanceChange.contains(ReceiptType.LOCKHASH_CREATED), isTrue);
        expect(ReceiptType.BalanceChange.contains(ReceiptType.LOCKHASH_EXPIRED), isTrue);
        expect(ReceiptType.BalanceChange.contains(ReceiptType.LOCKSECRET_COMPLETED), isTrue);
        expect(ReceiptType.BalanceChange.contains(ReceiptType.LOCKSECRET_CREATED), isTrue);
        expect(ReceiptType.BalanceChange.contains(ReceiptType.LOCKSECRET_EXPIRED), isTrue);

        expect(ReceiptType.BalanceChange.contains(ReceiptType.MOSAIC_RENTAL_FEE), isFalse);
      });

      test('BalanceChange collection', () {
        // check collection size
        expect(ReceiptType.BalanceTransfer.length, 2);

        // check collection values
        expect(ReceiptType.BalanceTransfer.contains(ReceiptType.MOSAIC_RENTAL_FEE), isTrue);
        expect(ReceiptType.BalanceTransfer.contains(ReceiptType.NAMESPACE_RENTAL_FEE), isTrue);

        expect(ReceiptType.BalanceTransfer.contains(ReceiptType.ADDRESS_ALIAS_RESOLUTION), isFalse);
      });

      test('ResolutionStatement collection', () {
        // check collection size
        expect(ReceiptType.ResolutionStatement.length, 2);

        // check collection values
        expect(
            ReceiptType.ResolutionStatement.contains(ReceiptType.ADDRESS_ALIAS_RESOLUTION), isTrue);
        expect(
            ReceiptType.ResolutionStatement.contains(ReceiptType.MOSAIC_ALIAS_RESOLUTION), isTrue);

        expect(ReceiptType.ResolutionStatement.contains(ReceiptType.HARVEST_FEE), isFalse);
      });
    });
  });
}
