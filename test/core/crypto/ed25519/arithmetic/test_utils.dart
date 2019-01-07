library nem2_sdk_dart.test.core.crypto.ed25519.arithmetic.test_utils;

import "dart:typed_data" show Uint8List;

import "package:pointycastle/pointycastle.dart" hide PublicKey, PrivateKey, Signature;

import "package:nem2_sdk_dart/src/core/crypto.dart" hide BlockCipher;
import "package:nem2_sdk_dart/src/core/crypto/ed25519/arithmetic/arithmetic.dart";
import "package:nem2_sdk_dart/src/core/utils.dart" show ArrayUtils, ByteUtils;

class TestUtils {
  static final List<int> EXPONENTS = [
    0,
    26,
    26 + 25,
    2 * 26 + 25,
    2 * 26 + 2 * 25,
    3 * 26 + 2 * 25,
    3 * 26 + 3 * 25,
    4 * 26 + 3 * 25,
    4 * 26 + 4 * 25,
    5 * 26 + 4 * 25
  ];

  /// Java impl is using the SHA1PRNG algorithm
//  static final SecureRandom RANDOM = new SecureRandom("Fortuna");
  static final BigInt D =
      BigInt.from(-121665) * (BigInt.from(121666).modInverse(Ed25519Field.P));

  /// Gets a random group element in P3 coordinates.
  /// It's NOT guaranteed that the created group element is a multiple of
  /// the base point.
  static Ed25519GroupElement getRandomGroupElement() {
    SecureRandom RANDOM = new SecureRandom("Fortuna");

    try {
        final Uint8List bytes = RANDOM.nextBytes(32);
        return new Ed25519EncodedGroupElement(bytes).decode();
      } catch (error) {
        // Will fail in about 50%, so try again.
        // TODO: Currently stuck here. Keep getting error: AES Engine is not initialised
      }

      return getRandomGroupElement();
  }

  /// Converts a field element to a BigInt.
  static BigInt toBigIntFromFE(final Ed25519FieldElement f) {
    return ByteUtils.toBigIntUnsigned(f.encode().getRaw());
  }

  /// Converts an encoded field element to a BigInteger.
  static BigInt toBigIntFromEncodedFE(
      final Ed25519EncodedFieldElement encoded) {
    return ByteUtils.toBigIntUnsigned(encoded.getRaw());
  }

  /// Converts a BigInt to a field element.
  static Ed25519FieldElement toFieldElement(final BigInt b) {
    return new Ed25519EncodedFieldElement(ByteUtils.bigIntToBytes(b)).decode();
  }

  /// Converts a BigInteger to an encoded field element.
  static Ed25519EncodedFieldElement toEncodedFieldElement(final BigInt b) {
    return new Ed25519EncodedFieldElement(ByteUtils.bigIntToBytes(b));
  }

  /// Reduces an encoded field element modulo the group order and returns the result.
  static Ed25519EncodedFieldElement reduceModGroupOrder(
      final Ed25519EncodedFieldElement encoded) {
    final BigInt b = toBigIntFromEncodedFE(encoded) % Ed25519Group.GROUP_ORDER;
    return toEncodedFieldElement(b);
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
      x = (x * TestUtils.toBigIntFromFE(Ed25519Field.I)) % Ed25519Field.P;
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

  /// Returns a BigInt whose value is -[value].
  /// Ported from Java's implementation of BigInt.negate()
  static BigInt negateBigInt(final BigInt value) {
    return BigInt.parse("-" + value.toString());
  }

  /// Converts a group element from one coordinate system to another.
  /// This method is a helper used to test various methods in Ed25519GroupElement.
  static Ed25519GroupElement toRepresentation(
      final Ed25519GroupElement g, final CoordinateSystem newCoordinateSystem) {
    BigInt x;
    BigInt y;
    final BigInt gX = toBigIntFromEncodedFE(g.X.encode());
    final BigInt gY = toBigIntFromEncodedFE(g.Y.encode());
    final BigInt gZ = toBigIntFromEncodedFE(g.Z.encode());
    final BigInt gT = null == g.T ? null : toBigIntFromEncodedFE(g.T.encode());

    /// Switch to affine coordinates.
    switch (g.coordinateSystem) {
      case CoordinateSystem.AFFINE:
        x = gX;
        y = gY;
        break;
      case CoordinateSystem.P2:
      case CoordinateSystem.P3:
        x = gX * (gZ.modInverse(Ed25519Field.P)) % Ed25519Field.P;
        y = gY * (gZ.modInverse(Ed25519Field.P)) % Ed25519Field.P;
        break;
      case CoordinateSystem.P1xP1:
        x = gX * (gZ.modInverse(Ed25519Field.P)) % Ed25519Field.P;
        assert(gT != null);
        y = gY * (gT.modInverse(Ed25519Field.P)) % Ed25519Field.P;
        break;
      case CoordinateSystem.CACHED:
        x = gX -
            gY *
                (gZ * (BigInt.two).modInverse(Ed25519Field.P)) %
                Ed25519Field.P;
        y = gX +
            gY *
                (gZ * (BigInt.two).modInverse(Ed25519Field.P)) %
                (Ed25519Field.P);
        break;
      case CoordinateSystem.PRECOMPUTED:
        x = gX -
            gY * (BigInt.two.modInverse(Ed25519Field.P)) % (Ed25519Field.P);
        y = gX +
            gY * (BigInt.two.modInverse(Ed25519Field.P)) % (Ed25519Field.P);
        break;
      default:
        throw new UnsupportedError("Unsupported operation");
    }

    /// Now back to the desired coordinate system.
    switch (newCoordinateSystem) {
      case CoordinateSystem.AFFINE:
        return Ed25519GroupElement.affine(
            toFieldElement(x), toFieldElement(y), Ed25519Field.ONE);
      case CoordinateSystem.P2:
        return Ed25519GroupElement.p2(
            toFieldElement(x), toFieldElement(y), Ed25519Field.ONE);
      case CoordinateSystem.P3:
        return Ed25519GroupElement.p3(toFieldElement(x), toFieldElement(y),
            Ed25519Field.ONE, toFieldElement(x * (y) % (Ed25519Field.P)));
      case CoordinateSystem.P1xP1:
        return Ed25519GroupElement.p1xp1(toFieldElement(x), toFieldElement(y),
            Ed25519Field.ONE, Ed25519Field.ONE);
      case CoordinateSystem.CACHED:
        return Ed25519GroupElement.cached(
            toFieldElement(y - x % Ed25519Field.P),
            toFieldElement(y - x % Ed25519Field.P),
            Ed25519Field.ONE,
            toFieldElement(D * BigInt.two * x * y % Ed25519Field.P));
      case CoordinateSystem.PRECOMPUTED:
        return Ed25519GroupElement.precomputed(
            toFieldElement(y + x % Ed25519Field.P),
            toFieldElement(y - x % Ed25519Field.P),
            toFieldElement(D * BigInt.two * x * y % Ed25519Field.P));
      default:
        throw new UnsupportedError("Unsupported operation");
    }
  }

  /// Adds two group elements and returns the result in P3 coordinate system.
  /// It uses BigInt arithmetic and the affine coordinate system.
  /// This method is a helper used to test the projective group addition formulas in Ed25519GroupElement.
  static Ed25519GroupElement addGroupElements(
      final Ed25519GroupElement g1, final Ed25519GroupElement g2) {
    /// Relying on a special coordinate system of the group elements.
    if ((g1.coordinateSystem != CoordinateSystem.P2 &&
            g1.coordinateSystem != CoordinateSystem.P3) ||
        (g2.coordinateSystem != CoordinateSystem.P2 &&
            g2.coordinateSystem != CoordinateSystem.P3)) {
      throw new ArgumentError("g1 and g2 must have coordinate system P2 or P3");
    }

    /// Projective coordinates
    final BigInt g1X = toBigIntFromEncodedFE(g1.X.encode());
    final BigInt g1Y = toBigIntFromEncodedFE(g1.Y.encode());
    final BigInt g1Z = toBigIntFromEncodedFE(g1.Z.encode());
    final BigInt g2X = toBigIntFromEncodedFE(g2.X.encode());
    final BigInt g2Y = toBigIntFromEncodedFE(g2.Y.encode());
    final BigInt g2Z = toBigIntFromEncodedFE(g2.Z.encode());

    /// Affine coordinates
    final BigInt g1x = g1X * (g1Z.modInverse(Ed25519Field.P)) % Ed25519Field.P;
    final BigInt g1y = g1Y * (g1Z.modInverse(Ed25519Field.P)) % Ed25519Field.P;
    final BigInt g2x = g2X * (g2Z.modInverse(Ed25519Field.P)) % Ed25519Field.P;
    final BigInt g2y = g2Y * (g2Z.modInverse(Ed25519Field.P)) % Ed25519Field.P;

    /// Addition formula for affine coordinates. The formula is complete in our case.
    ///
    /// (x3, y3) = (x1, y1) + (x2, y2) where
    ///
    /// x3 = (x1 * y2 + x2 * y1) / (1 + d * x1 * x2 * y1 * y2) and
    /// y3 = (x1 * x2 + y1 * y2) / (1 - d * x1 * x2 * y1 * y2) and
    /// d = -121665/121666
    final BigInt dx1x2y1y2 = D * g1x * g2x * g1y * g2y % Ed25519Field.P;
    final BigInt x3 = g1x * g2y +
        (g2x * g1y) *
            (BigInt.one + dx1x2y1y2).modInverse(Ed25519Field.P) %
            Ed25519Field.P;
    final BigInt y3 = g1x * g2x +
        (g1y * g2y) *
            ((BigInt.one - dx1x2y1y2).modInverse(Ed25519Field.P)) %
            Ed25519Field.P;
    final BigInt t3 = x3 * (y3) % Ed25519Field.P;

    return Ed25519GroupElement.p3(toFieldElement(x3), toFieldElement(y3),
        Ed25519Field.ONE, toFieldElement(t3));
  }

  /// Doubles a group element and returns the result in the P3 coordinate system.
  /// It uses BigInteger arithmetic and the affine coordinate system.
  /// This method is a helper used to test the projective group doubling formula in Ed25519GroupElement.
  static Ed25519GroupElement doubleGroupElement(final Ed25519GroupElement g) {
    return addGroupElements(g, g);
  }

  /// Scalar multiply the group element by the field element.
  static Ed25519GroupElement scalarMultiplyGroupElement(
      final Ed25519GroupElement g, final Ed25519FieldElement f) {
    final Uint8List bytes = f.encode().getRaw();
    Ed25519GroupElement h = Ed25519Group.ZERO_P3;
    for (int i = 254; i >= 0; i--) {
      h = doubleGroupElement(h);
      if (ArrayUtils.getBit(bytes, i) == 1) {
        h = addGroupElements(h, g);
      }
    }

    return h;
  }

  /// Calculates f1 * g1 - f2 * g2.
  static Ed25519GroupElement doubleScalarMultiplyGroupElements(
      final Ed25519GroupElement g1,
      final Ed25519FieldElement f1,
      final Ed25519GroupElement g2,
      final Ed25519FieldElement f2) {
    final Ed25519GroupElement h1 = scalarMultiplyGroupElement(g1, f1);
    final Ed25519GroupElement h2 = scalarMultiplyGroupElement(g2, f2);
    return addGroupElements(h1, h2.negate());
  }

  /// Negates a group element.
  static Ed25519GroupElement negateGroupElement(final Ed25519GroupElement g) {
    if (g.coordinateSystem != CoordinateSystem.P3) {
      throw new ArgumentError("g must have coordinate system P3");
    }

    return Ed25519GroupElement.p3(g.X.negate(), g.Y, g.Z, g.T.negate());
  }

  /// Derives the public key from a private key.
  static PublicKey derivePublicKey(final PrivateKey privateKey) {
    final Digest digest = new Digest("SHA-3/512");
    final Uint8List hash = digest.process(privateKey.getBytes());
    // Java code was:
    // Arrays.copyOfRange(hash, 0, 32);
    final Uint8List a = hash.take(32);
    a[31] &= 0x7F;
    a[31] |= 0x40;
    a[0] &= 0xF8;
    final Ed25519GroupElement pubKey = scalarMultiplyGroupElement(
        Ed25519Group.BASE_POINT, toFieldElement(ByteUtils.toBigIntUnsigned(a)));

    return new PublicKey(pubKey.encode().getRaw());
  }

  /// Creates a signature from a key pair and message.
  static Signature sign(final KeyPair keyPair, final Uint8List data) {
    final Digest digest = new Digest("SHA-3/512");
    final Uint8List hash = digest.process(keyPair.privateKey.getBytes());
    // Java code was:
    // Arrays.copyOfRange(hash, 0, 32);
    final Uint8List a = hash.take(32);
    a[31] &= 0x7F;
    a[31] |= 0x40;
    a[0] &= 0xF8;
    // Java code was:
    // Hashes.sha3_512(Arrays.copyOfRange(hash, 32, 64), data);
    // final Ed25519EncodedFieldElement r = new Ed25519EncodedFieldElement(
    //    Hashes.sha3_512(
    //        Arrays.copyOfRange(hash, 32, 64),
    //        data
    //    )
    // );
    final Uint8List composition1 = hash.skip(32).take(32);
    composition1.addAll(data.toList());
    final Ed25519EncodedFieldElement r =
        new Ed25519EncodedFieldElement(digest.process(composition1));
    final Ed25519EncodedFieldElement rReduced = reduceModGroupOrder(r);
    final Ed25519GroupElement R = scalarMultiplyGroupElement(
        Ed25519Group.BASE_POINT,
        toFieldElement(toBigIntFromEncodedFE(rReduced)));

    // Java code was:
    // Hashes.sha3_512(R.encode().getRaw(), keyPair.publicKey.getRaw(), data)
    final Uint8List composition2 = R.encode().getRaw();
    composition2.addAll(keyPair.publicKey.getRaw());
    composition2.addAll(data);
    final Ed25519EncodedFieldElement h =
        new Ed25519EncodedFieldElement(digest.process(composition2));
    final Ed25519EncodedFieldElement hReduced = reduceModGroupOrder(h);
    final BigInt S = toBigIntFromEncodedFE(rReduced) +
        (toBigIntFromEncodedFE(hReduced) * ByteUtils.toBigIntUnsigned(a)) %
            Ed25519Group.GROUP_ORDER;

    return new Signature(
        rBytes: R.encode().getRaw(), sBytes: ByteUtils.bigIntToBytes(S));
  }
}
