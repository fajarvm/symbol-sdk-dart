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

library nem2_sdk_dart.test.sdk.model.account.account_test;

import 'package:nem2_sdk_dart/core.dart';
import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show CryptoException, Ed25519;
import 'package:nem2_sdk_dart/sdk.dart' show Account, NetworkType;

void main() {
  const testAccount = {
    'address': 'SCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPRLIKCF2',
    'privateKey': '26b64cb10f005e5988a36744ca19e20d835ccc7c105aaa5f3b212da593180930',
    'publicKey': 'c2f93346e27ce6ad1a9f8f5e3066f8326593a406bdf357acb041e2f9ab402efe'
  };

  group('Account creation', () {
    test('can generate a new account for the given network type', () {
      final account = Account.generate(NetworkType.MIJIN_TEST);

      expect(account.publicKey, isNotNull);
      expect(account.privateKey, isNotNull);
      expect(account.plainAddress, isNotNull);
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
      expect(account.publicKey, equals(HexUtils.getString(keyPair.publicKey)));
      expect(account.privateKey, equals(HexUtils.getString(keyPair.privateKey)));
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
                      'Expected: ${Ed25519.KEY_SIZE}, Got: 0')));
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

    test('Hexadecimal', () {
      final account = Account.fromPrivateKey(
          'AB860ED1FE7C91C02F79C02225DAC708D7BD13369877C1F59E678CC587658C47',
          NetworkType.MIJIN_TEST);

      final publicAccount = account.publicAccount;
      final signedData = account.signData('0xAA');

      expect(publicAccount.verifySignature('0xAA', signedData), isTrue);
    });
  });
}
