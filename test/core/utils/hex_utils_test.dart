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

library nem2_sdk_dart.test.core.utils.hex_utils_test;

import 'dart:typed_data' show Uint8List;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show HexUtils;

void main() {
  group('getBytes()', () {
    test('can convert valid string to byte array', () {
      final List<int> actual = HexUtils.getBytes('4e454d465457');
      final Uint8List expectedOutput = Uint8List.fromList([0x4e, 0x45, 0x4d, 0x46, 0x54, 0x57]);
      expect(actual, equals(expectedOutput));
    });

    test('can convert valid string with odd length to byte array', () {
      final List<int> actual = HexUtils.getBytes('e454d465457');
      final Uint8List expectedOutput = Uint8List.fromList([0x0e, 0x45, 0x4d, 0x46, 0x54, 0x57]);
      expect(actual, equals(expectedOutput));
    });

    test('can convert valid string with leading zeros to byte array', () {
      final List<int> actual = HexUtils.getBytes('00000d465457');
      final Uint8List expectedOutput = Uint8List.fromList([0x00, 0x00, 0x0d, 0x46, 0x54, 0x57]);
      expect(actual, equals(expectedOutput));
    });

    test('cannot convert invalid hex string', () {
      expect(() => HexUtils.getBytes('1z1z'), throwsArgumentError);
    });
  });

  group('tryGetBytes()', () {
    test('can convert valid string to byte array', () {
      final List<int> actual = HexUtils.tryGetBytes('4e454d465457');
      final Uint8List expectedOutput = Uint8List.fromList([0x4e, 0x45, 0x4d, 0x46, 0x54, 0x57]);
      expect(actual, equals(expectedOutput));
    });

    test('can convert valid string with odd length to byte array', () {
      final List<int> actual = HexUtils.tryGetBytes('e454d465457');
      final Uint8List expectedOutput = Uint8List.fromList([0x0e, 0x45, 0x4d, 0x46, 0x54, 0x57]);
      expect(actual, equals(expectedOutput));
    });

    test('can convert valid string with leading zeros to byte array', () {
      final List<int> actual = HexUtils.tryGetBytes('00000d465457');
      final Uint8List expectedOutput = Uint8List.fromList([0x00, 0x00, 0x0d, 0x46, 0x54, 0x57]);
      expect(actual, equals(expectedOutput));
    });

    test('cannot convert malformed string to byte array', () {
      final List<int> actual = HexUtils.tryGetBytes('4e454g465457');
      expect(actual, equals(null));
    });
  });

  group('getString()', () {
    test('can convert bytes to string', () {
      final actual = HexUtils.getString([0x4e, 0x45, 0x4d, 0x46, 0x54, 0x57]);
      const expectedOutput = '4e454d465457';
      expect(actual, equals(expectedOutput));
    });

    test('can convert bytes with leading zeros to string', () {
      final actual = HexUtils.getString([0x00, 0x00, 0x0d, 0x46, 0x54, 0x57]);
      const expectedOutput = '00000d465457';
      expect(actual, equals(expectedOutput));
    });
  });

  group('isHexString()', () {
    test('valid hex strings', () {
      final List<String> INPUTS = ['', '026ee415fc15', 'abcdef0123456789ABCDEF'];

      for (var input in INPUTS) {
        expect(HexUtils.isHex(input), isTrue);
      }
    });

    test('invalid hex strings', () {
      final List<String> INPUTS = [
        'abcdef012345G789ABCDEF', // invalid ('G') char
        'abcdef0123456789ABCDE' // invalid (odd) length
      ];

      for (var input in INPUTS) {
        expect(HexUtils.isHex(input), isFalse);
      }
    });
  });

  group('utf8ToHex()', () {
    test('can convert UTF8 text to Hex', () {
      final actual = HexUtils.utf8ToHex('test words |@#¢∞¬÷“”≠[]}{–');
      const expected =
          '7465737420776f726473207c4023c2a2e2889ec2acc3b7e2809ce2809de289a05b5d7d7be28093';

      expect(actual, equals(expected));
    });

    test('can convert UTF8 text with foreign characters to Hex', () {
      final actual = HexUtils.utf8ToHex('先秦兩漢');
      const expected = 'e58588e7a7a6e585a9e6bca2';

      expect(actual, equals(expected));
    });
  });

  group('tryHexToUtf8()', () {
    test('can convert hex to UTF8', () {
      final actual = HexUtils.tryHexToUtf8(
          '7465737420776f726473207c4023c2a2e2889ec2acc3b7e2809ce2809de289a05b5d7d7be28093');
      const expected = 'test words |@#¢∞¬÷“”≠[]}{–';

      expect(actual, equals(expected));
    });

    test('can convert hex to UTF8 text with foreign characters', () {
      final actual = HexUtils.tryHexToUtf8('e58588e7a7a6e585a9e6bca2');
      const expected = '先秦兩漢';

      expect(actual, equals(expected));
    });

    test('invalid UTF8 input will return a string parsed from the char codes instead', () {
      final actual = HexUtils.tryHexToUtf8('1234');
      expect(actual, equals('\x124'));
    });
  });

  group('bytesToHex()', () {
    test('can convert byte array to hex', () {
      final List<String> INPUTS = ['', '026ee415fc15', 'abcdef0123456789ABCDEF'];

      for (var hexString in INPUTS) {
        final bytes = HexUtils.getBytes(hexString);
        final actual = HexUtils.bytesToHex(bytes);

        expect(actual, equals(hexString.toLowerCase()));
      }
    });
  });

  group('reverseHexString()', (){
    test('Can reverse input hex string and bytes', () {
      String input = '575dbb3062267eff57c970a336ebbc8fbcfe12c5bd3ed7bc11eb0481d7704ced';
      String output = 'ed4c70d78104eb11bcd73ebdc512febc8fbceb36a370c957ff7e266230bb5d57';
      expect(HexUtils.reverseHexString(input), equals(output));
    });

    test('Should throw an exception when reversing an invalid hex string', () {
      expect(
              () => HexUtils.reverseHexString('NOHEX'),
          throwsA(predicate(
                  (e) => e is ArgumentError && e.message.contains('Failed reversing the input.'))));
    });
  });
}
