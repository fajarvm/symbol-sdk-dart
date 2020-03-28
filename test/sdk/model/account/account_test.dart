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

library symbol_sdk_dart.test.sdk.model.account.account_test;

import 'package:symbol_sdk_dart/core.dart';
import 'package:symbol_sdk_dart/core.dart' show CryptoException, CryptoUtils;
import 'package:symbol_sdk_dart/sdk.dart' show Account, NetworkType;
import 'package:test/test.dart';

void main() {
  const testAccount = {
    'address': 'SDLGYM2CBZKBDGK3VT6KFMUM6HE7LXL2WEQE5JCR',
    'privateKey': '26B64CB10F005E5988A36744CA19E20D835CCC7C105AAA5F3B212DA593180930',
    'publicKey': '9801508C58666C746F471538E43002B85B1CD542F9874B2861183919BA8787B6'
  };

  group('Account creation', () {
    test('can generate a new account for the given network type', () {
      for (var type in NetworkType.values) {
        final account = Account.generate(type);

        expect(account.publicKey, isNotNull);
        expect(account.privateKey, isNotNull);
        expect(account.plainAddress, isNotNull);
      }
    });

    test('can create an account from a private key', () {
      final account = Account.fromPrivateKey(testAccount['privateKey'], NetworkType.MIJIN_TEST);

      expect(account.publicKey, equals(testAccount['publicKey']));
      expect(account.privateKey, equals(testAccount['privateKey']));
      expect(account.plainAddress, equals(testAccount['address']));
    });

    test('can create an account from a keypair', () {
      final keyPair = KeyPair.random();
      final account = Account.fromKeyPair(keyPair, NetworkType.MIJIN_TEST);

      expect(account.keyPair.publicKey, equals(keyPair.publicKey));
      expect(account.keyPair.privateKey, equals(keyPair.privateKey));
      expect(account.publicKey, equals(ByteUtils.bytesToHex(keyPair.publicKey)));
      expect(account.privateKey, equals(ByteUtils.bytesToHex(keyPair.privateKey)));
      expect(account.publicAccount.address.networkType, equals(NetworkType.MIJIN_TEST));
    });

    test('can compare two acconts', () {
      final account1 = Account.fromPrivateKey(testAccount['privateKey'], NetworkType.MIJIN_TEST);
      final account2 = Account.fromPrivateKey(testAccount['privateKey'], NetworkType.MIJIN_TEST);

      expect(account1.hashCode, isNotNull);
      expect(account2.hashCode, isNotNull);
      expect(account1 == account2, isTrue);
      expect(account1.toString(),
          equals('Account{address= ${account1.plainAddress}, publicKey= ${account1.publicKey}}'));
    });

    test('should throw an exception when the private key is invalid', () {
      expect(
          () => Account.fromPrivateKey('', NetworkType.MIJIN_TEST),
          throwsA(predicate((e) =>
              e is CryptoException &&
              e.message ==
                  'Private key has an unexpected size. '
                      'Expected: ${CryptoUtils.KEY_SIZE}, Got: 0')));
    });
  });

  group('Account signing', () {
    test('UTF-8', () {
      final account = Account.fromPrivateKey(
          'AB860ED1FE7C91C02F79C02225DAC708D7BD13369877C1F59E678CC587658C47',
          NetworkType.MIJIN_TEST);

      final publicAccount = account.publicAccount;
      final signedData = account.signData('catapult rocks!');

      expect(publicAccount.verifySignature('catapult rocks!', signedData), isTrue);
    });

    test('UTF-8 - NIS1', () {
      final account = Account.fromPrivateKey(
          'AB860ED1FE7C91C02F79C02225DAC708D7BD13369877C1F59E678CC587658C47', NetworkType.TEST_NET);

      final publicAccount = account.publicAccount;
      final signedData = account.signData('catapult rocks!');

      expect(publicAccount.verifySignature('catapult rocks!', signedData), isTrue);
    });

    test('Hexadecimal', () {
      final account = Account.fromPrivateKey(
          'AB860ED1FE7C91C02F79C02225DAC708D7BD13369877C1F59E678CC587658C47',
          NetworkType.MIJIN_TEST);

      final publicAccount = account.publicAccount;
      final signedData = account.signData('0xAA');

      expect(publicAccount.verifySignature('0xAA', signedData), isTrue);
    });

    test('Hexadecimal - NIS1', () {
      final account = Account.fromPrivateKey(
          'AB860ED1FE7C91C02F79C02225DAC708D7BD13369877C1F59E678CC587658C47',
          NetworkType.MIJIN_TEST);

      final publicAccount = account.publicAccount;
      final signedData = account.signData('0xAA');

      expect(publicAccount.verifySignature('0xAA', signedData), isTrue);
    });
  });
}
