library nem2_sdk_dart.test.sdk.model.account.account_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/src/core/crypto.dart' show CryptoException, Ed25519;
import 'package:nem2_sdk_dart/src/sdk/model.dart' show Account, NetworkType;

main() {
  const testAccount = {
    'address': 'SCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPRLIKCF2',
    'privateKey': '26b64cb10f005e5988a36744ca19e20d835ccc7c105aaa5f3b212da593180930',
    'publicKey': 'c2f93346e27ce6ad1a9f8f5e3066f8326593a406bdf357acb041e2f9ab402efe'
  };

  group('Account', () {
    test('should be created from a private key', () {
      final Account account =
          Account.createFromPrivateKey(testAccount['privateKey'], NetworkType.MIJIN_TEST);

      expect(account.publicKey, equals(testAccount['publicKey']));
      expect(account.privateKey, equals(testAccount['privateKey']));
      expect(account.address.plain(), equals(testAccount['address']));
    });

    test('should throw an exception when the private key is invalid', () {
      expect(
          () => Account.createFromPrivateKey('', NetworkType.MIJIN_TEST),
          throwsA(predicate((e) =>
              e is CryptoException &&
              e.message ==
                  'Private key has an unexpected size. '
                  'Expected: ${Ed25519.KEY_SIZE}, Got: 0')));
    });

    test('should generate a new account', () {
      final Account account = Account.generateNewAccount(NetworkType.MIJIN_TEST);

      expect(account.publicKey, isNotNull);
      expect(account.privateKey, isNotNull);
      expect(account.address.plain(), isNotNull);
    });
  });

//  group('signData', () {
//    test('UTF-8', () {
//      final Account account = Account.createFromPrivateKey(
//          'AB860ED1FE7C91C02F79C02225DAC708D7BD13369877C1F59E678CC587658C47',
//          NetworkType.MIJIN_TEST);
//
//      // TODO: complete
//    });
//  });
}
