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

import 'package:nem2_sdk_dart/sdk.dart' show AccountRestrictionFlags, AccountRestrictionType;
import 'package:test/test.dart';

void main() {
  group('AccountRestrictionFlags', () {
    test('valid flags', () {
      // allow
      expect(AccountRestrictionFlags.ALLOW_INCOMING_ADDRESS.value,
          AccountRestrictionType.ADDRESS.value);
      expect(AccountRestrictionFlags.ALLOW_MOSAIC.value, AccountRestrictionType.MOSAIC.value);
      expect(AccountRestrictionFlags.ALLOW_INCOMING_TRANSACTION_TYPE.value,
          AccountRestrictionType.TRANSACTION_TYPE.value);
      expect(AccountRestrictionFlags.ALLOW_OUTGOING_ADDRESS.value,
          (AccountRestrictionType.ADDRESS.value + AccountRestrictionType.OUTGOING.value));
      expect(AccountRestrictionFlags.ALLOW_OUTGOING_TRANSACTION_TYPE.value,
          (AccountRestrictionType.TRANSACTION_TYPE.value + AccountRestrictionType.OUTGOING.value));

      // block
      expect(AccountRestrictionFlags.BLOCK_INCOMING_ADDRESS.value,
          AccountRestrictionType.ADDRESS.value + AccountRestrictionType.BLOCK.value);
      expect(AccountRestrictionFlags.BLOCK_MOSAIC.value,
          AccountRestrictionType.MOSAIC.value + AccountRestrictionType.BLOCK.value);
      expect(AccountRestrictionFlags.BLOCK_INCOMING_TRANSACTION_TYPE.value,
          AccountRestrictionType.TRANSACTION_TYPE.value + AccountRestrictionType.BLOCK.value);
      expect(
          AccountRestrictionFlags.BLOCK_OUTGOING_ADDRESS.value,
          AccountRestrictionType.ADDRESS.value +
              AccountRestrictionType.BLOCK.value +
              AccountRestrictionType.OUTGOING.value);
      expect(
          AccountRestrictionFlags.BLOCK_OUTGOING_TRANSACTION_TYPE.value,
          AccountRestrictionType.TRANSACTION_TYPE.value +
              AccountRestrictionType.BLOCK.value +
              AccountRestrictionType.OUTGOING.value);
    });

    test('Can retrieve a valid restriction flag', () {
      // Account filters
      expect(AccountRestrictionFlags.fromInt(AccountRestrictionType.ADDRESS.value),
          AccountRestrictionFlags.ALLOW_INCOMING_ADDRESS);
      expect(AccountRestrictionFlags.fromInt(AccountRestrictionType.MOSAIC.value),
          AccountRestrictionFlags.ALLOW_MOSAIC);
      expect(AccountRestrictionFlags.fromInt(AccountRestrictionType.TRANSACTION_TYPE.value),
          AccountRestrictionFlags.ALLOW_INCOMING_TRANSACTION_TYPE);

      expect(
          AccountRestrictionFlags.fromInt(
              AccountRestrictionType.ADDRESS.value + AccountRestrictionType.OUTGOING.value),
          AccountRestrictionFlags.ALLOW_OUTGOING_ADDRESS);
      expect(
          AccountRestrictionFlags.fromInt(AccountRestrictionType.TRANSACTION_TYPE.value +
              AccountRestrictionType.OUTGOING.value),
          AccountRestrictionFlags.ALLOW_OUTGOING_TRANSACTION_TYPE);

      expect(
          AccountRestrictionFlags.fromInt(
              AccountRestrictionType.ADDRESS.value + AccountRestrictionType.BLOCK.value),
          AccountRestrictionFlags.BLOCK_INCOMING_ADDRESS);
      expect(
          AccountRestrictionFlags.fromInt(
              AccountRestrictionType.MOSAIC.value + AccountRestrictionType.BLOCK.value),
          AccountRestrictionFlags.BLOCK_MOSAIC);
      expect(
          AccountRestrictionFlags.fromInt(
              AccountRestrictionType.TRANSACTION_TYPE.value + AccountRestrictionType.BLOCK.value),
          AccountRestrictionFlags.BLOCK_INCOMING_TRANSACTION_TYPE);

      expect(
          AccountRestrictionFlags.fromInt(AccountRestrictionType.ADDRESS.value +
              AccountRestrictionType.BLOCK.value +
              AccountRestrictionType.OUTGOING.value),
          AccountRestrictionFlags.BLOCK_OUTGOING_ADDRESS);
      expect(
          AccountRestrictionFlags.fromInt(AccountRestrictionType.TRANSACTION_TYPE.value +
              AccountRestrictionType.BLOCK.value +
              AccountRestrictionType.OUTGOING.value),
          AccountRestrictionFlags.BLOCK_OUTGOING_TRANSACTION_TYPE);
    });

    test('Trying to retrieve an unknown restriction flag will throw an error', () {
      String errorMessage = AccountRestrictionFlags.UNKNOWN_ACCOUNT_RESTRICTION_FLAG;
      expect(errorMessage, equals('unknown account restriction flag'));

      expect(() => AccountRestrictionFlags.fromInt(null),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains(errorMessage))));
      expect(() => AccountRestrictionFlags.fromInt(0x0000),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains(errorMessage))));
      expect(() => AccountRestrictionFlags.fromInt(0x0003),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains(errorMessage))));
    });
  });
}
