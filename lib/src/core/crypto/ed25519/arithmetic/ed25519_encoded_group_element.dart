part of nem2_sdk_dart.core.crypto.ed25519.arithmetic;

class Ed25519EncodedGroupElement {
  final Uint8List _values;

  Ed25519EncodedGroupElement._(this._values);

  /// Creates a new encoded group element.
  factory Ed25519EncodedGroupElement(final Uint8List values) {
    if (values == null || values.length != 32) {
      throw new ArgumentError("Invalid encoded group element.");
    }

    /// replace null values
    ArrayUtils.replaceNullWithZero(values);

    return new Ed25519EncodedGroupElement._(values);
  }

  /// Returns the underlying byte array
  Uint8List getRaw() {
    return this._values;
  }

  @override
  int get hashCode {
    return this._values.hashCode;
  }

  @override
  bool operator ==(final other) {
    return (other is Ed25519EncodedGroupElement) &&
        (1 == ArrayUtils.isEqualConstantTime(this._values, other.getRaw()));
  }

  @override
  String toString() {
    return "x=${this.getAffineX().toString()}\n"
        "y=${this.getAffineY.toString()}\n";
  }

  // -------------------- math operations and functions -------------------- //

  /// Decodes this encoded group element and returns a new group element in P3
  /// coordinates.
  Ed25519GroupElement decode() {
    final Ed25519FieldElement x = this.getAffineX();
    final Ed25519FieldElement y = this.getAffineY();
    return Ed25519GroupElement.p3(x, y, Ed25519Field.ONE, x.multiply(y));
  }

  /// Gets the affine x-coordinate.
  /// x is recovered in the following way (p = field size):
  ///
  /// x = sign(x) * sqrt((y^2 - 1) / (d * y^2 + 1)) = sign(x) * sqrt(u / v)
  /// with u = y^2 - 1 and v = d * y^2 + 1.
  /// Setting β = (u * v^3) * (u * v^7)^((p - 5) / 8) one has β^2 = +-(u / v).
  /// If v * β = -u multiply β with i=sqrt(-1).
  /// Set x := β.
  /// If sign(x) != bit 255 of s then negate x.
  Ed25519FieldElement getAffineX() {
    Ed25519FieldElement x;
    Ed25519FieldElement checkForZero;
    final Ed25519FieldElement y = this.getAffineY();
    final Ed25519FieldElement ySquare = y.square();

    /// u = y^2 - 1
    final Ed25519FieldElement u = ySquare.subtract(Ed25519Field.ONE);

    /// v = d * y^2 + 1
    final Ed25519FieldElement v =
        ySquare.multiply(Ed25519Field.D).add(Ed25519Field.ONE);

    /// x = sqrt(u / v)
    x = Ed25519FieldElement.sqrt(u, v);

    final Ed25519FieldElement vxSquare = x.square().multiply(v);
    checkForZero = vxSquare.subtract(u);
    if (checkForZero.isNonZero()) {
      checkForZero = vxSquare.add(u);
      if (checkForZero.isNonZero()) {
        throw new ArgumentError("not a valid Ed25519EncodedGroupElement.");
      }

      x = x.multiply(Ed25519Field.I);
    }

    if ((x.isNegative() ? 1 : 0) != ArrayUtils.getBit(this._values, 255)) {
      x = x.negate();
    }

    return x;
  }

  /// Gets the affine y-coordinate.
  Ed25519FieldElement getAffineY() {
    /// The affine y-coordinate is in bits 0 to 254.
    /// Since the decode() method of Ed25519EncodedFieldElement ignores bit 255,
    /// we can use that method without problems.
    final Ed25519EncodedFieldElement encoded =
        new Ed25519EncodedFieldElement(this._values);
    return encoded.decode();
  }
}
