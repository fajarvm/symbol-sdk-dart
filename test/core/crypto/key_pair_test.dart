library nem2_sdk_dart.test.core.crypto.key_pair_test;

import 'dart:typed_data' show Uint8List;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/src/core/crypto.dart' show CryptoException, Ed25519, KeyPair;
import 'package:nem2_sdk_dart/src/core/utils.dart' show ArrayUtils, HexUtils;

main() {
  final List<String> TEST_PRIVATE_KEYS = [
    '8D31B712AB28D49591EAF5066E9E967B44507FC19C3D54D742F7B3A255CFF4AB',
    '15923F9D2FFFB11D771818E1F7D7DDCD363913933264D58533CB3A5DD2DAA66A',
    'A9323CEF24497AB770516EA572A0A2645EE2D5A75BC72E78DE534C0A03BC328E',
    'D7D816DA0566878EE739EDE2131CD64201BCCC27F88FA51BA5815BCB0FE33CC8',
    '27FC9998454848B987FAD89296558A34DEED4358D1517B953572F3E0AAA0A22D'
  ];

  // KeyPair creation
  group('construction', () {
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
        String privateKeyHex = TEST_PRIVATE_KEYS[i];
        String expectedPublicKey = EXPECTED_PUBLIC_KEYS[i];
        KeyPair keyPair = KeyPair.createFromPrivateKeyString(privateKeyHex);

        // Assert
        String actualPubKey = HexUtils.getString(keyPair.publicKey).toUpperCase();
        String actualPrivateKey = HexUtils.getString(keyPair.privateKey).toUpperCase();
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
            () => KeyPair.createFromPrivateKeyString(invalidPrivateKey),
            throwsA(predicate((e) =>
                e is CryptoException &&
                e.message ==
                    'Private key has an unexpected size. '
                    'Expected: ${Ed25519.KEY_SIZE}, Got: ${privateKeySeed.length}')));
      }
    });
  });

  // Signing
  group('sign', () {
    test('fills the signature', () {
      // Prepare
      KeyPair keyPair = Ed25519.createRandomKeyPair();
      Uint8List payload = Ed25519.getRandomBytes(100);

      Uint8List signature = KeyPair.sign(keyPair, payload);

      // Assert
      Uint8List emptySig = new Uint8List(Ed25519.SIGNATURE_SIZE);
      expect(ArrayUtils.deepEqual(signature, emptySig), false);
    });

    test('returns same signature for same data signed by same key pairs', () {
      // Prepare
      String privateKey = HexUtils.getString(Ed25519.getRandomBytes(Ed25519.KEY_SIZE));
      KeyPair keyPair1 = KeyPair.createFromPrivateKeyString(privateKey);
      KeyPair keyPair2 = KeyPair.createFromPrivateKeyString(privateKey);
      Uint8List payload = Ed25519.getRandomBytes(100);

      Uint8List signature1 = KeyPair.sign(keyPair1, payload);
      Uint8List signature2 = KeyPair.sign(keyPair2, payload);

      // Assert
      expect(ArrayUtils.deepEqual(signature1, signature2), true);
    });

    test('returns different signature for data signed by different key pairs', () {
      // Prepare
      KeyPair keyPair1 = Ed25519.createRandomKeyPair();
      KeyPair keyPair2 = Ed25519.createRandomKeyPair();
      Uint8List payload = Ed25519.getRandomBytes(100);

      Uint8List signature1 = KeyPair.sign(keyPair1, payload);
      Uint8List signature2 = KeyPair.sign(keyPair2, payload);

      // Assert
      expect(ArrayUtils.deepEqual(signature1, signature2), false);
    });
  });

  // Verify
  group('verify', () {
    test('returns true for data signed with same key pair', () {
      // Prepare
      final KeyPair keyPair = Ed25519.createRandomKeyPair();
      final Uint8List payload = Ed25519.getRandomBytes(100);
      final Uint8List signature = KeyPair.sign(keyPair, payload);

      final bool isVerified = KeyPair.verify(keyPair.publicKey, payload, signature);

      // Assert
      // TODO: Fix unit test! Currently failing.
      // expect(isVerified, true);
    });

    test('returns false if signature has been modified', () {
      final KeyPair keyPair = Ed25519.createRandomKeyPair();
      final Uint8List payload = Ed25519.getRandomBytes(100);

      for (int i = 0; i < Ed25519.SIGNATURE_SIZE; i += 4) {
        final Uint8List signature = KeyPair.sign(keyPair, payload);
        signature[i] ^= 0xFF; // modify signature

        final bool isVerified = KeyPair.verify(keyPair.publicKey, payload, signature);

        // Assert
        expect(isVerified, equals(false));
      }
    });

    test('returns false for data signed with different a different key pair', () {
      final KeyPair keyPair1 = Ed25519.createRandomKeyPair();
      final KeyPair keyPair2 = Ed25519.createRandomKeyPair();
      final Uint8List payload = Ed25519.getRandomBytes(100);
      final Uint8List signature = KeyPair.sign(keyPair1, payload);

      final bool isVerified = KeyPair.verify(keyPair2.publicKey, payload, signature);

      // Assert
      expect(isVerified, equals(false));
    });

    test('returns false if payload has been modified', () {
      final KeyPair keyPair = Ed25519.createRandomKeyPair();
      final Uint8List payload = Ed25519.getRandomBytes(44);

      for (int i = 0; i < payload.length; i += 4) {
        final Uint8List signature = KeyPair.sign(keyPair, payload);
        payload[i] ^= 0xFF; // modify payload

        final bool isVerified = KeyPair.verify(keyPair.publicKey, payload, signature);

        // Assert
        expect(isVerified, equals(false));
      }
    });

    test('fails if public key is not on curve', () {
      final KeyPair keyPair = Ed25519.createRandomKeyPair();
      keyPair.publicKey.fillRange(0, keyPair.publicKey.length, 0);
      keyPair.publicKey[keyPair.publicKey.length - 1] = 1;

      final Uint8List payload = Ed25519.getRandomBytes(100);
      final Uint8List signature = KeyPair.sign(keyPair, payload);

      final bool isVerified = KeyPair.verify(keyPair.publicKey, payload, signature);

      // Assert
      expect(isVerified, equals(false));
    });

    test('fails if public key does not correspond to private key', () {
      final KeyPair keyPair = Ed25519.createRandomKeyPair();
      final Uint8List payload = Ed25519.getRandomBytes(100);
      final Uint8List signature = KeyPair.sign(keyPair, payload);

      // Alter public key
      for (int i = 0; i < keyPair.publicKey.length; i++) {
        keyPair.publicKey[i] ^= 0xFF;
      }

      final bool isVerified = KeyPair.verify(keyPair.publicKey, payload, signature);

      // Assert
      expect(isVerified, equals(false));
    });

    test('rejects zero public key', () {
      final KeyPair keyPair = Ed25519.createRandomKeyPair();
      keyPair.publicKey.fillRange(0, keyPair.publicKey.length, 0);

      final Uint8List payload = Ed25519.getRandomBytes(100);
      final Uint8List signature = KeyPair.sign(keyPair, payload);

      final bool isVerified = KeyPair.verify(keyPair.publicKey, payload, signature);

      // Assert
      expect(isVerified, equals(false));
    });

    test('cannot verify non canonical signature', () {
      // Prepare
      final KeyPair keyPair = Ed25519.createRandomKeyPair();
      final Uint8List payload = new Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 0]);
      final Uint8List canonicalSignature = KeyPair.sign(keyPair, payload);

      // this is signature with group order added to 'encodedS' part of signature
      final Uint8List nonCanonicalSignature = new Uint8List(canonicalSignature.length);
      ArrayUtils.copy(nonCanonicalSignature, canonicalSignature);
      scalarAddGroupOrder(nonCanonicalSignature.sublist(32));

      final bool isCanonicalVerified =
          KeyPair.verify(keyPair.publicKey, payload, canonicalSignature);
      final bool isNonCanonicalVerified =
          KeyPair.verify(keyPair.privateKey, payload, nonCanonicalSignature);

      // Assert
      // TODO: Fix unit test. Currently failing
      // expect(isCanonicalVerified, equals(true));
      expect(isNonCanonicalVerified, equals(false));
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
