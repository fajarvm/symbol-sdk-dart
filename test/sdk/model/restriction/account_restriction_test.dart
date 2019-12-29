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

library nem2_sdk_dart.test.sdk.model.restriction.account_restriction_test;

import 'package:nem2_sdk_dart/sdk.dart' show Address, AccountRestriction, AccountRestrictionFlags;
import 'package:test/test.dart';

void main() {
  group('AccountRestriction', () {
    test('Can create an AccountRestriction object', () {
      const String encodedAddress = '906415867F121D037AF447E711B0F5E4D52EBBF066D96860EB';
      const values = [encodedAddress];

      final accountRestriction = new AccountRestriction(
          AccountRestrictionFlags.ALLOW_INCOMING_ADDRESS,
          List<Address>.generate(values.length, (i) => Address.fromEncoded(values[i])));

      // Assert
      expect(accountRestriction.restrictionFlags,
          equals(AccountRestrictionFlags.ALLOW_INCOMING_ADDRESS));
      expect(accountRestriction.values.length, equals(values.length));
      expect(accountRestriction.values[0], equals(Address.fromEncoded(encodedAddress)));
    });
  });
}
