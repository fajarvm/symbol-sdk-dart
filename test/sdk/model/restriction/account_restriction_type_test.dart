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

library nem2_sdk_dart.test.sdk.model.restriction.account_restriction_type_test;

import 'package:nem2_sdk_dart/sdk.dart' show AccountRestrictionType;
import 'package:test/test.dart';

void main() {
  group('AccountRestrictionType', () {
    test('valid types', () {
      expect(AccountRestrictionType.ADDRESS.value, 0x0001);
      expect(AccountRestrictionType.MOSAIC.value, 0x0002);
      expect(AccountRestrictionType.TRANSACTION_TYPE.value, 0x0004);
      expect(AccountRestrictionType.OUTGOING.value, 0x4000);
      expect(AccountRestrictionType.BLOCK.value, 0x8000);
    });

    test('Can retrieve a valid restriction type', () {
      // Account filters
      expect(AccountRestrictionType.fromInt(0x0001), AccountRestrictionType.ADDRESS);
      expect(AccountRestrictionType.fromInt(0x0002), AccountRestrictionType.MOSAIC);
      expect(AccountRestrictionType.fromInt(0x0004), AccountRestrictionType.TRANSACTION_TYPE);
      expect(AccountRestrictionType.fromInt(0x4000), AccountRestrictionType.OUTGOING);
      expect(AccountRestrictionType.fromInt(0x8000), AccountRestrictionType.BLOCK);
    });

    test('Trying to retrieve an unknown restriction type will throw an error', () {
      String errorMessage = AccountRestrictionType.UNKNOWN_ACCOUNT_RESTRICTION_TYPE;
      expect(errorMessage, equals('unknown account restriction type'));

      expect(() => AccountRestrictionType.fromInt(null),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains(errorMessage))));
      expect(() => AccountRestrictionType.fromInt(0x0000),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains(errorMessage))));
      expect(() => AccountRestrictionType.fromInt(0x0003),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains(errorMessage))));
    });
  });
}
