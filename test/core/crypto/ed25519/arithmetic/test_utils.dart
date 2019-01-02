library nem2_sdk_dart.test.core.crypto.ed25519.arithmetic.math_utils;

import "dart:typed_data" show Uint8List;

import "package:pointycastle/src/utils.dart";

import "package:nem2_sdk_dart/src/core/crypto/ed25519/arithmetic/arithmetic.dart"
    show Ed25519Field, Ed25519FieldElement, Ed25519EncodedFieldElement;
import "package:nem2_sdk_dart/src/core/utils.dart" show ByteUtils;

class TestUtils {
  static final BigInt D =
      BigInt.from(-121665) * (BigInt.from(121666).modInverse(Ed25519Field.P));

  /// Converts a field element to a BigInteger.
  static BigInt toBigIntFromEd25519FieldElement(final Ed25519FieldElement f) {
    return ByteUtils.toBigIntUnsigned(f.encode().getRaw());
  }

  /// Converts a BigInteger to a field element.
  static Ed25519FieldElement toFieldElementFromBigInt(final BigInt b) {
    return new Ed25519EncodedFieldElement(ByteUtils.bigIntToBytes(b)).decode();
  }

  /// Gets the affine x-coordinate from a given affine y-coordinate and the sign of x.
  static BigInt getAffineXFromAffineY(
      final BigInt y, final bool shouldBeNegative) {
    /// x = sign(x) * sqrt((y^2 - 1) / (d * y^2 + 1))
    final BigInt u = (y * y - BigInt.one) % Ed25519Field.P;
    final BigInt v = ((D * y * y) + BigInt.one) % Ed25519Field.P;
    BigInt x = getSqrtOfFraction(u, v);

    if (BigInt.zero != (v * x * x - u) % Ed25519Field.P) {
      if (BigInt.zero != (v * x * x + u) % Ed25519Field.P) {
        throw new ArgumentError("not a valid Ed25519GroupElement");
      }
      x = (x * TestUtils.toBigIntFromEd25519FieldElement(Ed25519Field.I)) %
          Ed25519Field.P;
    }

    final bool isNegative = BigInt.one == (x % BigInt.from(2));
    if ((shouldBeNegative && !isNegative) ||
        (!shouldBeNegative && isNegative)) {
      x = negateBigInt(x);
      x = x % Ed25519Field.P;
      x = x;
    }

    return x;
  }

  /// Calculates and returns the square root of a fraction of u and v.
  /// The sign is unpredictable.
  static BigInt getSqrtOfFraction(final BigInt u, final BigInt v) {
    final BigInt tmp = (u * v.pow(7))
            .modPow((BigInt.one << 252) - BigInt.from(3), Ed25519Field.P) %
        Ed25519Field.P;
    return ((tmp * u) * v.pow(3)) % Ed25519Field.P;
  }

  /// Returns a BigInteger whose value is -[value].
  /// Ported from Java's implementation of BigInteger.negate()
  static BigInt negateBigInt(final BigInt value) {
    return BigInt.parse("-" + value.toString());
  }
}
