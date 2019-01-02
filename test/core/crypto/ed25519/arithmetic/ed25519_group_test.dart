library nem2_sdk_dart.test.core.crypto.ed25519.arithmetic.ed25519_group_test;

import "package:test/test.dart";
import "package:nem2_sdk_dart/src/core/crypto/ed25519/arithmetic/arithmetic.dart";
import "test_utils.dart";

main() {
  test("group order is as expected", () {
    final BigInt groupOrder =
        BigInt.parse("7237005577332262213973186563042994240857116359379907606001950938285454250989");

    expect(groupOrder, equals(Ed25519Group.GROUP_ORDER));
  });

  test("base point is as expected", () {
    final BigInt y = BigInt.from(4) * BigInt.from(5).modInverse(Ed25519Field.P);
    final BigInt x = TestUtils.getAffineXFromAffineY(y, false);
    final Ed25519FieldElement fex = TestUtils.toFieldElementFromBigInt(x);
    final Ed25519FieldElement fey = TestUtils.toFieldElementFromBigInt(y);
    final Ed25519GroupElement basePoint = Ed25519GroupElement.p2(fex, fey, Ed25519Field.ONE);

    expect(basePoint, equals(Ed25519Group.BASE_POINT));
  });
}
