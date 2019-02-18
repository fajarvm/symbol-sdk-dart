library nem2_sdk_dart.test.core.utils.hex_utils_test;

import 'dart:typed_data' show Uint8List;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/src/core/utils.dart' show HexUtils;

main() {
  group('getBytes()', () {
    test('getBytes() can convert valid string to byte array', () {
      final List<int> actual = HexUtils.getBytes('4e454d465457');
      final Uint8List expectedOutput = Uint8List.fromList([0x4e, 0x45, 0x4d, 0x46, 0x54, 0x57]);
      expect(actual, equals(expectedOutput));
    });

    test('getBytes() can convert valid string with odd length to byte array', () {
      final List<int> actual = HexUtils.getBytes('e454d465457');
      final Uint8List expectedOutput = Uint8List.fromList([0x0e, 0x45, 0x4d, 0x46, 0x54, 0x57]);
      expect(actual, equals(expectedOutput));
    });

    test('getBytes() can convert valid string with leading zeros to byte array', () {
      final List<int> actual = HexUtils.getBytes('00000d465457');
      final Uint8List expectedOutput = Uint8List.fromList([0x00, 0x00, 0x0d, 0x46, 0x54, 0x57]);
      expect(actual, equals(expectedOutput));
    });
  });

  group('tryGetBytes()', () {
    test('tryGetBytes() can convert valid string to byte array', () {
      final List<int> actual = HexUtils.tryGetBytes('4e454d465457');
      final Uint8List expectedOutput = Uint8List.fromList([0x4e, 0x45, 0x4d, 0x46, 0x54, 0x57]);
      expect(actual, equals(expectedOutput));
    });

    test('tryGetBytes() can convert valid string with odd length to byte array', () {
      final List<int> actual = HexUtils.tryGetBytes('e454d465457');
      final Uint8List expectedOutput = Uint8List.fromList([0x0e, 0x45, 0x4d, 0x46, 0x54, 0x57]);
      expect(actual, equals(expectedOutput));
    });

    test('tryGetBytes() can convert valid string with leading zeros to byte array', () {
      final List<int> actual = HexUtils.tryGetBytes('00000d465457');
      final Uint8List expectedOutput = Uint8List.fromList([0x00, 0x00, 0x0d, 0x46, 0x54, 0x57]);
      expect(actual, equals(expectedOutput));
    });

    test('tryGetBytes() cannot convert malformed string to byte array', () {
      final List<int> actual = HexUtils.tryGetBytes('4e454g465457');
      expect(actual, equals(null));
    });
  });

  group('getString()', () {
    test('getString() can convert bytes to string', () {
      final String actual = HexUtils.getString([0x4e, 0x45, 0x4d, 0x46, 0x54, 0x57]);
      final String expectedOutput = '4e454d465457';
      expect(actual, equals(expectedOutput));
    });

    test('getString() can convert bytes with leading zeros to string', () {
      final String actual = HexUtils.getString([0x00, 0x00, 0x0d, 0x46, 0x54, 0x57]);
      final String expectedOutput = '00000d465457';
      expect(actual, equals(expectedOutput));
    });
  });

  group('isHexString()', () {
    test('valid hex strings', () {
      final List<String> INPUTS = ['', '026ee415fc15', 'abcdef0123456789ABCDEF'];

      for (var input in INPUTS) {
        expect(HexUtils.isHexString(input), equals(true));
      }
    });

    test('invalid hex strings', () {
      final List<String> INPUTS = [
        'abcdef012345G789ABCDEF', // invalid ('G') char
        'abcdef0123456789ABCDE' // invalid (odd) length
      ];

      for (var input in INPUTS) {
        expect(HexUtils.isHexString(input), equals(false));
      }
    });
  });

  group('UTF-8 to Hex', () {
    test('can convert UTF8 text to Hex', () {
      String actual = HexUtils.utf8ToHex('test words |@#¢∞¬÷“”≠[]}{–');
      String expected =
          '7465737420776f726473207c4023c2a2e2889ec2acc3b7e2809ce2809de289a05b5d7d7be28093';

      expect(actual, equals(expected));
    });

    test('can convert UTF8 text with foreign characters to Hex', () {
      String actual = HexUtils.utf8ToHex('先秦兩漢');
      String expected = 'e58588e7a7a6e585a9e6bca2';

      expect(actual, equals(expected));
    });
  });
}
