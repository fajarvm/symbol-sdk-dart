library nem2_sdk_dart.test.core.crypto.ed25519.arithmetic.ed25519_field_test;

import "package:test/test.dart";
import "package:nem2_sdk_dart/src/core/crypto/ed25519/arithmetic/arithmetic.dart";
import "test_utils.dart";

main() {
  test("P is as expected", () {
    final BigInt P = (BigInt.one << 255) - BigInt.from(19);
    expect(Ed25519Field.P, equals(P));
  });

  test("Ed25519Field.ZERO is as expected", () {
    expect(BigInt.zero,
        equals(TestUtils.toBigIntFromFE(Ed25519Field.ZERO)));
  });

  test("Ed25519Field.ONE is as expected", () {
    expect(BigInt.one,
        equals(TestUtils.toBigIntFromFE(Ed25519Field.ONE)));
  });

  test("Ed25519Field.TWO is as expected", () {
    expect(BigInt.two,
        equals(TestUtils.toBigIntFromFE(Ed25519Field.TWO)));
  });

  test("Ed25519Field.D is as expected", () {
    final BigInt D = BigInt.parse(
        "37095705934669439343138083508754565189542113879843219016388785533085940283555");

    expect(
        D, equals(TestUtils.toBigIntFromFE(Ed25519Field.D)));
  });

  test("Ed25519Field.D_Times_TWO is as expected", () {
    final BigInt D_times_Two = BigInt.parse(
        "16295367250680780974490674513165176452449235426866156013048779062215315747161");

    expect(
        D_times_Two,
        equals(TestUtils.toBigIntFromFE(
            Ed25519Field.D_Times_TWO)));
  });

  test("Ed25519Field.I is as expected", () {
    final BigInt I = BigInt.parse(
        "19681161376707505956807079304988542015446066515923890162744021073123829784752");

    expect(
        I, equals(TestUtils.toBigIntFromFE(Ed25519Field.I)));

    /// Assert (i^2 == -1):
    BigInt result1 = I * I % Ed25519Field.P;
    BigInt result2 = (BigInt.one << 255) - BigInt.from(20);
    expect(result1, equals(result2));
  });
}
