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

library symbol_sdk_dart.test.sdk.model.transaction.signed_transaction_test;

import 'package:test/test.dart';

import 'package:symbol_sdk_dart/sdk.dart' show NetworkType, SignedTransaction, TransactionType;

void main() {
  group('SignedTransaction', () {
    const signer = 'C2F93346E27CE6AD1A9F8F5E3066F8326593A406BDF357ACB041E2F9AB402EFE';

    test('Can create a signed transaction with a transfer transaction type', () {
      const payload = '9700000037FB5DD4291F2D1343B31E31D88A4392C8987BA76B329A273F51AE74E99554135D'
          'FE270D44EA8452E3E6075C6B898C26DD753D169452A115D96F6A4D7562C90CC2F93346E27CE6AD1A9F8F5E'
          '3066F8326593A406BDF357ACB041E2F9AB402EFE039054410000000000000000B098B7C00D000000900D8D'
          '3E65BF27ABE158BCD37C0A708BF6524A07EB09046A30030000004869';

      final signedTx = new SignedTransaction(
          payload,
          '07901DA8A8AFE1DFB76D1A079B8E785C1186BAF2C5B98227B62BDE2C77D79481',
          signer,
          TransactionType.TRANSFER,
          NetworkType.MIJIN_TEST);

      expect(signedTx.type, equals(TransactionType.TRANSFER));
    });

    test('Can create a signed transaction with an aggregate transaction type', () {
      const payload = 'C3000000E854AA7D4466D66A7045F858F6D43022B7C72524B79A6D519431EEACCD020608B4'
          '672BB9B74168DAB04B55135F528187FB93E7AE6FAFB59A01C96F2180216308C2F93346E27CE6AD1A9F8F5E'
          '3066F8326593A406BDF357ACB041E2F9AB402EFE0290414100000000000000001FBFBDC00D000000470000'
          '0047000000C2F93346E27CE6AD1A9F8F5E3066F8326593A406BDF357ACB041E2F9AB402EFE03905441900D'
          '8D3E65BF27ABE158BCD37C0A708BF6524A07EB09046A30030000004869';

      final signedTx = new SignedTransaction(
          payload,
          '231AA7700DC158CFC85606E0E2AC80F409923C6F3A845577C7D8D7A51A99E883',
          signer,
          TransactionType.AGGREGATE_COMPLETE,
          NetworkType.MIJIN_TEST);

      expect(signedTx.type, equals(TransactionType.AGGREGATE_COMPLETE));
    });

    test('Cannot create a signed transaction with an invalid hash', () {
      expect(
          () => new SignedTransaction(
              '', null, signer, TransactionType.AGGREGATE_BONDED, NetworkType.MIJIN_TEST),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'Invalid hash size. The hash must be 64 characters long.')));

      const hash = '8498B38D89C1DC8A448EA5824938FF828926CD9F7747B1844B59B4B6807E878';
      expect(
          () => new SignedTransaction(
              '', hash, signer, TransactionType.AGGREGATE_BONDED, NetworkType.MIJIN_TEST),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'Invalid hash size. The hash must be 64 characters long.')));
    });
  });
}
