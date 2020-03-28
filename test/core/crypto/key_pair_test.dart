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

library symbol_sdk_dart.test.core.crypto.key_pair_test;

import 'dart:typed_data' show Uint8List;

import 'package:symbol_sdk_dart/core.dart'
    show ArrayUtils, CryptoException, CryptoUtils, HexUtils, KeyPair;
import 'package:test/test.dart';

void main() {
  const TEST_PRIVATE_KEYS = <String>[
    '575DBB3062267EFF57C970A336EBBC8FBCFE12C5BD3ED7BC11EB0481D7704CED',
    '5B0E3FA5D3B49A79022D7C1E121BA1CBBF4DB5821F47AB8C708EF88DEFC29BFE',
    '738BA9BB9110AEA8F15CAA353ACA5653B4BDFCA1DB9F34D0EFED2CE1325AEEDA',
    'E8BF9BC0F35C12D8C8BF94DD3A8B5B4034F1063948E3CC5304E55E31AA4B95A6',
    'C325EA529674396DB5675939E7988883D59A5FC17A28CA977E3BA85370232A83'
  ];

  const CATAPULT_PRIVATE_KEY = <String>[
    'abf4cf55a2b3f742d7543d9cc17f50447b969e6e06f5ea9195d428ab12b7318d',
    '6aa6dad25d3acb3385d5643293133936cdddd7f7e11818771db1ff2f9d3f9215',
    '8e32bc030a4c53de782ec75ba7d5e25e64a2a072a56e5170b77a4924ef3c32a9',
    'c83ce30fcb5b81a51ba58ff827ccbc0142d61c13e2ed39e78e876605da16d8d7',
    '2da2a0aae0f37235957b51d15843edde348a559692d8fa87b94848459899fc27',
  ];

  const INPUT_DATA = <String>[
    '8ce03cd60514233b86789729102ea09e867fc6d964dea8c2018ef7d0a2e0e24bf7e348e917116690b9',
    'e4a92208a6fc52282b620699191ee6fb9cf04daf48b48fd542c5e43daa9897763a199aaa4b6f10546109f47ac3564fade0',
    '13ed795344c4448a3b256f23665336645a853c5c44dbff6db1b9224b5303b6447fbf8240a2249c55',
    'a2704638434e9f7340f22d08019c4c8e3dbee0df8dd4454a1d70844de11694f4c8ca67fdcb08fed0cec9abb2112b5e5f89',
    'd2488e854dbcdfdb2c9d16c8c0b2fdbc0abb6bac991bfe2b14d359a6bc99d66c00fd60d731ae06d0'
  ];

  const EXPECTED_SIGNATURES = <String>[
    '31D272F0662915CAC43AB7D721CAF65D8601F52B2E793EA1533E7BC20E04EA97B74859D9209A7B18DFECFD2C4A42D6957628F5357E3FB8B87CF6A888BAB4280E',
    'F21E4BE0A914C0C023F724E1EAB9071A3743887BB8824CB170404475873A827B301464261E93700725E8D4427A3E39D365AFB2C9191F75D33C6BE55896E0CC00',
    '939CD8932093571E24B21EA53F1359279BA5CFC32CE99BB020E676CF82B0AA1DD4BC76FCDE41EF784C06D122B3D018135352C057F079C926B3EFFA7E73CF1D06',
    '9B4AFBB7B96CAD7726389C2A4F31115940E6EEE3EA29B3293C82EC8C03B9555C183ED1C55CA89A58C17729EFBA76A505C79AA40EC618D83124BC1134B887D305',
    '7AF2F0D9B30DE3B6C40605FDD4EBA93ECE39FA7458B300D538EC8D0ABAC1756DEFC0CA84C8A599954313E58CE36EFBA4C24A82FD6BB8127023A58EFC52A8410A'
  ];

  const EXPECTED_PUBLIC_KEYS = <String>[
    '2E834140FD66CF87B254A693A2C7862C819217B676D3943267156625E816EC6F',
    '4875FD2E32875D1BC6567745F1509F0F890A1BF8EE59FA74452FA4183A270E03',
    '9F780097FB6A1F287ED2736A597B8EA7F08D20F1ECDB9935DE6694ECF1C58900',
    '0815926E003CDD5AF0113C0E067262307A42CD1E697F53B683F7E5F9F57D72C9',
    '3683B3E45E76870CFE076E47C2B34CE8E3EAEC26C8AA7C1ED752E3E840AF8A27'
  ];

  // ---------------------------
  // ---- KeyPair creation -----
  // ---------------------------
  group('construction', () {
    test('can create a new random key pair - SHA3', () {
      final keyPair = KeyPair.random();

      expect(keyPair, isNotNull);
      expect(keyPair.privateKey, isNotNull);
      expect(keyPair.publicKey, isNotNull);
      expect(HexUtils.getString(keyPair.privateKey).length == 64, isTrue);
      expect(HexUtils.getString(keyPair.publicKey).length == 64, isTrue);
    });

    test('can extract from private key test vectors', () {
      // Sanity check
      expect(TEST_PRIVATE_KEYS.length, equals(EXPECTED_PUBLIC_KEYS.length));

      for (int i = 0; i < TEST_PRIVATE_KEYS.length; i++) {
        // Prepare
        final String privateKeyHex = TEST_PRIVATE_KEYS[i];
        final String expectedPublicKey = EXPECTED_PUBLIC_KEYS[i];
        final KeyPair keyPair = KeyPair.fromPrivateKey(privateKeyHex);

        // Assert
        final String actualPubKey = HexUtils.getString(keyPair.publicKey).toUpperCase();
        final String actualPrivateKey = HexUtils.getString(keyPair.privateKey).toUpperCase();
        expect(actualPubKey, equals(expectedPublicKey));
        expect(actualPrivateKey, equals(privateKeyHex));
      }
    });

    test('cannot extract from invalid private key', () {
      final List<String> INVALID_KEYS = [
        '', // empty
        '53C659B47C176A70EB228DE5C0A0FF391282C96640C2A42CD5BBD0982176AB', // too short
        '53C659B47C176A70EB228DE5C0A0FF391282C96640C2A42CD5BBD0982176AB1BBB' // too long
      ];

      for (var invalidPrivateKey in INVALID_KEYS) {
        final Uint8List privateKeySeed = HexUtils.getBytes(invalidPrivateKey);
        expect(
            () => KeyPair.fromPrivateKey(invalidPrivateKey),
            throwsA(predicate((e) =>
                e is CryptoException &&
                e.message ==
                    'Private key has an unexpected size. '
                        'Expected: ${CryptoUtils.KEY_SIZE}, Got: ${privateKeySeed.length}')));
      }
    });

    test('can create the same keypair from private key', () {
      final keyPair1 = KeyPair.fromPrivateKey(TEST_PRIVATE_KEYS[0]);
      final keyPair2 = KeyPair.fromPrivateKey(TEST_PRIVATE_KEYS[0]);

      expect(keyPair1.hashCode, isNotNull);
      expect(keyPair2.hashCode, isNotNull);
      expect(keyPair1.privateKey, equals(keyPair2.privateKey));
      expect(keyPair1.publicKey, equals(keyPair2.publicKey));
      expect(keyPair1 == keyPair2, isTrue);
    });

    test('can extract a public key from a private key seed', () {
      final Uint8List privateKeySeed = HexUtils.getBytes(TEST_PRIVATE_KEYS[0]);
      final Uint8List extractedPublicKey = CryptoUtils.extractPublicKey(privateKeySeed);

      final Uint8List expected = HexUtils.getBytes(EXPECTED_PUBLIC_KEYS[0]);
      expect(ArrayUtils.deepEqual(extractedPublicKey, expected), isTrue);

      final String extractedPublicKeyHex = HexUtils.getString(extractedPublicKey);
      expect(extractedPublicKeyHex.toUpperCase(), equals(EXPECTED_PUBLIC_KEYS[0]));
    });

    test('cannot extract a public key from an invalid private key seed', () {
      // null seed
      expect(
          () => KeyPair.extractPublicKey(null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));

      // incorrect length
      expect(
          () => KeyPair.extractPublicKey(Uint8List(31)),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Incorrect length'))));
      expect(
          () => KeyPair.extractPublicKey(Uint8List(34)),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Incorrect length'))));
    });

    test('can wipe a key using a util function wipe()', () {
      final KeyPair keyPair = KeyPair.random();
      expect(keyPair.privateKey, isNotNull);
      expect(keyPair.privateKey[0] != 0, isTrue);
      expect(keyPair.privateKey[keyPair.privateKey.length - 1] != 0, isTrue);

      // wipe
      CryptoUtils.wipe(keyPair.privateKey);
      expect(keyPair.privateKey, isNotNull);
      for (var byte in keyPair.privateKey) {
        expect(byte == 0, isTrue);
      }
    });

    test('can put and extract hex formatted key with leading zeros', (){
      const String hex = '00137c7c32881d1fff2e905f5b7034bcbcdb806d232f351db48a7816285c548f';
      final KeyPair keyPair = KeyPair.fromPrivateKey(hex);
      final String actual = HexUtils.getString(keyPair.privateKey);

      expect(actual, equals(hex));
    });
  });

  // ---------------------------
  // --------- Signing ---------
  // ---------------------------
  group('sign', () {
    test('fills the signature', () {
      // Prepare
      final KeyPair keyPair = KeyPair.random();
      final Uint8List payload = CryptoUtils.getRandomBytes(100);

      final Uint8List signature = KeyPair.sign(keyPair, payload);

      // Assert
      final Uint8List emptySig = new Uint8List(CryptoUtils.SIGNATURE_SIZE);
      expect(ArrayUtils.deepEqual(signature, emptySig), false);
    });

    test('returns same signature for same data signed by same key pairs', () {
      // Prepare
      final String privateKey =
          HexUtils.getString(CryptoUtils.getRandomBytes(CryptoUtils.KEY_SIZE));
      final KeyPair keyPair1 = KeyPair.fromPrivateKey(privateKey);
      final KeyPair keyPair2 = KeyPair.fromPrivateKey(privateKey);
      final Uint8List payload = CryptoUtils.getRandomBytes(100);

      final Uint8List signature1 = KeyPair.sign(keyPair1, payload);
      final Uint8List signature2 = KeyPair.sign(keyPair2, payload);

      // Assert
      expect(ArrayUtils.deepEqual(signature1, signature2), true);
    });

    test('returns different signature for data signed by different key pairs', () {
      // Prepare
      final KeyPair keyPair1 = KeyPair.random();
      final KeyPair keyPair2 = KeyPair.random();
      final Uint8List payload = CryptoUtils.getRandomBytes(100);

      final Uint8List signature1 = KeyPair.sign(keyPair1, payload);
      final Uint8List signature2 = KeyPair.sign(keyPair2, payload);

      // Assert
      expect(ArrayUtils.deepEqual(signature1, signature2), false);
    });
  });

  // ---------------------------
  // --------- Verify ----------
  // ---------------------------
  group('verify', () {
    test('returns true for data signed with same key pair', () {
      // Prepare
      final KeyPair keyPair = KeyPair.random();
      final Uint8List payload = CryptoUtils.getRandomBytes(100);
      final Uint8List signature = KeyPair.sign(keyPair, payload);

      final bool isVerified = KeyPair.verify(keyPair.publicKey, payload, signature);

      // Assert
      expect(isVerified, true);
    });

    test('returns false for data signed with different a different key pair', () {
      final KeyPair keyPair1 = KeyPair.random();
      final KeyPair keyPair2 = KeyPair.random();
      final Uint8List payload = CryptoUtils.getRandomBytes(100);
      final Uint8List signature = KeyPair.sign(keyPair1, payload);

      final bool isVerified = KeyPair.verify(keyPair2.publicKey, payload, signature);

      // Assert
      expect(isVerified, isFalse);
    });

    test('returns false if signature has been modified', () {
      final KeyPair keyPair = KeyPair.random();
      final Uint8List payload = CryptoUtils.getRandomBytes(100);

      for (int i = 0; i < CryptoUtils.SIGNATURE_SIZE; i += 4) {
        final Uint8List signature = KeyPair.sign(keyPair, payload);
        signature[i] ^= 0xFF; // modify signature

        final bool isVerified = KeyPair.verify(keyPair.publicKey, payload, signature);

        // Assert
        expect(isVerified, isFalse);
      }
    });

    test('returns false if payload has been modified', () {
      final KeyPair keyPair = KeyPair.random();
      final Uint8List payload = CryptoUtils.getRandomBytes(44);

      for (int i = 0; i < payload.length; i += 4) {
        final Uint8List signature = KeyPair.sign(keyPair, payload);
        payload[i] ^= 0xFF; // modify payload

        final bool isVerified = KeyPair.verify(keyPair.publicKey, payload, signature);

        // Assert
        expect(isVerified, isFalse);
      }
    });

    test('fails if public key is not on curve', () {
      final KeyPair keyPair = KeyPair.random();
      keyPair.publicKey.fillRange(0, keyPair.publicKey.length, 0);
      keyPair.publicKey[keyPair.publicKey.length - 1] = 1;

      final Uint8List payload = CryptoUtils.getRandomBytes(100);
      final Uint8List signature = KeyPair.sign(keyPair, payload);

      final bool isVerified = KeyPair.verify(keyPair.publicKey, payload, signature);

      // Assert
      expect(isVerified, isFalse);
    });

    test('fails if public key does not correspond to private key', () {
      final KeyPair keyPair = KeyPair.random();
      final Uint8List payload = CryptoUtils.getRandomBytes(100);
      final Uint8List signature = KeyPair.sign(keyPair, payload);

      // Alter public key
      for (int i = 0; i < keyPair.publicKey.length; i++) {
        keyPair.publicKey[i] ^= 0xFF;
      }

      final bool isVerified = KeyPair.verify(keyPair.publicKey, payload, signature);

      // Assert
      expect(isVerified, isFalse);
    });

    test('rejects zero public key', () {
      final KeyPair keyPair = KeyPair.random();
      keyPair.publicKey.fillRange(0, keyPair.publicKey.length, 0);

      final Uint8List payload = CryptoUtils.getRandomBytes(100);
      final Uint8List signature = KeyPair.sign(keyPair, payload);

      final bool isVerified = KeyPair.verify(keyPair.publicKey, payload, signature);

      // Assert
      expect(isVerified, isFalse);
    });

    test('cannot verify non canonical signature', () {
      // Prepare
      final KeyPair keyPair = KeyPair.random();
      final Uint8List payload = new Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 0]);
      final Uint8List canonicalSignature = KeyPair.sign(keyPair, payload);

      // this is signature with group order added to 'encodedS' part of signature
      final int size = canonicalSignature.length;
      final Uint8List nonCanonicalSignature = new Uint8List(size);
      ArrayUtils.copy(nonCanonicalSignature, canonicalSignature, numOfElements: size);
      _scalarAddGroupOrder(nonCanonicalSignature.sublist(32));

      final bool isCanonicalVerified =
          KeyPair.verify(keyPair.publicKey, payload, canonicalSignature);
      final bool isNonCanonicalVerified =
          KeyPair.verify(keyPair.privateKey, payload, nonCanonicalSignature);

      // Assert
      expect(isCanonicalVerified, isTrue);
      expect(isNonCanonicalVerified, isFalse);
    });
  });

  // ---------------------------
  // ------ Test vectors -------
  // ---------------------------
  group('test vectors', () {
    // @see https://github.com/nemtech/test-vectors/blob/master/2.test-sign.json
    test('can sign test vectors', () {
      // Sanity check
      expect(CATAPULT_PRIVATE_KEY.length, equals(INPUT_DATA.length));
      expect(CATAPULT_PRIVATE_KEY.length, equals(EXPECTED_SIGNATURES.length));

      for (int i = 0; i < CATAPULT_PRIVATE_KEY.length; i++) {
        // Prepare
        final KeyPair keyPair = KeyPair.fromPrivateKey(CATAPULT_PRIVATE_KEY[i]);
        final Uint8List inputData = HexUtils.getBytes(INPUT_DATA[i]);
        final Uint8List signature = KeyPair.sign(keyPair, inputData);

        // Assert
        final String result = HexUtils.getString(signature).toUpperCase();
        expect(result, equals(EXPECTED_SIGNATURES[i]));
      }
    });

    test('can verify test vectors', () {
      // Sanity check
      expect(CATAPULT_PRIVATE_KEY.length, equals(INPUT_DATA.length));
      expect(CATAPULT_PRIVATE_KEY.length, equals(EXPECTED_SIGNATURES.length));

      for (int i = 0; i < CATAPULT_PRIVATE_KEY.length; i++) {
        // Prepare
        final KeyPair keyPair = KeyPair.fromPrivateKey(CATAPULT_PRIVATE_KEY[i]);
        final Uint8List inputData = HexUtils.getBytes(INPUT_DATA[i]);
        final Uint8List signature = KeyPair.sign(keyPair, inputData);

        final bool isVerified = KeyPair.verify(keyPair.publicKey, inputData, signature);

        // Assert
        expect(isVerified, isTrue);
      }
    });
  });
}

void _scalarAddGroupOrder(Uint8List scalar) {
  // 2^252 + 27742317777372353535851937790883648493, little endian
  final List<int> GROUP_ORDER = [
    0xed,
    0xd3,
    0xf5,
    0x5c,
    0x1a,
    0x63,
    0x12,
    0x58,
    0xd6,
    0x9c,
    0xf7,
    0xa2,
    0xde,
    0xf9,
    0xde,
    0x14,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x00,
    0x10
  ];

  int r = 0;
  for (int i = 0; i < scalar.length; ++i) {
    final t = scalar[i] + GROUP_ORDER[i];
    scalar[i] += GROUP_ORDER[i] + r;
    r = (t >> 8) & 0xFF;
  }
}
