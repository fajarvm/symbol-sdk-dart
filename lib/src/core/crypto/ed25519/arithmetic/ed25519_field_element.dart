part of nem2_sdk_dart.core.crypto.ed25519.arithmetic;

/// Represents a element of the finite field with p=2^255-19 elements.
///
/// values[0] ... values[9], represent the integer
/// values[0] + 2^26 * values[1] + 2^51 * values[2] + 2^77 * values[3]
/// + 2^102 * values[4] + ... + 2^230 * values[9].
/// Bounds on each values[i] vary depending on context.
///
/// This implementation is based on the ref10 implementation of SUPERCOP.
class Ed25519FieldElement {
  final List<int> _values;

  Ed25519FieldElement._(this._values);

  /// Creates a field element.
  /// Accepts the 2^25.5 bit representation of the field element as [values].
  factory Ed25519FieldElement(final List<int> values) {
    if (values.length != 10) {
      throw new ArgumentError("Invalid 2^25.5 bit representation.");
    }

    /// We set default null values here to zeros.
    ArrayUtils.replaceNullWithZero(values);

    return new Ed25519FieldElement._(values);
  }

  /// Gets the underlying list of int.
  List<int> getRaw() {
    return this._values;
  }

  /// Gets a value indicating whether or not the field element is non-zero.
  bool isNonZero() {
    return this.encode().isNonZero();
  }

  /// Returns true if this is in {1,3,5,...,q-2}
  /// Returns false if this is in {0,2,4,...,q-1}
  ///
  /// Preconditions:
  /// |x| bounded by 1.1*2^26,1.1*2^25,1.1*2^26,1.1*2^25,etc.
  bool isNegative() {
    return this.encode().isNegative();
  }

  @override
  int get hashCode {
    return this._values.hashCode;
  }

  @override
  bool operator ==(final o) {
    return (o is Ed25519FieldElement) && (o.encode() == this.encode());
  }

  @override
  String toString() {
    return this.encode().toString();
  }

  // -------------------- math operations and functions -------------------- //

  Ed25519EncodedFieldElement encode() {
    /// Step 1:
    final Ed25519FieldElement g = this._modP();
    final List<int> gValues = g.getRaw();
    final int h0 = gValues[0];
    final int h1 = gValues[1];
    final int h2 = gValues[2];
    final int h3 = gValues[3];
    final int h4 = gValues[4];
    final int h5 = gValues[5];
    final int h6 = gValues[6];
    final int h7 = gValues[7];
    final int h8 = gValues[8];
    final int h9 = gValues[9];

    /// Step 2:
    final Uint8List s = new Uint8List(32);
    s[0] = (h0);
    s[1] = (h0 >> 8);
    s[2] = (h0 >> 16);
    s[3] = ((h0 >> 24) | (h1 << 2));
    s[4] = (h1 >> 6);
    s[5] = (h1 >> 14);
    s[6] = ((h1 >> 22) | (h2 << 3));
    s[7] = (h2 >> 5);
    s[8] = (h2 >> 13);
    s[9] = ((h2 >> 21) | (h3 << 5));
    s[10] = (h3 >> 3);
    s[11] = (h3 >> 11);
    s[12] = ((h3 >> 19) | (h4 << 6));
    s[13] = (h4 >> 2);
    s[14] = (h4 >> 10);
    s[15] = (h4 >> 18);
    s[16] = (h5);
    s[17] = (h5 >> 8);
    s[18] = (h5 >> 16);
    s[19] = ((h5 >> 24) | (h6 << 1));
    s[20] = (h6 >> 7);
    s[21] = (h6 >> 15);
    s[22] = ((h6 >> 23) | (h7 << 3));
    s[23] = (h7 >> 5);
    s[24] = (h7 >> 13);
    s[25] = ((h7 >> 21) | (h8 << 4));
    s[26] = (h8 >> 4);
    s[27] = (h8 >> 12);
    s[28] = ((h8 >> 20) | (h9 << 6));
    s[29] = (h9 >> 2);
    s[30] = (h9 >> 10);
    s[31] = (h9 >> 18);

    return new Ed25519EncodedFieldElement(s);
  }

  static Ed25519FieldElement sqrt(
      final Ed25519FieldElement u, final Ed25519FieldElement v) {
    /// v3 = v^3
    final Ed25519FieldElement v3 = v.square().multiply(v);

    /// x = (v3^2) * v * u = u * v^7
    Ed25519FieldElement x = v3.square().multiply(v).multiply(u);

    /// x = (u * v^7)^((q - 5) / 8)
    x = x._pow2to252sub4().multiply(x);

    /// 2^252 - 3

    /// x = u * v^3 * (u * v^7)^((q - 5) / 8)
    x = v3.multiply(u).multiply(x);

    return x;
  }

  /// Adds the given field element to this and returns the result.
  ///
  /// h = this + g
  ///
  /// Preconditions:
  ///     |this| bounded by 1.1*2^25,1.1*2^24,1.1*2^25,1.1*2^24,etc.
  ///        |g| bounded by 1.1*2^25,1.1*2^24,1.1*2^25,1.1*2^24,etc.
  /// Postconditions:
  ///        |h| bounded by 1.1*2^26,1.1*2^25,1.1*2^26,1.1*2^25,etc.
  Ed25519FieldElement add(final Ed25519FieldElement g) {
    final List<int> gValues = g.getRaw();
    final List<int> h = new List<int>(10);
    for (int i = 0; i < 10; i++) {
      h[i] = this._values[i] + gValues[i];
    }

    return new Ed25519FieldElement(h);
  }

  /// Subtract the given field element from this and returns the result.
  ///
  /// h = this - g
  ///
  /// Preconditions:
  ///     |this| bounded by 1.1*2^25,1.1*2^24,1.1*2^25,1.1*2^24,etc.
  ///        |g| bounded by 1.1*2^25,1.1*2^24,1.1*2^25,1.1*2^24,etc.
  /// Postconditions:
  ///        |h| bounded by 1.1*2^26,1.1*2^25,1.1*2^26,1.1*2^25,etc.
  Ed25519FieldElement subtract(final Ed25519FieldElement g) {
    final List<int> gValues = g.getRaw();
    final List<int> h = new List<int>(10);
    for (int i = 0; i < 10; i++) {
      h[i] = this._values[i] - gValues[i];
    }

    return new Ed25519FieldElement(h);
  }

  /// Negates this field element and return the result.
  ///
  /// h = -this
  ///
  /// Preconditions:
  ///     |this| bounded by 1.1*2^25,1.1*2^24,1.1*2^25,1.1*2^24,etc.
  /// Postconditions:
  ///        |h| bounded by 1.1*2^25,1.1*2^24,1.1*2^25,1.1*2^24,etc.
  Ed25519FieldElement negate() {
    final List<int> h = new List<int>(10);
    for (int i = 0; i < 10; i++) {
      h[i] = -this._values[i];
    }

    return new Ed25519FieldElement(h);
  }

  /// Multiplies this field element with the given field element and returns
  /// the result.
  ///
  /// h = this * g
  ///
  /// Preconditions:
  ///
  ///     |this| bounded by 1.65*2^26,1.65*2^25,1.65*2^26,1.65*2^25,etc.
  ///        |g| bounded by 1.65*2^26,1.65*2^25,1.65*2^26,1.65*2^25,etc.
  /// Postconditions:
  ///        |h| bounded by 1.01*2^25,1.01*2^24,1.01*2^25,1.01*2^24,etc.
  ///
  /// Notes on implementation strategy:
  ///
  /// Using schoolbook multiplication. Karatsuba would save a little in some
  /// cost models.
  ///
  /// Most multiplications by 2 and 19 are 32-bit precomputations; cheaper than
  /// 64-bit postcomputations.
  ///
  /// There is one remaining multiplication by 19 in the carry chain; one *19
  /// precomputation can be merged into this, but the resulting data flow is
  /// considerably less clean.
  ///
  /// There are 12 carries below. 10 of them are 2-way parallelizable and
  /// vectorizable. Can get away with 11 carries, but then data flow is much
  /// deeper.
  ///
  /// With tighter constraints on inputs can squeeze carries into int32.
  Ed25519FieldElement multiply(final Ed25519FieldElement g) {
    final List<int> gValues = g.getRaw();
    final int f0 = this._values[0];
    final int f1 = this._values[1];
    final int f2 = this._values[2];
    final int f3 = this._values[3];
    final int f4 = this._values[4];
    final int f5 = this._values[5];
    final int f6 = this._values[6];
    final int f7 = this._values[7];
    final int f8 = this._values[8];
    final int f9 = this._values[9];
    final int g0 = gValues[0];
    final int g1 = gValues[1];
    final int g2 = gValues[2];
    final int g3 = gValues[3];
    final int g4 = gValues[4];
    final int g5 = gValues[5];
    final int g6 = gValues[6];
    final int g7 = gValues[7];
    final int g8 = gValues[8];
    final int g9 = gValues[9];
    final int g1_19 = 19 * g1; /* 1.959375*2^29 */
    final int g2_19 = 19 * g2; /* 1.959375*2^30; still ok */
    final int g3_19 = 19 * g3;
    final int g4_19 = 19 * g4;
    final int g5_19 = 19 * g5;
    final int g6_19 = 19 * g6;
    final int g7_19 = 19 * g7;
    final int g8_19 = 19 * g8;
    final int g9_19 = 19 * g9;
    final int f1_2 = 2 * f1;
    final int f3_2 = 2 * f3;
    final int f5_2 = 2 * f5;
    final int f7_2 = 2 * f7;
    final int f9_2 = 2 * f9;
    final int f0g0 = f0 * g0;
    final int f0g1 = f0 * g1;
    int f0g2 = f0 * g2;
    int f0g3 = f0 * g3;
    int f0g4 = f0 * g4;
    int f0g5 = f0 * g5;
    int f0g6 = f0 * g6;
    int f0g7 = f0 * g7;
    int f0g8 = f0 * g8;
    int f0g9 = f0 * g9;
    int f1g0 = f1 * g0;
    int f1g1_2 = f1_2 * g1;
    int f1g2 = f1 * g2;
    int f1g3_2 = f1_2 * g3;
    int f1g4 = f1 * g4;
    int f1g5_2 = f1_2 * g5;
    int f1g6 = f1 * g6;
    int f1g7_2 = f1_2 * g7;
    int f1g8 = f1 * g8;
    int f1g9_38 = f1_2 * g9_19;
    int f2g0 = f2 * g0;
    int f2g1 = f2 * g1;
    int f2g2 = f2 * g2;
    int f2g3 = f2 * g3;
    int f2g4 = f2 * g4;
    int f2g5 = f2 * g5;
    int f2g6 = f2 * g6;
    int f2g7 = f2 * g7;
    int f2g8_19 = f2 * g8_19;
    int f2g9_19 = f2 * g9_19;
    int f3g0 = f3 * g0;
    int f3g1_2 = f3_2 * g1;
    int f3g2 = f3 * g2;
    int f3g3_2 = f3_2 * g3;
    int f3g4 = f3 * g4;
    int f3g5_2 = f3_2 * g5;
    int f3g6 = f3 * g6;
    int f3g7_38 = f3_2 * g7_19;
    int f3g8_19 = f3 * g8_19;
    int f3g9_38 = f3_2 * g9_19;
    int f4g0 = f4 * g0;
    int f4g1 = f4 * g1;
    int f4g2 = f4 * g2;
    int f4g3 = f4 * g3;
    int f4g4 = f4 * g4;
    int f4g5 = f4 * g5;
    int f4g6_19 = f4 * g6_19;
    int f4g7_19 = f4 * g7_19;
    int f4g8_19 = f4 * g8_19;
    int f4g9_19 = f4 * g9_19;
    int f5g0 = f5 * g0;
    int f5g1_2 = f5_2 * g1;
    int f5g2 = f5 * g2;
    int f5g3_2 = f5_2 * g3;
    int f5g4 = f5 * g4;
    int f5g5_38 = f5_2 * g5_19;
    int f5g6_19 = f5 * g6_19;
    int f5g7_38 = f5_2 * g7_19;
    int f5g8_19 = f5 * g8_19;
    int f5g9_38 = f5_2 * g9_19;
    int f6g0 = f6 * g0;
    int f6g1 = f6 * g1;
    int f6g2 = f6 * g2;
    int f6g3 = f6 * g3;
    int f6g4_19 = f6 * g4_19;
    int f6g5_19 = f6 * g5_19;
    int f6g6_19 = f6 * g6_19;
    int f6g7_19 = f6 * g7_19;
    int f6g8_19 = f6 * g8_19;
    int f6g9_19 = f6 * g9_19;
    int f7g0 = f7 * g0;
    int f7g1_2 = f7_2 * g1;
    int f7g2 = f7 * g2;
    int f7g3_38 = f7_2 * g3_19;
    int f7g4_19 = f7 * g4_19;
    int f7g5_38 = f7_2 * g5_19;
    int f7g6_19 = f7 * g6_19;
    int f7g7_38 = f7_2 * g7_19;
    int f7g8_19 = f7 * g8_19;
    int f7g9_38 = f7_2 * g9_19;
    int f8g0 = f8 * g0;
    int f8g1 = f8 * g1;
    int f8g2_19 = f8 * g2_19;
    int f8g3_19 = f8 * g3_19;
    int f8g4_19 = f8 * g4_19;
    int f8g5_19 = f8 * g5_19;
    int f8g6_19 = f8 * g6_19;
    int f8g7_19 = f8 * g7_19;
    int f8g8_19 = f8 * g8_19;
    int f8g9_19 = f8 * g9_19;
    int f9g0 = f9 * g0;
    int f9g1_38 = f9_2 * g1_19;
    int f9g2_19 = f9 * g2_19;
    int f9g3_38 = f9_2 * g3_19;
    int f9g4_19 = f9 * g4_19;
    int f9g5_38 = f9_2 * g5_19;
    int f9g6_19 = f9 * g6_19;
    int f9g7_38 = f9_2 * g7_19;
    int f9g8_19 = f9 * g8_19;
    int f9g9_38 = f9_2 * g9_19;

    /// Remember: 2^255 congruent 19 modulo p.
    /// h = h0 * 2^0 + h1 * 2^26 + h2 * 2^(26+25) + h3 * 2^(26+25+26)
    /// + ... + h9 * 2^(5*26+5*25).
    /// So to get the real number we would have to multiply the coefficients
    /// with the corresponding powers of 2.
    /// To get an idea what is going on below, look at the calculation of h0:
    /// h0 is the coefficient to the power 2^0 so it collects (sums) all
    /// products that have the power 2^0.
    /// f0 * g0 really is f0 * 2^0 * g0 * 2^0 = (f0 * g0) * 2^0.
    /// f1 * g9 really is f1 * 2^26 * g9 * 2^230 = f1 * g9 * 2^256
    /// = 2 * f1 * g9 * 2^255 congruent 2 * 19 * f1 * g9 * 2^0 modulo p.
    /// f2 * g8 really is f2 * 2^51 * g8 * 2^204 = f2 * g8 * 2^255
    /// congruent 19 * f2 * g8 * 2^0 modulo p.
    /// and so on...
    int h0 = f0g0 +
        f1g9_38 +
        f2g8_19 +
        f3g7_38 +
        f4g6_19 +
        f5g5_38 +
        f6g4_19 +
        f7g3_38 +
        f8g2_19 +
        f9g1_38;
    int h1 = f0g1 +
        f1g0 +
        f2g9_19 +
        f3g8_19 +
        f4g7_19 +
        f5g6_19 +
        f6g5_19 +
        f7g4_19 +
        f8g3_19 +
        f9g2_19;
    int h2 = f0g2 +
        f1g1_2 +
        f2g0 +
        f3g9_38 +
        f4g8_19 +
        f5g7_38 +
        f6g6_19 +
        f7g5_38 +
        f8g4_19 +
        f9g3_38;
    int h3 = f0g3 +
        f1g2 +
        f2g1 +
        f3g0 +
        f4g9_19 +
        f5g8_19 +
        f6g7_19 +
        f7g6_19 +
        f8g5_19 +
        f9g4_19;
    int h4 = f0g4 +
        f1g3_2 +
        f2g2 +
        f3g1_2 +
        f4g0 +
        f5g9_38 +
        f6g8_19 +
        f7g7_38 +
        f8g6_19 +
        f9g5_38;
    int h5 = f0g5 +
        f1g4 +
        f2g3 +
        f3g2 +
        f4g1 +
        f5g0 +
        f6g9_19 +
        f7g8_19 +
        f8g7_19 +
        f9g6_19;
    int h6 = f0g6 +
        f1g5_2 +
        f2g4 +
        f3g3_2 +
        f4g2 +
        f5g1_2 +
        f6g0 +
        f7g9_38 +
        f8g8_19 +
        f9g7_38;
    int h7 = f0g7 +
        f1g6 +
        f2g5 +
        f3g4 +
        f4g3 +
        f5g2 +
        f6g1 +
        f7g0 +
        f8g9_19 +
        f9g8_19;
    int h8 = f0g8 +
        f1g7_2 +
        f2g6 +
        f3g5_2 +
        f4g4 +
        f5g3_2 +
        f6g2 +
        f7g1_2 +
        f8g0 +
        f9g9_38;
    int h9 =
        f0g9 + f1g8 + f2g7 + f3g6 + f4g5 + f5g4 + f6g3 + f7g2 + f8g1 + f9g0;
    int carry0;
    int carry1;
    int carry2;
    int carry3;
    int carry4;
    int carry5;
    int carry6;
    int carry7;
    int carry8;
    int carry9;

    /// |h0| <= (1.65*1.65*2^52*(1+19+19+19+19)+1.65*1.65*2^50*(38+38+38+38+38))
    /// i.e. |h0| <= 1.4*2^60; narrower ranges for h2, h4, h6, h8
    /// |h1| <= (1.65*1.65*2^51*(1+1+19+19+19+19+19+19+19+19))
    /// i.e. |h1| <= 1.7*2^59; narrower ranges for h3, h5, h7, h9

    carry0 = (h0 + (1 << 25)) >> 26;
    h1 += carry0;
    h0 -= carry0 << 26;
    carry4 = (h4 + (1 << 25)) >> 26;
    h5 += carry4;
    h4 -= carry4 << 26;
    /* |h0| <= 2^25 */
    /* |h4| <= 2^25 */
    /* |h1| <= 1.71*2^59 */
    /* |h5| <= 1.71*2^59 */

    carry1 = (h1 + (1 << 24)) >> 25;
    h2 += carry1;
    h1 -= carry1 << 25;
    carry5 = (h5 + (1 << 24)) >> 25;
    h6 += carry5;
    h5 -= carry5 << 25;
    /* |h1| <= 2^24; from now on fits into int32 */
    /* |h5| <= 2^24; from now on fits into int32 */
    /* |h2| <= 1.41*2^60 */
    /* |h6| <= 1.41*2^60 */

    carry2 = (h2 + (1 << 25)) >> 26;
    h3 += carry2;
    h2 -= carry2 << 26;
    carry6 = (h6 + (1 << 25)) >> 26;
    h7 += carry6;
    h6 -= carry6 << 26;
    /* |h2| <= 2^25; from now on fits into int32 unchanged */
    /* |h6| <= 2^25; from now on fits into int32 unchanged */
    /* |h3| <= 1.71*2^59 */
    /* |h7| <= 1.71*2^59 */

    carry3 = (h3 + (1 << 24)) >> 25;
    h4 += carry3;
    h3 -= carry3 << 25;
    carry7 = (h7 + (1 << 24)) >> 25;
    h8 += carry7;
    h7 -= carry7 << 25;
    /* |h3| <= 2^24; from now on fits into int32 unchanged */
    /* |h7| <= 2^24; from now on fits into int32 unchanged */
    /* |h4| <= 1.72*2^34 */
    /* |h8| <= 1.41*2^60 */

    carry4 = (h4 + (1 << 25)) >> 26;
    h5 += carry4;
    h4 -= carry4 << 26;
    carry8 = (h8 + (1 << 25)) >> 26;
    h9 += carry8;
    h8 -= carry8 << 26;
    /* |h4| <= 2^25; from now on fits into int32 unchanged */
    /* |h8| <= 2^25; from now on fits into int32 unchanged */
    /* |h5| <= 1.01*2^24 */
    /* |h9| <= 1.71*2^59 */

    carry9 = (h9 + (1 << 24)) >> 25;
    h0 += carry9 * 19;
    h9 -= carry9 << 25;
    /* |h9| <= 2^24; from now on fits into int32 unchanged */
    /* |h0| <= 1.1*2^39 */

    carry0 = (h0 + (1 << 25)) >> 26;
    h1 += carry0;
    h0 -= carry0 << 26;
    /* |h0| <= 2^25; from now on fits into int32 unchanged */
    /* |h1| <= 1.01*2^24 */

    final List<int> h = new List<int>(10);
    h[0] = h0;
    h[1] = h1;
    h[2] = h2;
    h[3] = h3;
    h[4] = h4;
    h[5] = h5;
    h[6] = h6;
    h[7] = h7;
    h[8] = h8;
    h[9] = h9;

    return new Ed25519FieldElement(h);
  }

  /// Squares this field element and returns the result.
  ///
  /// h = this * this
  ///
  /// Preconditions:
  ///     |this| bounded by 1.65*2^26,1.65*2^25,1.65*2^26,1.65*2^25,etc.
  /// Postconditions:
  ///        |h| bounded by 1.01*2^25,1.01*2^24,1.01*2^25,1.01*2^24,etc.
  ///
  /// See multiply for discussion of implementation strategy.
  Ed25519FieldElement square() {
    return this._squareAndOptionalDouble(false);
  }

  /// Squares this field element, multiplies by two and returns the result.
  ///
  /// h = 2 * this * this
  ///
  /// Preconditions:
  ///     |this| bounded by 1.65*2^26,1.65*2^25,1.65*2^26,1.65*2^25,etc.
  /// Postconditions:
  ///        |h| bounded by 1.01*2^25,1.01*2^24,1.01*2^25,1.01*2^24,etc.
  ///
  /// See multiply for discussion of implementation strategy.
  Ed25519FieldElement squareAndDouble() {
    return this._squareAndOptionalDouble(true);
  }

  /// Invert this field element and return the result.
  ///
  /// The inverse is found via Fermat's little theorem:
  /// a^p congruent a mod p and therefore a^(p-2) congruent a^-1 mod p
  Ed25519FieldElement invert() {
    Ed25519FieldElement f0, f1;

    /// comments describe how exponent is created

    /// 2 == 2 * 1
    f0 = this.square();

    /// 9 == 9
    f1 = this._pow2to9();

    /// 11 == 9 + 2
    f0 = f0.multiply(f1);

    /// 2^252 - 2^2
    f1 = this._pow2to252sub4();

    /// 2^255 - 2^5
    for (int i = 1; i < 4; ++i) {
      f1 = f1.square();
    }

    /// 2^255 - 21
    return f1.multiply(f0);
  }

  // -------------------- private / protected functions -------------------- //

  /// Squares this field element, optionally multiplies by two and returns
  /// the result.
  ///
  /// h = 2 * this * this if dbl is true or
  /// h = this * this if dbl is false.
  ///
  /// Preconditions:
  ///     |this| bounded by 1.65*2^26,1.65*2^25,1.65*2^26,1.65*2^25,etc.
  /// Postconditions:
  ///        |h| bounded by 1.01*2^25,1.01*2^24,1.01*2^25,1.01*2^24,etc.
  ///
  /// See multiply for discussion of implementation strategy.
  Ed25519FieldElement _squareAndOptionalDouble(final bool dbl) {
    final int f0 = this._values[0];
    final int f1 = this._values[1];
    final int f2 = this._values[2];
    final int f3 = this._values[3];
    final int f4 = this._values[4];
    final int f5 = this._values[5];
    final int f6 = this._values[6];
    final int f7 = this._values[7];
    final int f8 = this._values[8];
    final int f9 = this._values[9];
    final int f0_2 = 2 * f0;
    final int f1_2 = 2 * f1;
    final int f2_2 = 2 * f2;
    final int f3_2 = 2 * f3;
    final int f4_2 = 2 * f4;
    final int f5_2 = 2 * f5;
    final int f6_2 = 2 * f6;
    final int f7_2 = 2 * f7;
    final int f5_38 = 38 * f5; /* 1.959375*2^30 */
    final int f6_19 = 19 * f6; /* 1.959375*2^30 */
    final int f7_38 = 38 * f7; /* 1.959375*2^30 */
    final int f8_19 = 19 * f8; /* 1.959375*2^30 */
    final int f9_38 = 38 * f9; /* 1.959375*2^30 */
    final int f0f0 = f0 * f0;
    final int f0f1_2 = f0_2 * f1;
    final int f0f2_2 = f0_2 * f2;
    final int f0f3_2 = f0_2 * f3;
    final int f0f4_2 = f0_2 * f4;
    final int f0f5_2 = f0_2 * f5;
    final int f0f6_2 = f0_2 * f6;
    final int f0f7_2 = f0_2 * f7;
    final int f0f8_2 = f0_2 * f8;
    final int f0f9_2 = f0_2 * f9;
    final int f1f1_2 = f1_2 * f1;
    final int f1f2_2 = f1_2 * f2;
    final int f1f3_4 = f1_2 * f3_2;
    final int f1f4_2 = f1_2 * f4;
    final int f1f5_4 = f1_2 * f5_2;
    final int f1f6_2 = f1_2 * f6;
    final int f1f7_4 = f1_2 * f7_2;
    final int f1f8_2 = f1_2 * f8;
    final int f1f9_76 = f1_2 * f9_38;
    final int f2f2 = f2 * f2;
    final int f2f3_2 = f2_2 * f3;
    final int f2f4_2 = f2_2 * f4;
    final int f2f5_2 = f2_2 * f5;
    final int f2f6_2 = f2_2 * f6;
    final int f2f7_2 = f2_2 * f7;
    final int f2f8_38 = f2_2 * f8_19;
    final int f2f9_38 = f2 * f9_38;
    final int f3f3_2 = f3_2 * f3;
    final int f3f4_2 = f3_2 * f4;
    final int f3f5_4 = f3_2 * f5_2;
    final int f3f6_2 = f3_2 * f6;
    final int f3f7_76 = f3_2 * f7_38;
    final int f3f8_38 = f3_2 * f8_19;
    final int f3f9_76 = f3_2 * f9_38;
    final int f4f4 = f4 * f4;
    final int f4f5_2 = f4_2 * f5;
    final int f4f6_38 = f4_2 * f6_19;
    final int f4f7_38 = f4 * f7_38;
    final int f4f8_38 = f4_2 * f8_19;
    final int f4f9_38 = f4 * f9_38;
    final int f5f5_38 = f5 * f5_38;
    final int f5f6_38 = f5_2 * f6_19;
    final int f5f7_76 = f5_2 * f7_38;
    final int f5f8_38 = f5_2 * f8_19;
    final int f5f9_76 = f5_2 * f9_38;
    final int f6f6_19 = f6 * f6_19;
    final int f6f7_38 = f6 * f7_38;
    final int f6f8_38 = f6_2 * f8_19;
    final int f6f9_38 = f6 * f9_38;
    final int f7f7_38 = f7 * f7_38;
    final int f7f8_38 = f7_2 * f8_19;
    final int f7f9_76 = f7_2 * f9_38;
    final int f8f8_19 = f8 * f8_19;
    final int f8f9_38 = f8 * f9_38;
    final int f9f9_38 = f9 * f9_38;
    int h0 = f0f0 + f1f9_76 + f2f8_38 + f3f7_76 + f4f6_38 + f5f5_38;
    int h1 = f0f1_2 + f2f9_38 + f3f8_38 + f4f7_38 + f5f6_38;
    int h2 = f0f2_2 + f1f1_2 + f3f9_76 + f4f8_38 + f5f7_76 + f6f6_19;
    int h3 = f0f3_2 + f1f2_2 + f4f9_38 + f5f8_38 + f6f7_38;
    int h4 = f0f4_2 + f1f3_4 + f2f2 + f5f9_76 + f6f8_38 + f7f7_38;
    int h5 = f0f5_2 + f1f4_2 + f2f3_2 + f6f9_38 + f7f8_38;
    int h6 = f0f6_2 + f1f5_4 + f2f4_2 + f3f3_2 + f7f9_76 + f8f8_19;
    int h7 = f0f7_2 + f1f6_2 + f2f5_2 + f3f4_2 + f8f9_38;
    int h8 = f0f8_2 + f1f7_4 + f2f6_2 + f3f5_4 + f4f4 + f9f9_38;
    int h9 = f0f9_2 + f1f8_2 + f2f7_2 + f3f6_2 + f4f5_2;

    if (dbl) {
      h0 += h0;
      h1 += h1;
      h2 += h2;
      h3 += h3;
      h4 += h4;
      h5 += h5;
      h6 += h6;
      h7 += h7;
      h8 += h8;
      h9 += h9;
    }

    int carry0 = (h0 + (1 << 25)) >> 26;
    h1 += carry0;
    h0 -= carry0 << 26;
    int carry4 = (h4 + (1 << 25)) >> 26;
    h5 += carry4;
    h4 -= carry4 << 26;

    final int carry1 = (h1 + (1 << 24)) >> 25;
    h2 += carry1;
    h1 -= carry1 << 25;
    final int carry5 = (h5 + (1 << 24)) >> 25;
    h6 += carry5;
    h5 -= carry5 << 25;

    final int carry2 = (h2 + (1 << 25)) >> 26;
    h3 += carry2;
    h2 -= carry2 << 26;
    final int carry6 = (h6 + (1 << 25)) >> 26;
    h7 += carry6;
    h6 -= carry6 << 26;

    final int carry3 = (h3 + (1 << 24)) >> 25;
    h4 += carry3;
    h3 -= carry3 << 25;
    final int carry7 = (h7 + (1 << 24)) >> 25;
    h8 += carry7;
    h7 -= carry7 << 25;

    carry4 = (h4 + (1 << 25)) >> 26;
    h5 += carry4;
    h4 -= carry4 << 26;
    final int carry8 = (h8 + (1 << 25)) >> 26;
    h9 += carry8;
    h8 -= carry8 << 26;

    final int carry9 = (h9 + (1 << 24)) >> 25;
    h0 += carry9 * 19;
    h9 -= carry9 << 25;

    carry0 = (h0 + (1 << 25)) >> 26;
    h1 += carry0;
    h0 -= carry0 << 26;

    final List<int> h = new List<int>(10);
    h[0] = h0;
    h[1] = h1;
    h[2] = h2;
    h[3] = h3;
    h[4] = h4;
    h[5] = h5;
    h[6] = h6;
    h[7] = h7;
    h[8] = h8;
    h[9] = h9;
    return new Ed25519FieldElement(h);
  }

  /// Computes this field element to the power of (2^9) and returns the result.
  Ed25519FieldElement _pow2to9() {
    Ed25519FieldElement f;

    /// 2 == 2 * 1
    f = this.square();

    /// 4 == 2 * 2
    f = f.square();

    /// 8 == 2 * 4
    f = f.square();

    /// 9 == 1 + 8
    return this.multiply(f);
  }

  /// Computes this field element to the power of (2^252 - 4) and returns
  /// the result.
  /// This is a helper function for calculating the square root.
  Ed25519FieldElement _pow2to252sub4() {
    Ed25519FieldElement f0, f1, f2;

    /// 2 == 2 * 1
    f0 = this.square();

    /// 9
    f1 = this._pow2to9();

    /// 11 == 9 + 2
    f0 = f0.multiply(f1);

    /// 22 == 2 * 11
    f0 = f0.square();

    /// 31 == 22 + 9
    f0 = f1.multiply(f0);

    /// 2^6 - 2^1
    f1 = f0.square();

    /// 2^10 - 2^5
    for (int i = 1; i < 5; ++i) {
      f1 = f1.square();
    }

    /// 2^10 - 2^0
    f0 = f1.multiply(f0);

    /// 2^11 - 2^1
    f1 = f0.square();

    /// 2^20 - 2^10
    for (int i = 1; i < 10; ++i) {
      f1 = f1.square();
    }

    /// 2^20 - 2^0
    f1 = f1.multiply(f0);

    /// 2^21 - 2^1
    f2 = f1.square();

    /// 2^40 - 2^20
    for (int i = 1; i < 20; ++i) {
      f2 = f2.square();
    }

    /// 2^40 - 2^0
    f1 = f2.multiply(f1);

    /// 2^41 - 2^1
    f1 = f1.square();

    /// 2^50 - 2^10
    for (int i = 1; i < 10; ++i) {
      f1 = f1.square();
    }

    /// 2^50 - 2^0
    f0 = f1.multiply(f0);

    /// 2^51 - 2^1
    f1 = f0.square();

    /// 2^100 - 2^50
    for (int i = 1; i < 50; ++i) {
      f1 = f1.square();
    }

    /// 2^100 - 2^0
    f1 = f1.multiply(f0);

    /// 2^101 - 2^1
    f2 = f1.square();

    /// 2^200 - 2^100
    for (int i = 1; i < 100; ++i) {
      f2 = f2.square();
    }

    /// 2^200 - 2^0
    f1 = f2.multiply(f1);

    /// 2^201 - 2^1
    f1 = f1.square();

    /// 2^250 - 2^50
    for (int i = 1; i < 50; ++i) {
      f1 = f1.square();
    }

    /// 2^250 - 2^0
    f0 = f1.multiply(f0);

    /// 2^251 - 2^1
    f0 = f0.square();

    /// 2^252 - 2^2
    return f0.square();
  }

  /// Reduce this field element modulo field size p = 2^255 - 19 and return
  /// the result.
  ///
  /// The idea for the modulo p reduction algorithm is as follows:
  ///
  /// {@code
  /// Assumption:
  /// p = 2^255 - 19
  /// h = h0 + 2^25 * h1 + 2^(26+25) * h2 + ... + 2^230 * h9
  /// where 0 <= |hi| < 2^27 for all i=0,...,9.
  /// h congruent r modulo p, i.e. h = r + q * p
  /// for some suitable 0 <= r < p and an integer q.
  ///
  /// Then q = [2^-255 * (h + 19 * 2^-25 * h9 + 1/2)] where [x] = floor(x).
  ///
  /// Proof:
  /// We begin with some very raw estimation for the bounds of some expressions:
  ///     |h| < 2^230 * 2^30 = 2^260 ==> |r + q * p| < 2^260 ==> |q| < 2^10.
  ///         ==> -1/4 <= a := 19^2 * 2^-255 * q < 1/4.
  ///     |h - 2^230 * h9| = |h0 + ... + 2^204 * h8| < 2^204 * 2^30 = 2^234.
  ///         ==> -1/4 <= b := 19 * 2^-255 * (h - 2^230 * h9) < 1/4
  /// Therefore 0 < 1/2 - a - b < 1.
  /// Set x := r + 19 * 2^-255 * r + 1/2 - a - b then
  ///     0 <= x < 255 - 20 + 19 + 1 = 2^255 ==> 0 <= 2^-255 * x < 1.
  ///     Since q is an integer we have
  ///     [q + 2^-255 * x] = q        (1)
  /// Have a closer look at x:
  ///     x = h - q * (2^255 - 19) + 19 * 2^-255 * (h - q * (2^255 - 19))
  ///     + 1/2 - 19^2 * 2^-255 * q - 19 * 2^-255 * (h - 2^230 * h9)
  ///       = h - q * 2^255 + 19 * q + 19 * 2^-255 * h - 19 * q + 19^2
  ///       * 2^-255 * q + 1/2 - 19^2 * 2^-255 * q - 19 * 2^-255 * h + 19
  ///       * 2^-25 * h9
  ///       = h + 19 * 2^-25 * h9 + 1/2 - q^255.
  ///
  /// Inserting the expression for x into (1) we get the desired expression
  /// for q.
  /// }
  Ed25519FieldElement _modP() {
    int h0 = this._values[0];
    int h1 = this._values[1];
    int h2 = this._values[2];
    int h3 = this._values[3];
    int h4 = this._values[4];
    int h5 = this._values[5];
    int h6 = this._values[6];
    int h7 = this._values[7];
    int h8 = this._values[8];
    int h9 = this._values[9];
    int q;

    /// Calculate q
    q = (19 * h9 + (1 << 24)) >> 25;
    q = (h0 + q) >> 26;
    q = (h1 + q) >> 25;
    q = (h2 + q) >> 26;
    q = (h3 + q) >> 25;
    q = (h4 + q) >> 26;
    q = (h5 + q) >> 25;
    q = (h6 + q) >> 26;
    q = (h7 + q) >> 25;
    q = (h8 + q) >> 26;
    q = (h9 + q) >> 25;

    /// r = h - q * p = h - 2^255 * q + 19 * q
    /// First add 19 * q then discard the bit 255
    h0 += 19 * q;

    final int carry0 = h0 >> 26;
    h1 += carry0;
    h0 -= carry0 << 26;
    final int carry1 = h1 >> 25;
    h2 += carry1;
    h1 -= carry1 << 25;
    final int carry2 = h2 >> 26;
    h3 += carry2;
    h2 -= carry2 << 26;
    final int carry3 = h3 >> 25;
    h4 += carry3;
    h3 -= carry3 << 25;
    final int carry4 = h4 >> 26;
    h5 += carry4;
    h4 -= carry4 << 26;
    final int carry5 = h5 >> 25;
    h6 += carry5;
    h5 -= carry5 << 25;
    final int carry6 = h6 >> 26;
    h7 += carry6;
    h6 -= carry6 << 26;
    final int carry7 = h7 >> 25;
    h8 += carry7;
    h7 -= carry7 << 25;
    final int carry8 = h8 >> 26;
    h9 += carry8;
    h8 -= carry8 << 26;
    final int carry9 = h9 >> 25;
    h9 -= carry9 << 25;

    final List<int> h = new List<int>(10);
    h[0] = h0;
    h[1] = h1;
    h[2] = h2;
    h[3] = h3;
    h[4] = h4;
    h[5] = h5;
    h[6] = h6;
    h[7] = h7;
    h[8] = h8;
    h[9] = h9;

    return new Ed25519FieldElement(h);
  }
}
