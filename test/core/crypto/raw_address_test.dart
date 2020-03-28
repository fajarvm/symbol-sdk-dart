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

library symbol_sdk_dart.test.core.crypto.raw_address_test;

import 'dart:typed_data' show Uint8List;

import 'package:symbol_sdk_dart/core.dart' show ArrayUtils, HexUtils, RawAddress;
import 'package:symbol_sdk_dart/symbol_sdk_dart.dart' show NamespaceId, NetworkType;
import 'package:test/test.dart';

void main() {
  group('RawAddress', () {
    group('sanity test', () {
      test('valid constants', () {
        expect(RawAddress.RIPEMD_160_SIZE, 20);
        expect(RawAddress.ADDRESS_DECODED_SIZE, 25);
        expect(RawAddress.ADDRESS_ENCODED_SIZE, 40);
        expect(RawAddress.KEY_SIZE, 32);
        expect(RawAddress.CHECKSUM_SIZE, 4);
        expect(RawAddress.START_CHECKSUM_SIZE, 21);
      });
    });

    group('aliasToRecipient', () {
      test('can convert a namespaceId alias into recipient', () {
        final namespaceId = NamespaceId.fromHex('9550CA3FC9B41FC5');
        final namespaceIdByte = HexUtils.getBytes(namespaceId.toHex());

        final Uint8List result =
            RawAddress.aliasToRecipient(namespaceIdByte, NetworkType.MIJIN_TEST);

        const expectedHex = '91c51fb4c93fca509500000000000000000000000000000000';
        expect(HexUtils.bytesToHex(result), equals(expectedHex));

        final expectedByte = (NetworkType.MIJIN_TEST.value | 1);
        expect(result[0], equals(expectedByte));
      });
    });

    group('stringToAddress', () {
      test('can create address from valid encoded address', () {
        const encoded = 'NAR3W7B4BCOZSZMFIZRYB3N5YGOUSWIYJCJ6HDFG';
        const expectedHex = '6823BB7C3C089D996585466380EDBDC19D4959184893E38CA6';

        final decoded = RawAddress.stringToAddress(encoded);

        expect(RawAddress.isValidAddress(decoded, NetworkType.MIJIN_TEST), isTrue);
        expect(HexUtils.getString(decoded).toUpperCase(), equals(expectedHex));
      });

      test('cannot create address from an encoded string with the invalid length', () {
        assertCannotCreateAddress('NC5J5DI2URIC4H3T3IMXQS25PWQWZIPEV6EV7LASABCDEFGH',
            'does not represent a valid encoded address');
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
      test('can create an encoded address string from a decoded address', () {
        const decodedHex = '6823bb7c3c089d996585466380edbdc19d4959184893e38ca6';
        const expected = 'NAR3W7B4BCOZSZMFIZRYB3N5YGOUSWIYJCJ6HDFG';

        final encoded = RawAddress.addressToString(HexUtils.getBytes(decodedHex));

        expect(encoded, equals(expected));
      });
    });

    group('publicKeyToAddress', () {
      test('can create from public key for well known network', () {
        const expectedHex = '6023bb7c3c089d996585466380edbdc19d49591848b3727714';
        const publicKey = '3485d98efd7eb07adafcfd1a157d89de2796a95e780813c0258af3f5f84ed8cb';
        final publicKeyByte = HexUtils.getBytes(publicKey);

        final decoded = RawAddress.publicKeyToAddress(publicKeyByte, NetworkType.MIJIN);

        expect(decoded[0], equals(NetworkType.MIJIN.value));
        expect(HexUtils.getString(decoded), equals(expectedHex));
      });

      test('can create from public key for custom network', () {
        const expectedHex = '9023bb7c3c089d996585466380edbdc19d495918486f4f86a7';
        const publicKey = '3485d98efd7eb07adafcfd1a157d89de2796a95e780813c0258af3f5f84ed8cb';
        final publicKeyByte = HexUtils.getBytes(publicKey);

        final decoded = RawAddress.publicKeyToAddress(publicKeyByte, NetworkType.MIJIN_TEST);

        expect(decoded[0], equals(NetworkType.MIJIN_TEST.value));
        expect(HexUtils.getString(decoded), equals(expectedHex));
      });

      test('can deterministicly generate address', () {
        const expectedHex = '9023bb7c3c089d996585466380edbdc19d495918486f4f86a7';
        const publicKey = '3485d98efd7eb07adafcfd1a157d89de2796a95e780813c0258af3f5f84ed8cb';
        final publicKeyByte = HexUtils.getBytes(publicKey);

        final decoded1 = RawAddress.publicKeyToAddress(publicKeyByte, NetworkType.MIJIN_TEST);
        final decoded2 = RawAddress.publicKeyToAddress(publicKeyByte, NetworkType.MIJIN_TEST);

        expect(decoded1[0], equals(NetworkType.MIJIN_TEST.value));
        expect(HexUtils.getString(decoded1), equals(expectedHex));
        expect(decoded2[0], equals(NetworkType.MIJIN_TEST.value));
        expect(HexUtils.getString(decoded2), equals(expectedHex));

        // deep equal
        expect(ArrayUtils.deepEqual(decoded1, decoded2), isTrue);
      });

      test('different public keys generates different addresses', () {
        const publicKey1 = '1464953393CE96A08ABA6184601FD08864E910696B060FF7064474726E666CA8';
        final publicKey1Byte = HexUtils.getBytes(publicKey1);
        const publicKey2 = 'b4f12e7c9f6946091e2cb8b6d3a12b50d17ccbbf646386ea27ce2946a7423dcf';
        final publicKey2Byte = HexUtils.getBytes(publicKey2);

        final decoded1 = RawAddress.publicKeyToAddress(publicKey1Byte, NetworkType.MIJIN_TEST);
        final decoded2 = RawAddress.publicKeyToAddress(publicKey2Byte, NetworkType.MIJIN_TEST);

        // deep equal
        expect(ArrayUtils.deepEqual(decoded1, decoded2), isFalse);
      });

      test('different networks generates different addresses', () {
        const publicKey = '1464953393CE96A08ABA6184601FD08864E910696B060FF7064474726E666CA8';
        final publicKeyByte = HexUtils.getBytes(publicKey);

        final decoded1 = RawAddress.publicKeyToAddress(publicKeyByte, NetworkType.MIJIN_TEST);
        final decoded2 = RawAddress.publicKeyToAddress(publicKeyByte, NetworkType.TEST_NET);

        // deep equal
        expect(ArrayUtils.deepEqual(decoded1, decoded2), isFalse);
      });
    });

    group('isValidAddress', () {
      test('returns true for a valid address', () {
        const validHex = '6823BB7C3C089D996585466380EDBDC19D4959184893E38CA6';
        final decoded = HexUtils.getBytes(validHex);

        expect(RawAddress.isValidAddress(decoded, NetworkType.MIJIN_TEST), isTrue);
      });

      test('returns false for an address with invalid checksum', () {
        const validHex = '6823BB7C3C089D996585466380EDBDC19D4959184893E38CA6';
        final decoded = HexUtils.getBytes(validHex);

        // manipulate the checksum to make it invalid
        decoded[RawAddress.ADDRESS_DECODED_SIZE - 1] ^= 0xFF;

        expect(RawAddress.isValidAddress(decoded, NetworkType.MIJIN_TEST), isFalse);
      });

      test('returns false for an address with invalid hash', () {
        const validHex = '6823BB7C3C089D996585466380EDBDC19D4959184893E38CA6';
        final decoded = HexUtils.getBytes(validHex);

        // manipulate the ripemd160 hash to make it invalid
        decoded[5] ^= 0xFF;

        expect(RawAddress.isValidAddress(decoded, NetworkType.MIJIN_TEST), isFalse);
      });
    });

    group('NEMTECH Test Vectors', () {
      // Test vectors: https://raw.githubusercontent.com/nemtech/test-vectors/master/1.test-address.json
      test('Catapult test vector [PublicNet] - Public key to Address', () {
        // Arrange:
        const Public_Keys = [
          '2E834140FD66CF87B254A693A2C7862C819217B676D3943267156625E816EC6F',
          '4875FD2E32875D1BC6567745F1509F0F890A1BF8EE59FA74452FA4183A270E03',
          '9F780097FB6A1F287ED2736A597B8EA7F08D20F1ECDB9935DE6694ECF1C58900',
          '0815926E003CDD5AF0113C0E067262307A42CD1E697F53B683F7E5F9F57D72C9',
          '3683B3E45E76870CFE076E47C2B34CE8E3EAEC26C8AA7C1ED752E3E840AF8A27',
        ];

        const Addresses = [
          'NATNE7Q5BITMUTRRN6IB4I7FLSDRDWZA34SQ3365',
          'NDR6EW2WBHJQDYMNGFX2UBZHMMZC5PGL2YCZOQR4',
          'NCOXVZMAZJTT4I3F7EAZYGNGR77D6WPTRH6SYIUT',
          'NDZ4373ASEGJ7S7GQTKF26TIIMC7HK5EWFDDCHAF',
          'NDI5I7Z3BRBAAHTZHGONGOXX742CW4W5QAZ4BMVY',
        ];

        // Sanity:
        expect(Public_Keys.length, equals(Addresses.length));

        for (int i = 0; i < Public_Keys.length; ++i) {
          // Arrange:
          var publicKeyHex = Public_Keys[i];
          var expectedAddress = Addresses[i];

          // Act:
          var result = RawAddress.addressToString(
              RawAddress.publicKeyToAddress(HexUtils.getBytes(publicKeyHex), NetworkType.MAIN_NET));

          // Assert:
          expect(result.toUpperCase(), equals(expectedAddress.toUpperCase()));
        }
      });

      test('Catapult test vector [PublicTest] -  Public key to Address', () {
        // Arrange:
        const Public_Keys = [
          '2E834140FD66CF87B254A693A2C7862C819217B676D3943267156625E816EC6F',
          '4875FD2E32875D1BC6567745F1509F0F890A1BF8EE59FA74452FA4183A270E03',
          '9F780097FB6A1F287ED2736A597B8EA7F08D20F1ECDB9935DE6694ECF1C58900',
          '0815926E003CDD5AF0113C0E067262307A42CD1E697F53B683F7E5F9F57D72C9',
          '3683B3E45E76870CFE076E47C2B34CE8E3EAEC26C8AA7C1ED752E3E840AF8A27',
        ];

        const Addresses = [
          'TATNE7Q5BITMUTRRN6IB4I7FLSDRDWZA37JGO5UW',
          'TDR6EW2WBHJQDYMNGFX2UBZHMMZC5PGL2YBO3KHD',
          'TCOXVZMAZJTT4I3F7EAZYGNGR77D6WPTRE3VIBRU',
          'TDZ4373ASEGJ7S7GQTKF26TIIMC7HK5EWEPHRSM7',
          'TDI5I7Z3BRBAAHTZHGONGOXX742CW4W5QCY5ZUBR',
        ];

        // Sanity:
        expect(Public_Keys.length, equals(Addresses.length));

        for (int i = 0; i < Public_Keys.length; ++i) {
          // Arrange:
          var publicKeyHex = Public_Keys[i];
          var expectedAddress = Addresses[i];

          // Act:
          var result = RawAddress.addressToString(RawAddress.publicKeyToAddress(
              HexUtils.getBytes(publicKeyHex), NetworkType.TEST_NET));

          // Assert:
          expect(result.toUpperCase(), equals(expectedAddress.toUpperCase()));
        }
      });

      test('Catapult test vector [MIJIN] -  Public key to Address', () {
        // Arrange:
        const Public_Keys = [
          '2E834140FD66CF87B254A693A2C7862C819217B676D3943267156625E816EC6F',
          '4875FD2E32875D1BC6567745F1509F0F890A1BF8EE59FA74452FA4183A270E03',
          '9F780097FB6A1F287ED2736A597B8EA7F08D20F1ECDB9935DE6694ECF1C58900',
          '0815926E003CDD5AF0113C0E067262307A42CD1E697F53B683F7E5F9F57D72C9',
          '3683B3E45E76870CFE076E47C2B34CE8E3EAEC26C8AA7C1ED752E3E840AF8A27',
        ];

        const Addresses = [
          'MATNE7Q5BITMUTRRN6IB4I7FLSDRDWZA34YACREP',
          'MDR6EW2WBHJQDYMNGFX2UBZHMMZC5PGL22B27FN3',
          'MCOXVZMAZJTT4I3F7EAZYGNGR77D6WPTRFDHL7JO',
          'MDZ4373ASEGJ7S7GQTKF26TIIMC7HK5EWFN3NK2Z',
          'MDI5I7Z3BRBAAHTZHGONGOXX742CW4W5QCLCVED4',
        ];

        // Sanity:
        expect(Public_Keys.length, equals(Addresses.length));

        for (int i = 0; i < Public_Keys.length; ++i) {
          // Arrange:
          var publicKeyHex = Public_Keys[i];
          var expectedAddress = Addresses[i];

          // Act:
          var result = RawAddress.addressToString(RawAddress.publicKeyToAddress(
              HexUtils.getBytes(publicKeyHex), NetworkType.MIJIN));

          // Assert:
          expect(result.toUpperCase(), equals(expectedAddress.toUpperCase()));
        }
      });

      test('Catapult test vector [MIJIN_TEST] -  Public key to Address', () {
        // Arrange:
        const Public_Keys = [
          '2E834140FD66CF87B254A693A2C7862C819217B676D3943267156625E816EC6F',
          '4875FD2E32875D1BC6567745F1509F0F890A1BF8EE59FA74452FA4183A270E03',
          '9F780097FB6A1F287ED2736A597B8EA7F08D20F1ECDB9935DE6694ECF1C58900',
          '0815926E003CDD5AF0113C0E067262307A42CD1E697F53B683F7E5F9F57D72C9',
          '3683B3E45E76870CFE076E47C2B34CE8E3EAEC26C8AA7C1ED752E3E840AF8A27',
        ];

        const Addresses = [
          'SATNE7Q5BITMUTRRN6IB4I7FLSDRDWZA34I2PMUQ',
          'SDR6EW2WBHJQDYMNGFX2UBZHMMZC5PGL2Z5UYY4U',
          'SCOXVZMAZJTT4I3F7EAZYGNGR77D6WPTRFENHXSH',
          'SDZ4373ASEGJ7S7GQTKF26TIIMC7HK5EWH6N46CD',
          'SDI5I7Z3BRBAAHTZHGONGOXX742CW4W5QDVZG2PO',
        ];

        // Sanity:
        expect(Public_Keys.length, equals(Addresses.length));

        for (int i = 0; i < Public_Keys.length; ++i) {
          // Arrange:
          var publicKeyHex = Public_Keys[i];
          var expectedAddress = Addresses[i];

          // Act:
          var result = RawAddress.addressToString(RawAddress.publicKeyToAddress(
              HexUtils.getBytes(publicKeyHex), NetworkType.MIJIN_TEST));

          // Assert:
          expect(result.toUpperCase(), equals(expectedAddress.toUpperCase()));
        }
      });
    });
  });
}

void assertCannotCreateAddress(final String encodedAddress, final String message) {
  expect(() => RawAddress.stringToAddress(encodedAddress),
      throwsA(predicate((e) => e is ArgumentError && e.message.contains(message))));
}
