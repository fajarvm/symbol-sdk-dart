part of nem2_sdk_dart.core.crypto.ed25519.arithmetic;

/// Represents the underlying finite field for Ed25519.
/// The field has p = 2^255 - 19 elements.
class Ed25519Field {
  /// P: 2^255 - 19
  static final BigInt P = BigInt.parse(
      "7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed",
      radix: 16);
  static final Ed25519FieldElement ZERO = _getFieldElement(0);
  static final Ed25519FieldElement ONE = _getFieldElement(1);
  static final Ed25519FieldElement TWO = _getFieldElement(2);
  static final Ed25519FieldElement D = _getD();
  static final Ed25519FieldElement D_Times_TWO = D.multiply(TWO);
  static final Uint8List ZERO_SHORT =
      ArrayUtils.createInstantiatedUint8List(32);
  static final Uint8List ZERO_LONG = ArrayUtils.createInstantiatedUint8List(64);

  // -------------------- private / protected functions -------------------- //

  static final Ed25519FieldElement I = new Ed25519EncodedFieldElement(hex.decode(
          "b0a00e4a271beec478e42fad0618432fa7d7fb3d99004d2b0bdfc14f8024832b"))
      .decode();

  static Ed25519FieldElement _getFieldElement(final int value) {
    final List<int> f = ArrayUtils.createInstantiatedListInt(10);
    f[0] = value;
    return new Ed25519FieldElement(f);
  }

  static Ed25519FieldElement _getD() {
    final BigInt d = (new BigInt.from(-121665) *
            (new BigInt.from(121666).modInverse(Ed25519Field.P))) %
        Ed25519Field.P;

    return new Ed25519EncodedFieldElement(ArrayUtils.toByteArray(d, 32))
        .decode();
  }
}
