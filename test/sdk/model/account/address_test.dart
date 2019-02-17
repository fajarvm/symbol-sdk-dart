library nem2_sdk_dart.test.sdk.model.account.address_test;

import 'dart:typed_data' show Uint8List;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/src/sdk/model.dart' show Address, NetworkType;
import 'package:nem2_sdk_dart/src/core/crypto.dart' show KeyPair;
import 'package:nem2_sdk_dart/src/core/utils.dart' show ArrayUtils, HexUtils;

main() {
  group('fromPublicKey', () {});
  group('fromRawAddress', () {});
  group('stringToAddress', () {
    test('can create address from valid encoded address', () {
      final String encoded = 'NAR3W7B4BCOZSZMFIZRYB3N5YGOUSWIYJCJ6HDFG';
      final String expectedHex = '6823BB7C3C089D996585466380EDBDC19D4959184893E38CA6';

      final Uint8List decoded = Address.stringToAddress(encoded);

      expect(Address.isValidAddress(decoded), equals(true));
      expect(HexUtils.getString(decoded).toUpperCase(), equals(expectedHex));
    });

    test('cannot create address from an encoded string with the invalid length', () {
      assertCannotCreateAddress('NC5J5DI2URIC4H3T3IMXQS25PWQWZIPEV6EV7LASABCDEFGH',
          'The encoded address NC5J5DI2URIC4H3T3IMXQS25PWQWZIPEV6EV7LASABCDEFGH does not represent a valid encoded address');
    });

    test('cannot create address from invalid encoded string', () {
      assertCannotCreateAddress(
          'NC5(5DI2URIC4H3T3IMXQS25PWQWZIPEV6EV7LAS', 'illegal base32 character (');
      assertCannotCreateAddress(
          'NC5J1DI2URIC4H3T3IMXQS25PWQWZIPEV6EV7LAS', 'illegal base32 character 1');
      assertCannotCreateAddress(
          'NC5J5?I2URIC4H3T3IMXQS25PWQWZIPEV6EV7LAS', 'illegal base32 character ?');
    });
  });
  group('addressToString', () {
    test('can create encoded address from address', () {
      final String decodedHex = '6823BB7C3C089D996585466380EDBDC19D4959184893E38CA6';
      final String expected = 'NAR3W7B4BCOZSZMFIZRYB3N5YGOUSWIYJCJ6HDFG';

      final String encoded = Address.addressToString(HexUtils.getBytes(decodedHex));

      expect(encoded, equals(expected));
    });
  });
  group('publicKeyToAddress', () {
    test('can create address from a public key for a known network', () {
      final String expected = '6023BB7C3C089D996585466380EDBDC19D49591848B3727714';
      final Uint8List publicKey =
          HexUtils.getBytes('3485D98EFD7EB07ADAFCFD1A157D89DE2796A95E780813C0258AF3F5F84ED8CB');

      final Uint8List decoded = Address.publicKeyToAddress(publicKey, NetworkType.MIJIN);

      expect(decoded[0], equals(NetworkType.MIJIN));
      expect(Address.isValidAddress(decoded), equals(true));
      expect(HexUtils.getString(decoded).toUpperCase(), equals(expected));
    });

    test('can create address from a public key for a custom network', () {
      final String expected = '9823BB7C3C089D996585466380EDBDC19D495918484BF7E997';
      final Uint8List publicKey =
          HexUtils.getBytes('3485D98EFD7EB07ADAFCFD1A157D89DE2796A95E780813C0258AF3F5F84ED8CB');

      final Uint8List decoded = Address.publicKeyToAddress(publicKey, NetworkType.TEST_NET);

      expect(decoded[0], equals(NetworkType.TEST_NET));
      expect(Address.isValidAddress(decoded), equals(true));
      expect(HexUtils.getString(decoded).toUpperCase(), equals(expected));
    });

    test('address calculation is deterministic', () {
      final Uint8List publicKey =
          HexUtils.getBytes('3485D98EFD7EB07ADAFCFD1A157D89DE2796A95E780813C0258AF3F5F84ED8CB');

      final Uint8List decoded1 = Address.publicKeyToAddress(publicKey, NetworkType.MIJIN);
      final Uint8List decoded2 = Address.publicKeyToAddress(publicKey, NetworkType.MIJIN);

      expect(Address.isValidAddress(decoded1), equals(true));
      expect(ArrayUtils.deepEqual(decoded1, decoded2), equals(true));
    });

    test('different public keys result in different addresses', () {
      final Uint8List publicKey1 = KeyPair.randomPublicKey();
      final Uint8List publicKey2 = KeyPair.randomPublicKey();

      final Uint8List decoded1 = Address.publicKeyToAddress(publicKey1, NetworkType.MIJIN);
      final Uint8List decoded2 = Address.publicKeyToAddress(publicKey2, NetworkType.MIJIN);

      expect(Address.isValidAddress(decoded1), equals(true));
      expect(Address.isValidAddress(decoded2), equals(true));
      expect(ArrayUtils.deepEqual(decoded1, decoded2), equals(false));
    });

    test('different newtork types result in different addresses', () {
      final Uint8List publicKey = KeyPair.randomPublicKey();

      final Uint8List decoded1 = Address.publicKeyToAddress(publicKey, NetworkType.MIJIN);
      final Uint8List decoded2 = Address.publicKeyToAddress(publicKey, NetworkType.MIJIN_TEST);
      final Uint8List decoded3 = Address.publicKeyToAddress(publicKey, NetworkType.MAIN_NET);
      final Uint8List decoded4 = Address.publicKeyToAddress(publicKey, NetworkType.TEST_NET);

      expect(Address.isValidAddress(decoded1), equals(true));
      expect(Address.isValidAddress(decoded2), equals(true));
      expect(Address.isValidAddress(decoded3), equals(true));
      expect(Address.isValidAddress(decoded4), equals(true));
      expect(ArrayUtils.deepEqual(decoded1, decoded2), equals(false));
      expect(ArrayUtils.deepEqual(decoded1, decoded3), equals(false));
      expect(ArrayUtils.deepEqual(decoded1, decoded4), equals(false));
      expect(ArrayUtils.deepEqual(decoded2, decoded3), equals(false));
      expect(ArrayUtils.deepEqual(decoded2, decoded4), equals(false));
      expect(ArrayUtils.deepEqual(decoded3, decoded4), equals(false));
    });
  });
  group('prettify', () {
    test('can convert an address into a pretty format address', () {
      final String validHex = '6823BB7C3C089D996585466380EDBDC19D4959184893E38CA6';
      final String expected = 'NAR3W7B4BCOZSZMFIZRYB3N5YGOUSWIYJCJ6HDFG';
      final Uint8List decoded = HexUtils.getBytes(validHex);

      expect(Address.isValidAddress(decoded), equals(true));
      expect(Address.addressToString(decoded), equals(expected));
      expect(Address.prettify(expected), equals('NAR3W7-B4BCOZ-SZMFIZ-RYB3N5-YGOUSW-IYJCJ6-HDFG'));
    });
  });
  group('isValidAddress', () {
    test('returns true for a valid address', () {
      final String validHex = '6823BB7C3C089D996585466380EDBDC19D4959184893E38CA6';
      final Uint8List decoded = HexUtils.getBytes(validHex);

      expect(Address.isValidAddress(decoded), equals(true));
    });

    test('returns false for an address with invalid checksum', () {
      final String validHex = '6823BB7C3C089D996585466380EDBDC19D4959184893E38CA6';
      final Uint8List decoded = HexUtils.getBytes(validHex);

      // manipulate the checksum to make it invalid
      decoded[Address.ADDRESS_DECODED_SIZE - 1] ^= 0xFF;

      expect(Address.isValidAddress(decoded), equals(false));
    });

    test('returns false for an address with invalid hash', () {
      final String validHex = '6823BB7C3C089D996585466380EDBDC19D4959184893E38CA6';
      final Uint8List decoded = HexUtils.getBytes(validHex);

      // manipulate the ripemd160 hash to make it invalid
      decoded[5] ^= 0xFF;

      expect(Address.isValidAddress(decoded), equals(false));
    });
  });
  group('isValidEncodedAddress', () {
    test('returns true for valid encoded address', () {
      final String encoded = 'NAR3W7B4BCOZSZMFIZRYB3N5YGOUSWIYJCJ6HDFG';

      expect(Address.isValidEncodedAddress(encoded), equals(true));
    });

    test('returns false for valid encoded address', () {
      // Change the last character to make this encoded address invalid
      final String encoded = 'NAR3W7B4BCOZSZMFIZRYB3N5YGOUSWIYJCJ6HDFH';

      expect(Address.isValidEncodedAddress(encoded), equals(false));
    });

    test('returns false for an encoded address with invalid length', () {
      final String encoded = 'NAR3W7B4BCOZSZMFIZRYB3N5YGOUSWIYJCJ6HDFGABC';

      expect(Address.isValidEncodedAddress(encoded), equals(false));
    });

    test('white spaces invalidates the encoded address', () {
      final String encoded = 'NAR3W7B4BCOZSZMFIZRYB3N5YGOUSWIYJCJ6HDFGABC';

      expect(Address.isValidEncodedAddress('  \t   ${encoded}'), equals(false));
      expect(Address.isValidEncodedAddress('${encoded}   \t   '), equals(false));
      expect(Address.isValidEncodedAddress('   \t   ${encoded}   \t   '), equals(false));
    });
  });
}

void assertCannotCreateAddress(final String encodedAddress, final String message) {
  expect(() => Address.stringToAddress(encodedAddress),
      throwsA(predicate((e) => e is ArgumentError && e.message == message)));
}
