library nem2_sdk_dart.test.core.crypto.uint64_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show Uint64;

main() {
  group('Uint64', () {
    test('Cannot create Uint64 with a value within safe value range', () {
      // min value is 0
      Uint64 actual = Uint64();
      expect(actual.value >= Uint64.MIN_VALUE, equals(true));

      // max value is 18446744073709551615
      BigInt first = BigInt.from(Uint64.MAX_VALUE_SIGNED);
      BigInt second = BigInt.from(Uint64.MAX_VALUE_SIGNED - 1); // exceeds min value
      actual = Uint64.fromBigInt(first + second);
      expect(actual.value < Uint64.MAX_VALUE, equals(true));
    });

    test('Cannot create Uint64 with a value outside the safe value range', () {
      // cannot create with value below 0
      expect(() => Uint64(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'Value must be above 0')));

      // max value is 18446744073709551615
      BigInt first = BigInt.from(Uint64.MAX_VALUE_SIGNED);
      BigInt second = BigInt.from(Uint64.MAX_VALUE_SIGNED + 1); // exceeds max value
      expect(() => Uint64.fromBigInt(first + second),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'Value out of range')));
    });

    // TODO: complete with more test cases
  });
}
