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

library nem2_sdk_dart.test.core.crypto.raw_address_test;

import 'package:nem2_sdk_dart/nem2_sdk_dart.dart' show NetworkType;

import 'package:nem2_sdk_dart/core.dart' show ArrayUtils, HexUtils, RawAddress;
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

      test('can create address from public key using NIS1 signature schema', () {
        const nonKeccakHex = '9823bb7c3c089d996585466380edbdc19d495918484bf7e997';
        const keccakHex = '981a00208cddcc647bf1e065e93824faa732aab187cc1a9b02';
        const publicKey = '3485d98efd7eb07adafcfd1a157d89de2796a95e780813c0258af3f5f84ed8cb';
        final publicKeyByte = HexUtils.getBytes(publicKey);

        final decoded = RawAddress.publicKeyToAddress(publicKeyByte, NetworkType.TEST_NET);

        expect(decoded[0], equals(NetworkType.TEST_NET.value));
        expect(HexUtils.getString(decoded) == keccakHex, isTrue);
        expect(HexUtils.getString(decoded) == nonKeccakHex, isFalse);
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
      // Test vectors: https://raw.githubusercontent.com/nemtech/test-vectors/master/1.test-address-nis1.json
      test('NIS1 test vector [PublicNet] - NIS public Key to Address', () {
        // Arrange:
        const Public_Keys = [
          'c5f54ba980fcbb657dbaaa42700539b207873e134d2375efeab5f1ab52f87844',
          '96eb2a145211b1b7ab5f0d4b14f8abc8d695c7aee31a3cfc2d4881313c68eea3',
          '2d8425e4ca2d8926346c7a7ca39826acd881a8639e81bd68820409c6e30d142a',
          '4feed486777ed38e44c489c7c4e93a830e4c4a907fa19a174e630ef0f6ed0409',
          '83ee32e4e145024d29bca54f71fa335a98b3e68283f1a3099c4d4ae113b53e54',
        ];

        const Addresses = [
          'NDD2CT6LQLIYQ56KIXI3ENTM6EK3D44P5JFXJ4R4',
          'NABHFGE5ORQD3LE4O6B7JUFN47ECOFBFASC3SCAC',
          'NAVOZX4HDVOAR4W6K4WJHWPD3MOFU27DFHC7KZOZ',
          'NBZ6JK5YOCU6UPSSZ5D3G27UHAPHTY5HDQMGE6TT',
          'NCQW2P5DNZ5BBXQVGS367DQ4AHC3RXOEVGRCLY6V',
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
      test('NIS1 test vector [PublicTest] - NIS public Key to Address', () {
        // Arrange:
        const Public_Keys = [
          'c5f54ba980fcbb657dbaaa42700539b207873e134d2375efeab5f1ab52f87844',
          '96eb2a145211b1b7ab5f0d4b14f8abc8d695c7aee31a3cfc2d4881313c68eea3',
          '2d8425e4ca2d8926346c7a7ca39826acd881a8639e81bd68820409c6e30d142a',
          '4feed486777ed38e44c489c7c4e93a830e4c4a907fa19a174e630ef0f6ed0409',
          '83ee32e4e145024d29bca54f71fa335a98b3e68283f1a3099c4d4ae113b53e54',
        ];

        const Addresses = [
          'TDD2CT6LQLIYQ56KIXI3ENTM6EK3D44P5KZPFMK2',
          'TABHFGE5ORQD3LE4O6B7JUFN47ECOFBFATE53N2I',
          'TAVOZX4HDVOAR4W6K4WJHWPD3MOFU27DFEJDR2PR',
          'TBZ6JK5YOCU6UPSSZ5D3G27UHAPHTY5HDQCDS5YA',
          'TCQW2P5DNZ5BBXQVGS367DQ4AHC3RXOEVFZOQCJ6',
        ];

        // Sanity:
        expect(Public_Keys.length, equals(Addresses.length));

        for (int i = 0; i < Public_Keys.length; ++i) {
          // Arrange:
          var publicKeyHex = Public_Keys[i];
          var expectedAddress = Addresses[i];

          // Act:
          var result = RawAddress.addressToString(
              RawAddress.publicKeyToAddress(HexUtils.getBytes(publicKeyHex), NetworkType.TEST_NET));

          // Assert:
          expect(result.toUpperCase(), equals(expectedAddress.toUpperCase()));
        }
      });

      // Test vectors: https://raw.githubusercontent.com/nemtech/test-vectors/master/1.test-address-catapult.json
      test('Catapult test vector [PublicNet] - Catapult public Key to Address', () {
        // Arrange:
        const Public_Keys = [
          'BD8D3F8B7E1B3839C650F458234AB1FF87CDB1EDA36338D9E446E27D454717F2',
          '26821636A618FD524A3AB57276EFC36CAF787DF19EE00F60035CE376A18E8C47',
          'DFC7F40FC549AC8BB2EF097600103FF457A1D7DC5755D434474761459B030E6F',
          '96C7AB358EBB91104322C56435642BD939A77432286B229372987FC366EA319F',
          '9488CFB5D7D439213B11FA80C1B57E8A7AB7E41B64CBA18A89180D412C04915C',
        ];

        const Addresses = [
          'MDIPRQMB3HT7A6ZKV7HOHJQM7JHX6H3FN5YHHZMD',
          'MC65QJI4OWTUFJNQ2IDVOMUTE7IDI2EGEEZ6ADFH',
          'MCBC4VAQBVSB4J5J2PTFM7OUY5CYDL33VUHV7FNU',
          'MBLW3CQPBGPCFAXG4XM5GDEVLPESCPDPFN4NBABW',
          'MA5RDU36TKBTW4KVSSPD7PT5YTUMD7OIJEMAYYMV',
        ];

        // Sanity:
        expect(Public_Keys.length, equals(Addresses.length));

        for (int i = 0; i < Public_Keys.length; ++i) {
          // Arrange:
          var publicKeyHex = Public_Keys[i];
          var expectedAddress = Addresses[i];

          // Act:
          var result = RawAddress.addressToString(
              RawAddress.publicKeyToAddress(HexUtils.getBytes(publicKeyHex), NetworkType.MIJIN));

          // Assert:
          expect(result.toUpperCase(), equals(expectedAddress.toUpperCase()));
        }
      });
      test('Catapult test vector [PublicTest] - Catapult public Key to Address', () {
        // Arrange:
        const Public_Keys = [
          'BD8D3F8B7E1B3839C650F458234AB1FF87CDB1EDA36338D9E446E27D454717F2',
          '26821636A618FD524A3AB57276EFC36CAF787DF19EE00F60035CE376A18E8C47',
          'DFC7F40FC549AC8BB2EF097600103FF457A1D7DC5755D434474761459B030E6F',
          '96C7AB358EBB91104322C56435642BD939A77432286B229372987FC366EA319F',
          '9488CFB5D7D439213B11FA80C1B57E8A7AB7E41B64CBA18A89180D412C04915C',
        ];

        const Addresses = [
          'SDIPRQMB3HT7A6ZKV7HOHJQM7JHX6H3FN5EIRD3D',
          'SC65QJI4OWTUFJNQ2IDVOMUTE7IDI2EGEGTDOMI3',
          'SCBC4VAQBVSB4J5J2PTFM7OUY5CYDL33VVLQRCX6',
          'SBLW3CQPBGPCFAXG4XM5GDEVLPESCPDPFNJYN46J',
          'SA5RDU36TKBTW4KVSSPD7PT5YTUMD7OIJGV24AZM',
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
