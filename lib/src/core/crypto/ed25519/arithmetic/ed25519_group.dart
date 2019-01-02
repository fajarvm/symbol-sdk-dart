part of nem2_sdk_dart.core.crypto.ed25519.arithmetic;

/// Represents the underlying group for Ed25519.
class Ed25519Group {
  /// Returns a [BigInt] with value:
  /// 2^252 - 27742317777372353535851937790883648493
  static final BigInt GROUP_ORDER = (BigInt.one << (252)) +
      (BigInt.parse("27742317777372353535851937790883648493", radix: 10));

  /// {@code
  ///  (x, 4/5); x > 0
  /// }
  static final Ed25519GroupElement BASE_POINT = _getBasePoint();

  /// different representations of zero
  static final Ed25519GroupElement ZERO_P3 = Ed25519GroupElement.p3(
      Ed25519Field.ZERO, Ed25519Field.ONE, Ed25519Field.ONE, Ed25519Field.ZERO);

  static final Ed25519GroupElement ZERO_P2 = Ed25519GroupElement.p2(
      Ed25519Field.ZERO, Ed25519Field.ONE, Ed25519Field.ONE);

  static final Ed25519GroupElement ZERO_PRECOMPUTED =
      Ed25519GroupElement.precomputed(
          Ed25519Field.ONE, Ed25519Field.ONE, Ed25519Field.ZERO);

  // -------------------- private / protected functions -------------------- //

  static Ed25519GroupElement _getBasePoint() {
    final Uint8List rawEncodedGroupElement = hex.decode(
        "5866666666666666666666666666666666666666666666666666666666666666");
    final Ed25519GroupElement basePoint =
        new Ed25519EncodedGroupElement(rawEncodedGroupElement).decode();
    basePoint.precomputeForScalarMultiplication();
    basePoint.precomputeForDoubleScalarMultiplication();
    return basePoint;
  }
}
