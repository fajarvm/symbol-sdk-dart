library nem2_sdk_dart.test.core.crypto.ed25519.arithmetic.test_utils_test;

import "package:test/test.dart";
import "package:nem2_sdk_dart/src/core/crypto/ed25519/arithmetic/arithmetic.dart";
import "test_utils.dart";

/// Simple test for verifying that the MathUtils code works as expected.
main() {
  test("Simple Test", () {
    final Ed25519GroupElement neutral = Ed25519GroupElement.p3(
        Ed25519Field.ZERO,
        Ed25519Field.ONE,
        Ed25519Field.ONE,
        Ed25519Field.ZERO);

    final Ed25519GroupElement g = TestUtils.getRandomGroupElement();

    final Ed25519GroupElement h1 = TestUtils.addGroupElements(g, neutral);

    expect(g, equals(h1));
  });

  //  test("TestUtils Part 1", () {
  //    final Ed25519GroupElement neutral = Ed25519GroupElement.p3(
  //        Ed25519Field.ZERO,
  //        Ed25519Field.ONE,
  //        Ed25519Field.ONE,
  //        Ed25519Field.ZERO);
  //
  //    for (int i = 0; i < 2; i++) {
  //      final Ed25519GroupElement g = TestUtils.getRandomGroupElement();
  //
  //      // Act:
  //      final Ed25519GroupElement h1 = TestUtils.addGroupElements(g, neutral);
  //      final Ed25519GroupElement h2 = TestUtils.addGroupElements(neutral, g);
  //
  //      // Assert:
  //      expect(g, equals(h1));
  //      expect(g, equals(h2));
  //    }
  //  });

  //  test("TestUtils Part 2", () {
  //    for (int i = 0; i < 2; i++) {
  //      Ed25519GroupElement g = TestUtils.getRandomGroupElement();
  //
  //      // P3 -> P2.
  //      Ed25519GroupElement h =
  //          TestUtils.toRepresentation(g, CoordinateSystem.P2);
  //      expect(h, equals(g));
  //      // P3 -> P1xP1.
  //      h = TestUtils.toRepresentation(g, CoordinateSystem.P1xP1);
  //      expect(g, equals(h));
  //
  //      // P3 -> CACHED.
  //      h = TestUtils.toRepresentation(g, CoordinateSystem.CACHED);
  //      expect(h, equals(g));
  //
  //      // P3 -> P2 -> P3.
  //      g = TestUtils.toRepresentation(g, CoordinateSystem.P2);
  //      h = TestUtils.toRepresentation(g, CoordinateSystem.P3);
  //      expect(g, equals(h));
  //
  //      // P3 -> P2 -> P1xP1.
  //      g = TestUtils.toRepresentation(g, CoordinateSystem.P2);
  //      h = TestUtils.toRepresentation(g, CoordinateSystem.P1xP1);
  //      expect(g, equals(h));
  //    }
  //  });
  //
  //  test("TestUtils Part 3", () {
  //    for (int i = 0; i < 2; i++) {
  //      // Arrange:
  //      final Ed25519GroupElement g = TestUtils.getRandomGroupElement();
  //
  //      // Act:
  //      final Ed25519GroupElement h =
  //          TestUtils.scalarMultiplyGroupElement(g, Ed25519Field.ZERO);
  //
  //      // Assert:
  //      expect(Ed25519Group.ZERO_P3, equals(h));
  //    }
  //  });
}
