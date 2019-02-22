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

library nem2_sdk_dart.test.core.utils.base32_test;

import 'dart:typed_data' show Uint8List;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show Base32, HexUtils;

void main() {
  const List<String> test_encoded = [
    'NC5J5DI2URIC4H3T3IMXQS25PWQWZIPEV6EV7LAS',
    'NC5J5DI2URIC4H3T3IMXQS25PWQWZIPEV6EV7LAS',
    'NC5J5DI2URIC4H3T3IMXQS25PWQWZIPEV6EV7LAS',
    'NC5J5DI2URIC4H3T3IMXQS25PWQWZIPEV6EV7LAS',
    'NC5J5DI2URIC4H3T3IMXQS25PWQWZIPEV6EV7LAS',
  ];

  const List<String> test_decoded = [
    '68BA9E8D1AA4502E1F73DA19784B5D7DA16CA1E4AF895FAC12',
    '68BA9E8D1AA4502E1F73DA19784B5D7DA16CA1E4AF895FAC12',
    '68BA9E8D1AA4502E1F73DA19784B5D7DA16CA1E4AF895FAC12',
    '68BA9E8D1AA4502E1F73DA19784B5D7DA16CA1E4AF895FAC12',
    '68BA9E8D1AA4502E1F73DA19784B5D7DA16CA1E4AF895FAC12'
  ];

  group('encode', () {
    test('can convert empty input', () {
      final actual = Base32.encode([]);

      expect(actual, equals(''));
    });

    test('can convert test vectors', () {
      for (int i = 0; i < test_decoded.length; i++) {
        final Uint8List input = HexUtils.getBytes(test_decoded[i]);
        final String encodedString = Base32.encode(input);

        expect(encodedString, equals(test_encoded[i]));
      }
    });

    test('accepts all byte values', () {
      final List<int> data = [];
      for (int i = 0; 260 > i; ++i) {
        data.add(i & 0xFF);
      }

      final String encodedString = Base32.encode(data);

      const String expected = ''
          'AAAQEAYEAUDAOCAJBIFQYDIOB4IBCEQTCQKRMFYY'
          'DENBWHA5DYPSAIJCEMSCKJRHFAUSUKZMFUXC6MBR'
          'GIZTINJWG44DSOR3HQ6T4P2AIFBEGRCFIZDUQSKK'
          'JNGE2TSPKBIVEU2UKVLFOWCZLJNVYXK6L5QGCYTD'
          'MRSWMZ3INFVGW3DNNZXXA4LSON2HK5TXPB4XU634'
          'PV7H7AEBQKBYJBMGQ6EITCULRSGY5D4QSGJJHFEV'
          'S2LZRGM2TOOJ3HU7UCQ2FI5EUWTKPKFJVKV2ZLNO'
          'V6YLDMVTWS23NN5YXG5LXPF5X274BQOCYPCMLRWH'
          'ZDE4VS6MZXHM7UGR2LJ5JVOW27MNTWW33TO55X7A'
          '4HROHZHF43T6R2PK5PWO33XP6DY7F47U6X3PP6HZ'
          '7L57Z7P674AACAQD';

      expect(encodedString, equals(expected));
    });

    test('throws if input size is not a multiple of block size', () {
      for (int i = 2; 10 > i; i += 2) {
        final List<int> input = new List<int>(i);

        expect(
            () => Base32.encode(input),
            throwsA(predicate((e) =>
                e is ArgumentError &&
                e.message == 'Decoded size must be multiple of ${Base32.DECODED_BLOCK_SIZE}')));
      }
    });
  });

  group('encode', () {
    test('can convert empty input', () {
      final Uint8List decoded = Base32.decode('');

      expect(HexUtils.getString(decoded), equals(''));
    });

    test('can convert test vectors', () {
      for (int i = 0; i < test_encoded.length; i++) {
        final Uint8List decoded = Base32.decode(test_encoded[i]);

        expect(HexUtils.getString(decoded), equals(test_decoded[i].toLowerCase()));
      }
    });

    test('accepts all vald characters', () {
      final Uint8List decoded = Base32.decode('ABCDEFGHIJKLMNOPQRSTUVWXYZ234567');

      expect(HexUtils.getString(decoded),
          equals('00443214C74254B635CF84653A56D7C675BE77DF'.toLowerCase()));
    });

    test('throws if input size is not a multiple of block size', () {
      for (int i = 1; 8 > i; ++i) {
        final String input = new List<String>.filled(i, 'A').join();

        expect(
            () => Base32.decode(input),
            throwsA(predicate((e) =>
                e is ArgumentError &&
                e.message == 'Encoded size must be multiple of ${Base32.ENCODED_BLOCK_SIZE}')));
      }
    });

    test('throws if input contains an invalid character', () {
      const List<String> illegalInputs = [
        'NC5J5DI2URIC4H3T3IMXQS21PWQWZIPEV6EV7LAS', // contains char '1'
        'NBGCMBPFWNTLXFF4GB2V5SPV!V2OQD6JFA6SBYUD', // contains char '!'
        'NDL3BGQUX2T44BQOOHAPVGWJWQRG3YLHAE)6CCZ5' // contains char ')'
      ];

      for (var input in illegalInputs) {
        expect(
            () => Base32.decode(input),
            throwsA(predicate((e) =>
                e is ArgumentError && e.message.toString().contains('illegal base32 character'))));
      }
    });
  });

  group('roundtrip', () {
    test('decode -> encode', () {
      const List<String> inputs = [
        'BDS73DQ5NC33MKYI3K6GXLJ53C2HJ35A',
        '46FNYP7T4DD3SWAO6C4NX62FJI5CBA26'
      ];

      for (var input in inputs) {
        final Uint8List decoded = Base32.decode(input);
        final String result = Base32.encode(decoded);

        expect(result, equals(input));
      }
    });

    test('encode -> decode', () {
      const List<String> inputs = [
        '8A4E7DF5B61CC0F97ED572A95F6ACA',
        '2D96E4ABB65F0AD3C29FEA48C132CE'
      ];

      for (var input in inputs) {
        final String encoded = Base32.encode(HexUtils.getBytes(input));
        final Uint8List result = Base32.decode(encoded);

        expect(HexUtils.getString(result), equals(input.toLowerCase()));
      }
    });
  });
}
