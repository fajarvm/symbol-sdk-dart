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

library nem2_sdk_dart.test.sdk.model.account.account_type_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show AccountType;

void main() {
  group('AccountType', () {
    test('valid types', () {
      expect(AccountType.UNLINKED.value, 0);
      expect(AccountType.MAIN.value, 1);
      expect(AccountType.REMOTE.value, 2);
      expect(AccountType.REMOTE_UNLINKED.value, 3);
    });

    test('Can retrieve a valid account type', () {
      expect(AccountType.fromInt(0), AccountType.UNLINKED);
      expect(AccountType.fromInt(1), AccountType.MAIN);
      expect(AccountType.fromInt(2), AccountType.REMOTE);
      expect(AccountType.fromInt(3), AccountType.REMOTE_UNLINKED);
    });

    test('Trying to retrieve an unknown account type will throw an error', () {
      String errorMessage = AccountType.UNKNOWN_ACCOUNT_TYPE;
      expect(errorMessage, equals('unknown account type'));

      expect(() => AccountType.fromInt(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => AccountType.fromInt(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => AccountType.fromInt(4),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });
  });
}
