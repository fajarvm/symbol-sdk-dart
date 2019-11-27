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

library nem2_sdk_dart.test.sdk.model.restriction.account_restriction_modification_type_test;

import 'package:nem2_sdk_dart/sdk.dart' show AccountRestrictionModificationAction;
import 'package:test/test.dart';

void main() {
  group('AccountRestrictionModificationType', () {
    test('valid types', () {
      expect(AccountRestrictionModificationAction.ADD.value, 0x00);
      expect(AccountRestrictionModificationAction.REMOVE.value, 0x01);
    });

    test('Can retrieve a valid restriction modification type', () {
      // Account filters
      expect(AccountRestrictionModificationAction.fromInt(0x00), AccountRestrictionModificationAction.ADD);
      expect(AccountRestrictionModificationAction.fromInt(0x01), AccountRestrictionModificationAction.REMOVE);
    });

    test('Trying to retrieve an invalid restriction type will throw an error', () {
      String errorMessage = AccountRestrictionModificationAction.UNKNOWN_RESTRICTION_MODIFICATION_TYPE;
      expect(errorMessage, equals('unknown restriction modification type'));

      expect(() => AccountRestrictionModificationAction.fromInt(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => AccountRestrictionModificationAction.fromInt(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => AccountRestrictionModificationAction.fromInt(2),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });
  });
}
