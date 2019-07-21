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

library nem2_sdk_dart.test.core.crypto.key_pair_test;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/core.dart'
    show ArrayUtils, HexUtils, CryptoException, Ed25519, KeyPair;
import 'package:test/test.dart';

void main() {
  final List<String> TEST_PRIVATE_KEYS = [
    '8D31B712AB28D49591EAF5066E9E967B44507FC19C3D54D742F7B3A255CFF4AB',
    '15923F9D2FFFB11D771818E1F7D7DDCD363913933264D58533CB3A5DD2DAA66A',
    'A9323CEF24497AB770516EA572A0A2645EE2D5A75BC72E78DE534C0A03BC328E',
    'D7D816DA0566878EE739EDE2131CD64201BCCC27F88FA51BA5815BCB0FE33CC8',
    '27FC9998454848B987FAD89296558A34DEED4358D1517B953572F3E0AAA0A22D'
  ];

  final List<String> INPUT_DATA = [
    '8ce03cd60514233b86789729102ea09e867fc6d964dea8c2018ef7d0a2e0e24bf7e348e917116690b9',
    'e4a92208a6fc52282b620699191ee6fb9cf04daf48b48fd542c5e43daa9897763a199aaa4b6f10546109f47ac3564fade0',
    '13ed795344c4448a3b256f23665336645a853c5c44dbff6db1b9224b5303b6447fbf8240a2249c55',
    'a2704638434e9f7340f22d08019c4c8e3dbee0df8dd4454a1d70844de11694f4c8ca67fdcb08fed0cec9abb2112b5e5f89',
    'd2488e854dbcdfdb2c9d16c8c0b2fdbc0abb6bac991bfe2b14d359a6bc99d66c00fd60d731ae06d0'
  ];

  final List<String> EXPECTED_SIGNATURES = [
    'C9B1342EAB27E906567586803DA265CC15CCACA411E0AEF44508595ACBC47600D02527F2EED9AB3F28C856D27E30C3808AF7F22F5F243DE698182D373A9ADE03',
    '0755E437ED4C8DD66F1EC29F581F6906AB1E98704ECA94B428A25937DF00EC64796F08E5FEF30C6F6C57E4A5FB4C811D617FA661EB6958D55DAE66DDED205501',
    '15D6585A2A456E90E89E8774E9D12FE01A6ACFE09936EE41271AA1FBE0551264A9FF9329CB6FEE6AE034238C8A91522A6258361D48C5E70A41C1F1C51F55330D',
    'F6FB0D8448FEC0605CF74CFFCC7B7AE8D31D403BCA26F7BD21CB4AC87B00769E9CC7465A601ED28CDF08920C73C583E69D621BA2E45266B86B5FCF8165CBE309',
    'E88D8C32FE165D34B775F70657B96D8229FFA9C783E61198A6F3CCB92F487982D08F8B16AB9157E2EFC3B78F126088F585E26055741A9F25127AC13E883C9A05'
  ];

  // ---------------------------
  // ---- KeyPair creation -----
  // ---------------------------
  group('construction', () {
    test('can create a new random key pair', () {
      final keyPair = KeyPair.random();

      expect(keyPair, isNotNull);
      expect(keyPair.privateKey, isNotNull);
      expect(keyPair.publicKey, isNotNull);
      expect(HexUtils.getString(keyPair.privateKey).length == 64, isTrue);
      expect(HexUtils.getString(keyPair.publicKey).length == 64, isTrue);
    });

    test('can extract from private key test vectors', () {
      final List<String> EXPECTED_PUBLIC_KEYS = [
        '53C659B47C176A70EB228DE5C0A0FF391282C96640C2A42CD5BBD0982176AB1B',
        '3FE4A1AA148F5E76891CE924F5DC05627A87047B2B4AD9242C09C0ECED9B2338',
        'F398C0A2BDACDBD7037D2F686727201641BBF87EF458F632AE2A04B4E8F57994',
        '6A283A241A8D8203B3A1E918B1E6F0A3E14E75E16D4CFFA45AE4EF89E38ED6B5',
        '4DC62B38215826438DE2369743C6BBE6D13428405025DFEFF2857B9A9BC9D821'
      ];

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
                        'Expected: ${Ed25519.KEY_SIZE}, Got: ${privateKeySeed.length}')));
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
  });

  // ---------------------------
  // --------- Signing ---------
  // ---------------------------
  group('sign', () {
    test('fills the signature', () {
      // Prepare
      final KeyPair keyPair = KeyPair.random();
      final Uint8List payload = Ed25519.getRandomBytes(100);

      final Uint8List signature = KeyPair.signData(keyPair, payload);

      // Assert
      final Uint8List emptySig = new Uint8List(Ed25519.SIGNATURE_SIZE);
      expect(ArrayUtils.deepEqual(signature, emptySig), false);
    });

    test('returns same signature for same data signed by same key pairs', () {
      // Prepare
      final String privateKey = HexUtils.getString(Ed25519.getRandomBytes(Ed25519.KEY_SIZE));
      final KeyPair keyPair1 = KeyPair.fromPrivateKey(privateKey);
      final KeyPair keyPair2 = KeyPair.fromPrivateKey(privateKey);
      final Uint8List payload = Ed25519.getRandomBytes(100);

      final Uint8List signature1 = KeyPair.signData(keyPair1, payload);
      final Uint8List signature2 = KeyPair.signData(keyPair2, payload);

      // Assert
      expect(ArrayUtils.deepEqual(signature1, signature2), true);
    });

    test('returns different signature for data signed by different key pairs', () {
      // Prepare
      final KeyPair keyPair1 = KeyPair.random();
      final KeyPair keyPair2 = KeyPair.random();
      final Uint8List payload = Ed25519.getRandomBytes(100);

      final Uint8List signature1 = KeyPair.signData(keyPair1, payload);
      final Uint8List signature2 = KeyPair.signData(keyPair2, payload);

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
      final Uint8List payload = Ed25519.getRandomBytes(100);
      final Uint8List signature = KeyPair.signData(keyPair, payload);

      final bool isVerified = KeyPair.verify(keyPair.publicKey, payload, signature);

      // Assert
      expect(isVerified, true);
    });

    test('returns false for data signed with different a different key pair', () {
      final KeyPair keyPair1 = KeyPair.random();
      final KeyPair keyPair2 = KeyPair.random();
      final Uint8List payload = Ed25519.getRandomBytes(100);
      final Uint8List signature = KeyPair.signData(keyPair1, payload);

      final bool isVerified = KeyPair.verify(keyPair2.publicKey, payload, signature);

      // Assert
      expect(isVerified, isFalse);
    });

    test('returns false if signature has been modified', () {
      final KeyPair keyPair = KeyPair.random();
      final Uint8List payload = Ed25519.getRandomBytes(100);

      for (int i = 0; i < Ed25519.SIGNATURE_SIZE; i += 4) {
        final Uint8List signature = KeyPair.signData(keyPair, payload);
        signature[i] ^= 0xFF; // modify signature

        final bool isVerified = KeyPair.verify(keyPair.publicKey, payload, signature);

        // Assert
        expect(isVerified, isFalse);
      }
    });

    test('returns false if payload has been modified', () {
      final KeyPair keyPair = KeyPair.random();
      final Uint8List payload = Ed25519.getRandomBytes(44);

      for (int i = 0; i < payload.length; i += 4) {
        final Uint8List signature = KeyPair.signData(keyPair, payload);
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

      final Uint8List payload = Ed25519.getRandomBytes(100);
      final Uint8List signature = KeyPair.signData(keyPair, payload);

      final bool isVerified = KeyPair.verify(keyPair.publicKey, payload, signature);

      // Assert
      expect(isVerified, isFalse);
    });

    test('fails if public key does not correspond to private key', () {
      final KeyPair keyPair = KeyPair.random();
      final Uint8List payload = Ed25519.getRandomBytes(100);
      final Uint8List signature = KeyPair.signData(keyPair, payload);

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

      final Uint8List payload = Ed25519.getRandomBytes(100);
      final Uint8List signature = KeyPair.signData(keyPair, payload);

      final bool isVerified = KeyPair.verify(keyPair.publicKey, payload, signature);

      // Assert
      expect(isVerified, isFalse);
    });

    test('cannot verify non canonical signature', () {
      // Prepare
      final KeyPair keyPair = KeyPair.random();
      final Uint8List payload = new Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 0]);
      final Uint8List canonicalSignature = KeyPair.signData(keyPair, payload);

      // this is signature with group order added to 'encodedS' part of signature
      final int size = canonicalSignature.length;
      final Uint8List nonCanonicalSignature = new Uint8List(size);
      ArrayUtils.copy(nonCanonicalSignature, canonicalSignature, numOfElements: size);
      scalarAddGroupOrder(nonCanonicalSignature.sublist(32));

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
    test('can sign test vectors', () {
      // Sanity check
      expect(TEST_PRIVATE_KEYS.length, equals(INPUT_DATA.length));
      expect(TEST_PRIVATE_KEYS.length, equals(EXPECTED_SIGNATURES.length));

      for (int i = 0; i < TEST_PRIVATE_KEYS.length; i++) {
        // Prepare
        final KeyPair keyPair = KeyPair.fromPrivateKey(TEST_PRIVATE_KEYS[i]);
        final Uint8List inputData = HexUtils.getBytes(INPUT_DATA[i]);
        final Uint8List signature = KeyPair.signData(keyPair, inputData);

        // Assert
        final String result = HexUtils.getString(signature).toUpperCase();
        expect(result, equals(EXPECTED_SIGNATURES[i]));
      }
    });

    test('can verify test vectors', () {
      // Sanity check
      expect(TEST_PRIVATE_KEYS.length, equals(INPUT_DATA.length));
      expect(TEST_PRIVATE_KEYS.length, equals(EXPECTED_SIGNATURES.length));

      for (int i = 0; i < TEST_PRIVATE_KEYS.length; i++) {
        // Prepare
        final KeyPair keyPair = KeyPair.fromPrivateKey(TEST_PRIVATE_KEYS[i]);
        final Uint8List inputData = HexUtils.getBytes(INPUT_DATA[i]);
        final Uint8List signature = KeyPair.signData(keyPair, inputData);

        final bool isVerified = KeyPair.verify(keyPair.publicKey, inputData, signature);

        // Assert
        expect(isVerified, isTrue);
      }
    });
  });

  // ---------------------------
  // ---- Derive Shared Key ----
  // ---------------------------
  group('derived shared key', () {
    const int SALT_SIZE = 32;

    test('fails if salt has the wrong size', () {
      // Prepare: create a salt that is too long
      final KeyPair keyPair = KeyPair.random();
      final Uint8List publicKey = KeyPair.randomPublicKey();
      final Uint8List salt = Ed25519.getRandomBytes(SALT_SIZE + 1);

      // Assert
      expect(
          () => KeyPair.deriveSharedKey(keyPair, publicKey, salt),
          throwsA(predicate((e) =>
              e is ArgumentError && e.message == 'Salt has unexpected size: ${salt.length}')));
    });

    test('derives same shared key for both partners', () {
      // Prepare:
      final KeyPair keyPair1 = KeyPair.random();
      final KeyPair keyPair2 = KeyPair.random();
      final Uint8List salt = Ed25519.getRandomBytes(SALT_SIZE);

      final Uint8List sharedKey1 = KeyPair.deriveSharedKey(keyPair1, keyPair2.publicKey, salt);
      final Uint8List sharedKey2 = KeyPair.deriveSharedKey(keyPair2, keyPair1.publicKey, salt);

      // Assert
      expect(ArrayUtils.deepEqual(sharedKey1, sharedKey2), isTrue);
    });

    test('derives different shared key for different partners', () {
      // Prepare:
      final KeyPair keyPair = KeyPair.random();
      final Uint8List publicKey1 = KeyPair.randomPublicKey();
      final Uint8List publicKey2 = KeyPair.randomPublicKey();
      final Uint8List salt = Ed25519.getRandomBytes(SALT_SIZE);

      final Uint8List sharedKey1 = KeyPair.deriveSharedKey(keyPair, publicKey1, salt);
      final Uint8List sharedKey2 = KeyPair.deriveSharedKey(keyPair, publicKey2, salt);

      // Assert
      expect(ArrayUtils.deepEqual(sharedKey1, sharedKey2), isFalse);
    });

    test('can derive deterministic shared key from well known inputs', () {
      // Prepare:
      const privateKeyString = '8F545C2816788AB41D352F236D80DBBCBC34705B5F902EFF1F1D88327C7C1300';
      final KeyPair keyPair = KeyPair.fromPrivateKey(privateKeyString);
      final Uint8List publicKey =
          HexUtils.getBytes('BF684FB1A85A8C8091EE0442EDDB22E51683802AFA0C0E7C6FE3F3E3E87A8D72');
      final Uint8List salt =
          HexUtils.getBytes('422C39DF16AAE42A74A5597D6EE2D59CFB4EEB6B3F26D98425B9163A03DAA3B5');

      final Uint8List sharedKey = KeyPair.deriveSharedKey(keyPair, publicKey, salt);
      final String sharedKeyHexString = HexUtils.getString(sharedKey).toUpperCase();

      // Assert
      const expected = 'FF9623D28FBC13B6F0E0659117FC7BE294DB3385C046055A6BAC39EDF198D50D';
      expect(sharedKeyHexString, equals(expected));
    });
  });
}

void scalarAddGroupOrder(Uint8List scalar) {
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
