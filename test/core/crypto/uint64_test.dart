library nem2_sdk_dart.test.core.crypto.uint64_test;

import 'dart:typed_data' show Uint8List;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show ArrayUtils, Uint64, HexUtils;

main() {
  final List<String> HEX_TEST_CASES = [
    '0000000000000000', // 0 = the min value of uint64
    '000000000000A1B2',
    '0000000012345678',
    '0000ABCD12345678',
    '1234567890ABCDEF',
    'FFFFFFFFFFFFFFFF' // 18446744073709551615 = the max value of uint64
  ];

  group('Uint64', () {
    test('Can create Uint64 with a value within the accpeted value range', () {
      // min value is 0
      Uint64 actual = new Uint64();
      expect(actual.value >= Uint64.MIN_VALUE, equals(true));

      // max value is 18446744073709551615
      BigInt first = BigInt.from(Uint64.MAX_VALUE_SIGNED);
      BigInt second = BigInt.from(Uint64.MAX_VALUE_SIGNED - 1); // exceeds min value
      actual = Uint64.fromBigInt(first + second);
      expect(actual.value < Uint64.MAX_VALUE, equals(true));
    });

    test('Cannot create Uint64 with a value outside the accepted value range', () {
      // cannot create with value below 0
      expect(() => new Uint64(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'Value must be above 0')));

      // max value is 18446744073709551615
      BigInt first = BigInt.from(Uint64.MAX_VALUE_SIGNED);
      BigInt second = BigInt.from(Uint64.MAX_VALUE_SIGNED + 1); // exceeds max value
      expect(() => Uint64.fromBigInt(first + second),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'Value out of range')));
    });

    test('Can create from int', () {
      final Uint64 result1 = new Uint64(0);
      final Uint64 result2 = new Uint64(100);
      final Uint64 result3 = new Uint64(0xFFFF0000);
      final Uint64 result4 = new Uint64(8263018230);

      expect(result1.value.toInt(), equals(0));
      expect(result2.value.toInt(), equals(100));
      expect(result3.value.toInt(), equals(4294901760));
      expect(result4.value.toInt(), equals(8263018230));
    });

    test('Can create from BigInt', () {
      for (var hexString in HEX_TEST_CASES) {
        final BigInt bigInt = BigInt.parse(hexString, radix: 16);
        final Uint64 actual = Uint64.fromBigInt(bigInt);

        expect(actual.value, equals(bigInt));
        expect(actual.toHexString(), equals(hexString.toLowerCase()));
      }
    });

    test('Can create from bytes', () {
      for (var hexString in HEX_TEST_CASES) {
        final Uint8List bytes = HexUtils.getBytes(hexString);
        final Uint64 actual = Uint64.fromBytes(bytes);

        expect(actual.toHexString(), equals(hexString.toLowerCase()));
      }
    });

    test('Can create from hex string', () {
      for (var hexString in HEX_TEST_CASES) {
        final Uint64 actual = Uint64.fromHex(hexString);

        expect(actual.toHexString(), equals(hexString.toLowerCase()));
      }
    });

    test('Equals', () {
      for (var hexString in HEX_TEST_CASES) {
        final Uint64 actual = Uint64.fromHex(hexString);

        final BigInt bigInt = BigInt.parse(hexString, radix: 16);
        final Uint64 expected = Uint64.fromBigInt(bigInt);
        expect(actual == expected, equals(true));
      }
    });

    test('compareTo', () {
      final Uint64 zero = Uint64.fromBigInt(BigInt.zero);
      final Uint64 one = Uint64.fromBigInt(BigInt.one);
      final Uint64 two = Uint64.fromBigInt(BigInt.two);

      expect(zero.compareTo(one), equals(-1));
      expect(one.compareTo(one), equals(0));
      expect(two.compareTo(one), equals(1));
    });

    test('isZero', () {
      final Uint64 zero = Uint64.fromBigInt(BigInt.zero);
      final Uint64 one = Uint64.fromBigInt(BigInt.one);

      expect(zero.isZero(), equals(true));
      expect(one.isZero(), equals(false));
    });

    test('toString', () {
      final String hexString = '000000000000A1B2';
      final Uint8List bytes = HexUtils.getBytes(hexString);
      final Uint64 result1 = Uint64.fromBytes(bytes);
      final Uint64 result2 = Uint64.fromHex(hexString);
      final Uint64 result3 = Uint64.fromBigInt(BigInt.zero);

      expect(result1.toString(), equals('41394'));
      expect(result2.toString(), equals('41394'));
      expect(result3.toString(), equals('0'));
    });

    test('toBytes', () {
      final String hexString = '000000000000A1B2';
      final Uint8List expected = HexUtils.getBytes(hexString);
      final Uint64 uint64 = Uint64.fromHex(hexString);
      final Uint8List actual = uint64.toBytes();

      expect(actual, equals(expected));
      expect(ArrayUtils.deepEqual(actual, expected), equals(true));
    });
  });
}
