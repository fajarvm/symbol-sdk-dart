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

library nem2_sdk_dart.test.sdk.model.common.uint64_test;

import 'dart:typed_data' show Uint8List;

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:nem2_sdk_dart/core.dart' show ArrayUtils;
import 'package:nem2_sdk_dart/sdk.dart' show Uint64;
import 'package:test/test.dart';

void main() {
  final List<String> HEX_TEST_CASES = [
    '0000000000000000', // 0 = the min value of uint64
    '000000000000A1B2',
    '0000000012345678',
    '0000ABCD12345678',
    '1234567890ABCDEF',
    'FFFFFFFFFFFFFFFF', // 18446744073709551615 = the max value of uint64
    '84B3552D375FFA4B', // 9562080086528621131 = NEM namespaceId in Uint64
    'D525AD41D95FCF29', // 15358872602548358953 = XEM mosaicId in Uint64
  ];

  group('Uint64', () {
    test('Valid constants', () {
      expect(Uint64.MIN_VALUE_SIGNED, 0);
    });

    test('Can create Uint64 with a value within the accpeted value range', () {
      // min value is 0
      Uint64 actual = Uint64();
      expect(actual.value >= Uint64.MIN_VALUE, isTrue);
      expect(actual.hashCode, isNotNull);

      // max value is 18446744073709551615
      final BigInt first = BigInt.from(Uint64.MAX_VALUE_SIGNED);
      final BigInt second = BigInt.from(Uint64.MAX_VALUE_SIGNED - 1); // exceeds min value
      actual = Uint64.fromBigInt(first + second);
      expect(actual.value < Uint64.MAX_VALUE, isTrue);
    });

    test('Cannot create Uint64 with a value outside the accepted value range', () {
      // cannot create with value below 0
      expect(() => Uint64(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'Value must be above 0')));

      // max value is 18446744073709551615
      final BigInt first = BigInt.from(Uint64.MAX_VALUE_SIGNED);
      final BigInt second = BigInt.from(Uint64.MAX_VALUE_SIGNED + 1); // exceeds max value
      expect(() => Uint64.fromBigInt(first + second),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'Value out of range')));
    });

    test('Can create from int', () {
      final result1 = Uint64(0);
      final result2 = Uint64(100);
      final result3 = Uint64(0xFFFF0000);
      final result4 = Uint64(8263018230);

      expect(result1.value.toInt(), equals(0));
      expect(result2.value.toInt(), equals(100));
      expect(result3.value.toInt(), equals(4294901760));
      expect(result4.value.toInt(), equals(8263018230));
    });

    test('Can create from BigInt', () {
      for (var hexString in HEX_TEST_CASES) {
        final BigInt bigInt = BigInt.parse(hexString, radix: 16);
        final actual = Uint64.fromBigInt(bigInt);

        expect(actual.value, equals(bigInt));
        expect(actual.toHex(), equals(hexString.toLowerCase()));
      }
    });

    test('Can create from bytes', () {
      for (var hexString in HEX_TEST_CASES) {
        final Int64 int64 = Int64.parseHex(hexString);
        final Uint8List bytes = Uint8List.fromList(int64.toBytes());
        final actual = Uint64.fromBytes(bytes);

        expect(actual.toHex(), equals(hexString.toLowerCase()));
      }
    });

    test('Can create from hex string', () {
      for (var hexString in HEX_TEST_CASES) {
        final actual = Uint64.fromHex(hexString);

        expect(actual.toHex(), equals(hexString.toLowerCase()));
      }
    });

    test('Can create from a pair of 32-bit integers', () {
      // zero ( min value)
      Uint64 actual = Uint64.fromInts(0, 0);
      expect(actual.value, equals(Uint64.MIN_VALUE));
      expect(actual.value, equals(BigInt.zero));

      // one
      actual = Uint64.fromInts(1, 0);
      expect(actual.value, equals(BigInt.one));
      actual = Uint64(1, 0);
      expect(actual.value, equals(BigInt.one));

      // one hundred
      actual = Uint64.fromInts(100, 0);
      expect(actual.value, equals(BigInt.from(100)));
      actual = Uint64(100, 0);
      expect(actual.value, equals(BigInt.from(100)));

      // one thousand
      actual = Uint64.fromInts(1000, 0);
      expect(actual.value, equals(BigInt.from(1000)));
      actual = Uint64(1000, 0);
      expect(actual.value, equals(BigInt.from(1000)));

      // ten thousand
      actual = Uint64.fromInts(10000, 0);
      expect(actual.value, equals(BigInt.from(10000)));
      actual = Uint64(10000, 0);
      expect(actual.value, equals(BigInt.from(10000)));

      actual = Uint64.fromInts(12345, 99999);
      expect(actual.value, equals(BigInt.parse('429492434645049')));
      actual = Uint64(12345, 99999);
      expect(actual.value, equals(BigInt.parse('429492434645049')));

      actual = Uint64.fromInts(1111, 2222);
      expect(actual.value, equals(BigInt.parse('9543417332823')));
      actual = Uint64(1111, 2222);
      expect(actual.value, equals(BigInt.parse('9543417332823')));

      // max value
      actual = Uint64.fromInts(0xFFFFFFFF, 0xFFFFFFFF);
      expect(actual.value, equals(Uint64.MAX_VALUE));
      actual = Uint64(0xFFFFFFFF, 0xFFFFFFFF);
      expect(actual.value, equals(Uint64.MAX_VALUE));
    });

    test('compareTo()', () {
      final zero = Uint64.fromBigInt(BigInt.zero);
      final one = Uint64.fromBigInt(BigInt.one);
      final two = Uint64.fromBigInt(BigInt.two);

      expect(zero.compareTo(one), equals(-1));
      expect(one.compareTo(one), equals(0));
      expect(two.compareTo(one), equals(1));
    });

    test('isZero()', () {
      final zero = Uint64.fromBigInt(BigInt.zero);
      final one = Uint64.fromBigInt(BigInt.one);

      expect(zero.isZero(), isTrue);
      expect(one.isZero(), isFalse);
    });

    test('toString()', () {
      const hexString = '000000000000A1B2';
      final Int64 int64 = Int64.parseHex(hexString);
      final Uint8List bytes = Uint8List.fromList(int64.toBytes());
      final result1 = Uint64.fromBytes(bytes);
      final result2 = Uint64.fromHex(hexString);
      final result3 = Uint64.fromBigInt(BigInt.zero);

      expect(result1.toString(), equals('41394'));
      expect(result2.toString(), equals('41394'));
      expect(result3.toString(), equals('0'));
    });

    test('toBytes()', () {
      const hexString = '000000000000A1B2';
      final Int64 int64 = Int64.parseHex(hexString);
      final Uint8List expected = Uint8List.fromList(int64.toBytes());
      final uint64 = Uint64.fromHex(hexString);
      final Uint8List actual = uint64.toBytes();

      expect(actual, equals(expected));
      expect(ArrayUtils.deepEqual(actual, expected), isTrue);
    });

    test('toHex()', () {
      const hexString = '000000000000A1B2';
      final actual = Uint64.fromHex(hexString);

      expect(actual.toHex(), equals(hexString.toLowerCase()));
    });

    test('toIntArray()', () {
      // min value
      Uint64 actual = Uint64.fromBigInt(BigInt.zero);
      expect(actual.toIntArray(), equals([0, 0]));

      actual = Uint64.fromInts(0, 0);
      expect(actual.toIntArray(), equals([0, 0]));

      actual = Uint64.fromBigInt(BigInt.one);
      expect(actual.toIntArray(), equals([1, 0]));

      actual = Uint64.fromInts(1, 0);
      expect(actual.toIntArray(), equals([1, 0]));

      actual = Uint64(1, 0);
      expect(actual.toIntArray(), equals([1, 0]));

      actual = Uint64.fromBigInt(BigInt.parse('429492434645049'));
      expect(actual.toIntArray(), equals([12345, 99999]));

      actual = Uint64.fromBigInt(BigInt.parse('9543417332823'));
      expect(actual.toIntArray(), equals([1111, 2222]));

      // max value
      actual = Uint64.fromBigInt(BigInt.parse('FFFFFFFFFFFFFFFF', radix: 16));
      expect(actual.toIntArray(), equals([0xFFFFFFFF, 0xFFFFFFFF]));
    });

    group('Operation', () {
      test('Equals', () {
        for (var hexString in HEX_TEST_CASES) {
          final actual = Uint64.fromHex(hexString);

          final BigInt bigInt = BigInt.parse(hexString, radix: 16);
          final expected = Uint64.fromBigInt(bigInt);
          expect(actual == expected, isTrue);
        }
      });

      test('Addition', () {
        // zero values
        Uint64 value = Uint64(0);
        Uint64 other = Uint64(0);
        Uint64 result = value + other;

        expect(result, equals(Uint64(0)));
        expect(result.value.toInt(), equals(0));

        // non-zero values
        value = Uint64(100);
        other = Uint64(1);
        result = value + other;

        expect(result, equals(Uint64(101)));
        expect(result.value.toInt(), equals(101));

        // greater than max value
        expect(() => (Uint64.fromBigInt(Uint64.MAX_VALUE) + Uint64(1)),
            throwsA(predicate((e) => e is ArgumentError && e.message == 'Value out of range')));
      });

      test('Subtraction', () {
        // zero values
        Uint64 value = Uint64(0);
        Uint64 other = Uint64(0);
        Uint64 result = value - other;

        expect(result, equals(Uint64(0)));
        expect(result.value.toInt(), equals(0));

        // non-zero values
        value = Uint64(100);
        other = Uint64(1);
        result = value - other;

        expect(result, equals(Uint64(99)));
        expect(result.value.toInt(), equals(99));

        // negative value
        expect(() => (other - value),
            throwsA(predicate((e) => e is ArgumentError && e.message == 'Value out of range')));
      });
    });

    group('Compact', () {
      test('can compact 32-bit value', () {
        final result = Uint64(0x12345678, 0x00000000).compact;
        expect(result, equals(0x12345678));
      });

      test('can compact less than max safe integer', () {
        final result = Uint64(0x00ABCDEF, 0x000FDFFF).compact;
        expect(result, equals(0xFDFFF00ABCDEF));
      });
    });
  });
}
