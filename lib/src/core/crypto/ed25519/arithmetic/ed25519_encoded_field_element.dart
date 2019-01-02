part of nem2_sdk_dart.core.crypto.ed25519.arithmetic;

/// Represents a field element of the finite field with p=2^255-19 elements.
/// The value of the field element is held in 2^8 bit representation. such as
/// in a byte array. The length of the array must be 32 or 64.
class Ed25519EncodedFieldElement {
  final Uint8List _zero;
  final Uint8List _values;

  Ed25519EncodedFieldElement._(this._values, this._zero);

  factory Ed25519EncodedFieldElement(final Uint8List values) {
    if (values == null) {
      throw new ArgumentError("Argument must not be null");
    }

    /// replace null values
    ArrayUtils.replaceNullWithZero(values);

    if (values.length == 32) {
      return new Ed25519EncodedFieldElement._(values, Ed25519Field.ZERO_SHORT);
    }

    if (values.length == 64) {
      return new Ed25519EncodedFieldElement._(values, Ed25519Field.ZERO_LONG);
    }

    throw new ArgumentError("Invalid 2^8 bit representation.");
  }

  /// Returns the underlying byte array
  Uint8List getRaw() {
    return this._values;
  }

  /// Returns true if this is in {1,3,5,...,q-2}
  /// Returns false if this is in {0,2,4,...,q-1}
  ///
  /// Preconditions:
  /// |x| bounded by 1.1*2^26,1.1*2^25,1.1*2^26,1.1*2^25,etc.
  bool isNegative() {
    return (this._values[0] & 1) != 0;
  }

  /// Gets a value indicating whether or not the field element is non-zero.
  bool isNonZero() {
    return 0 == ArrayUtils.isEqualConstantTime(this._values, this._zero);
  }

  @override
  int get hashCode {
    return this._values.hashCode;
  }

  @override
  bool operator ==(final o) {
    return (o is Ed25519EncodedFieldElement) &&
        (1 == ArrayUtils.isEqualConstantTime(this._values, o.getRaw()));
  }

  @override
  String toString() {
    return hex.encode(this._values);
  }

  // -------------------- math operations and functions -------------------- //

  /// Decodes this encoded (32 byte) representation to a field element in its
  /// 10 byte 2^25.5 representation. The most significant bit is discarded.
  Ed25519FieldElement decode() {
    int h0 = _fourBytesToInt(this._values, 0);
    int h1 = _threeBytesToInt(this._values, 4) << 6;
    int h2 = _threeBytesToInt(this._values, 7) << 5;
    int h3 = _threeBytesToInt(this._values, 10) << 3;
    int h4 = _threeBytesToInt(this._values, 13) << 2;
    int h5 = _fourBytesToInt(this._values, 16);
    int h6 = _threeBytesToInt(this._values, 20) << 7;
    int h7 = _threeBytesToInt(this._values, 23) << 5;
    int h8 = _threeBytesToInt(this._values, 26) << 4;
    int h9 = (_threeBytesToInt(this._values, 29) & 0x7FFFFF) << 2;

    /// Remember: 2^255 congruent 19 modulo p
    final int carry9 = (h9 + (1 << 24)) >> 25;
    h0 += carry9 * 19;
    h9 -= carry9 << 25;
    final int carry1 = (h1 + (1 << 24)) >> 25;
    h2 += carry1;
    h1 -= carry1 << 25;
    final int carry3 = (h3 + (1 << 24)) >> 25;
    h4 += carry3;
    h3 -= carry3 << 25;
    final int carry5 = (h5 + (1 << 24)) >> 25;
    h6 += carry5;
    h5 -= carry5 << 25;
    final int carry7 = (h7 + (1 << 24)) >> 25;
    h8 += carry7;
    h7 -= carry7 << 25;

    final int carry0 = (h0 + (1 << 25)) >> 26;
    h1 += carry0;
    h0 -= carry0 << 26;
    final int carry2 = (h2 + (1 << 25)) >> 26;
    h3 += carry2;
    h2 -= carry2 << 26;
    final int carry4 = (h4 + (1 << 25)) >> 26;
    h5 += carry4;
    h4 -= carry4 << 26;
    final int carry6 = (h6 + (1 << 25)) >> 26;
    h7 += carry6;
    h6 -= carry6 << 26;
    final int carry8 = (h8 + (1 << 25)) >> 26;
    h9 += carry8;
    h8 -= carry8 << 26;

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

  /// Reduces this encoded field element (64 bytes) modulo the group order q.
  Ed25519EncodedFieldElement modQ() {
    /// s0, ..., s22 have 21 bits, s23 has 29 bits
    int s0 = 0x1FFFFF & _threeBytesToInt(this._values, 0);
    int s1 = 0x1FFFFF & (_fourBytesToInt(this._values, 2) >> 5);
    int s2 = 0x1FFFFF & (_threeBytesToInt(this._values, 5) >> 2);
    int s3 = 0x1FFFFF & (_fourBytesToInt(this._values, 7) >> 7);
    int s4 = 0x1FFFFF & (_fourBytesToInt(this._values, 10) >> 4);
    int s5 = 0x1FFFFF & (_threeBytesToInt(this._values, 13) >> 1);
    int s6 = 0x1FFFFF & (_fourBytesToInt(this._values, 15) >> 6);
    int s7 = 0x1FFFFF & (_threeBytesToInt(this._values, 18) >> 3);
    int s8 = 0x1FFFFF & _threeBytesToInt(this._values, 21);
    int s9 = 0x1FFFFF & (_fourBytesToInt(this._values, 23) >> 5);
    int s10 = 0x1FFFFF & (_threeBytesToInt(this._values, 26) >> 2);
    int s11 = 0x1FFFFF & (_fourBytesToInt(this._values, 28) >> 7);
    int s12 = 0x1FFFFF & (_fourBytesToInt(this._values, 31) >> 4);
    int s13 = 0x1FFFFF & (_threeBytesToInt(this._values, 34) >> 1);
    int s14 = 0x1FFFFF & (_fourBytesToInt(this._values, 36) >> 6);
    int s15 = 0x1FFFFF & (_threeBytesToInt(this._values, 39) >> 3);
    int s16 = 0x1FFFFF & _threeBytesToInt(this._values, 42);
    int s17 = 0x1FFFFF & (_fourBytesToInt(this._values, 44) >> 5);
    final int s18 = 0x1FFFFF & (_threeBytesToInt(this._values, 47) >> 2);
    final int s19 = 0x1FFFFF & (_fourBytesToInt(this._values, 49) >> 7);
    final int s20 = 0x1FFFFF & (_fourBytesToInt(this._values, 52) >> 4);
    final int s21 = 0x1FFFFF & (_threeBytesToInt(this._values, 55) >> 1);
    final int s22 = 0x1FFFFF & (_fourBytesToInt(this._values, 57) >> 6);
    final int s23 = (_fourBytesToInt(this._values, 60) >> 3);
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
    int carry10;
    int carry11;

    /// Lots of magic numbers :)
    ///
    /// To understand what's going on below, note that
    ///
    /// (1) q = 2^252 + q0 where q0 = 27742317777372353535851937790883648493.
    /// (2) s11 is the coefficient of 2^(11*21),
    ///     s23 is the coefficient of 2^(^23*21) and 2^252 = 2^((23-11) * 21)).
    /// (3) 2^252 congruent -q0 modulo q.
    /// (4) -q0 = 666643 * 2^0 + 470296 * 2^21 + 654183 * 2^(2*21) - 997805
    ///     * 2^(3*21) + 136657 * 2^(4*21) - 683901 * 2^(5*21)
    ///
    /// Thus:
    /// s23 * 2^(23*11) = s23 * 2^(12*21) * 2^(11*21)
    /// = s3 * 2^252 * 2^(11*21) congruent
    /// s23 * (666643 * 2^0 + 470296 * 2^21 + 654183 * 2^(2*21) - 997805
    /// * 2^(3*21) + 136657 * 2^(4*21) - 683901 * 2^(5*21))
    /// * 2^(11*21) modulo q =
    /// s23 * (666643 * 2^(11*21) + 470296 * 2^(12*21) + 654183 * 2^(13*21)
    /// - 997805 * 2^(14*21) + 136657 * 2^(15*21) - 683901 * 2^(16*21)).
    ///
    /// The same procedure is then applied for s22,...,s18.
    s11 += s23 * 666643;
    s12 += s23 * 470296;
    s13 += s23 * 654183;
    s14 -= s23 * 997805;
    s15 += s23 * 136657;
    s16 -= s23 * 683901;

    s10 += s22 * 666643;
    s11 += s22 * 470296;
    s12 += s22 * 654183;
    s13 -= s22 * 997805;
    s14 += s22 * 136657;
    s15 -= s22 * 683901;

    s9 += s21 * 666643;
    s10 += s21 * 470296;
    s11 += s21 * 654183;
    s12 -= s21 * 997805;
    s13 += s21 * 136657;
    s14 -= s21 * 683901;

    s8 += s20 * 666643;
    s9 += s20 * 470296;
    s10 += s20 * 654183;
    s11 -= s20 * 997805;
    s12 += s20 * 136657;
    s13 -= s20 * 683901;

    s7 += s19 * 666643;
    s8 += s19 * 470296;
    s9 += s19 * 654183;
    s10 -= s19 * 997805;
    s11 += s19 * 136657;
    s12 -= s19 * 683901;

    s6 += s18 * 666643;
    s7 += s18 * 470296;
    s8 += s18 * 654183;
    s9 -= s18 * 997805;
    s10 += s18 * 136657;
    s11 -= s18 * 683901;

    /// Time to reduce the coefficient in order not to get an overflow.
    carry6 = (s6 + (1 << 20)) >> 21;
    s7 += carry6;
    s6 -= carry6 << 21;
    carry8 = (s8 + (1 << 20)) >> 21;
    s9 += carry8;
    s8 -= carry8 << 21;
    carry10 = (s10 + (1 << 20)) >> 21;
    s11 += carry10;
    s10 -= carry10 << 21;
    final int carry12 = (s12 + (1 << 20)) >> 21;
    s13 += carry12;
    s12 -= carry12 << 21;
    final int carry14 = (s14 + (1 << 20)) >> 21;
    s15 += carry14;
    s14 -= carry14 << 21;
    final int carry16 = (s16 + (1 << 20)) >> 21;
    s17 += carry16;
    s16 -= carry16 << 21;

    carry7 = (s7 + (1 << 20)) >> 21;
    s8 += carry7;
    s7 -= carry7 << 21;
    carry9 = (s9 + (1 << 20)) >> 21;
    s10 += carry9;
    s9 -= carry9 << 21;
    carry11 = (s11 + (1 << 20)) >> 21;
    s12 += carry11;
    s11 -= carry11 << 21;
    final int carry13 = (s13 + (1 << 20)) >> 21;
    s14 += carry13;
    s13 -= carry13 << 21;
    final int carry15 = (s15 + (1 << 20)) >> 21;
    s16 += carry15;
    s15 -= carry15 << 21;

    /// Continue with above procedure.
    s5 += s17 * 666643;
    s6 += s17 * 470296;
    s7 += s17 * 654183;
    s8 -= s17 * 997805;
    s9 += s17 * 136657;
    s10 -= s17 * 683901;

    s4 += s16 * 666643;
    s5 += s16 * 470296;
    s6 += s16 * 654183;
    s7 -= s16 * 997805;
    s8 += s16 * 136657;
    s9 -= s16 * 683901;

    s3 += s15 * 666643;
    s4 += s15 * 470296;
    s5 += s15 * 654183;
    s6 -= s15 * 997805;
    s7 += s15 * 136657;
    s8 -= s15 * 683901;

    s2 += s14 * 666643;
    s3 += s14 * 470296;
    s4 += s14 * 654183;
    s5 -= s14 * 997805;
    s6 += s14 * 136657;
    s7 -= s14 * 683901;

    s1 += s13 * 666643;
    s2 += s13 * 470296;
    s3 += s13 * 654183;
    s4 -= s13 * 997805;
    s5 += s13 * 136657;
    s6 -= s13 * 683901;

    s0 += s12 * 666643;
    s1 += s12 * 470296;
    s2 += s12 * 654183;
    s3 -= s12 * 997805;
    s4 += s12 * 136657;
    s5 -= s12 * 683901;
    s12 = 0;

    /// Reduce coefficients again.
    carry0 = (s0 + (1 << 20)) >> 21;
    s1 += carry0;
    s0 -= carry0 << 21;
    carry2 = (s2 + (1 << 20)) >> 21;
    s3 += carry2;
    s2 -= carry2 << 21;
    carry4 = (s4 + (1 << 20)) >> 21;
    s5 += carry4;
    s4 -= carry4 << 21;
    carry6 = (s6 + (1 << 20)) >> 21;
    s7 += carry6;
    s6 -= carry6 << 21;
    carry8 = (s8 + (1 << 20)) >> 21;
    s9 += carry8;
    s8 -= carry8 << 21;
    carry10 = (s10 + (1 << 20)) >> 21;
    s11 += carry10;
    s10 -= carry10 << 21;

    carry1 = (s1 + (1 << 20)) >> 21;
    s2 += carry1;
    s1 -= carry1 << 21;
    carry3 = (s3 + (1 << 20)) >> 21;
    s4 += carry3;
    s3 -= carry3 << 21;
    carry5 = (s5 + (1 << 20)) >> 21;
    s6 += carry5;
    s5 -= carry5 << 21;
    carry7 = (s7 + (1 << 20)) >> 21;
    s8 += carry7;
    s7 -= carry7 << 21;
    carry9 = (s9 + (1 << 20)) >> 21;
    s10 += carry9;
    s9 -= carry9 << 21;
    carry11 = (s11 + (1 << 20)) >> 21;
    s12 += carry11;
    s11 -= carry11 << 21;

    s0 += s12 * 666643;
    s1 += s12 * 470296;
    s2 += s12 * 654183;
    s3 -= s12 * 997805;
    s4 += s12 * 136657;
    s5 -= s12 * 683901;
    s12 = 0;

    carry0 = s0 >> 21;
    s1 += carry0;
    s0 -= carry0 << 21;
    carry1 = s1 >> 21;
    s2 += carry1;
    s1 -= carry1 << 21;
    carry2 = s2 >> 21;
    s3 += carry2;
    s2 -= carry2 << 21;
    carry3 = s3 >> 21;
    s4 += carry3;
    s3 -= carry3 << 21;
    carry4 = s4 >> 21;
    s5 += carry4;
    s4 -= carry4 << 21;
    carry5 = s5 >> 21;
    s6 += carry5;
    s5 -= carry5 << 21;
    carry6 = s6 >> 21;
    s7 += carry6;
    s6 -= carry6 << 21;
    carry7 = s7 >> 21;
    s8 += carry7;
    s7 -= carry7 << 21;
    carry8 = s8 >> 21;
    s9 += carry8;
    s8 -= carry8 << 21;
    carry9 = s9 >> 21;
    s10 += carry9;
    s9 -= carry9 << 21;
    carry10 = s10 >> 21;
    s11 += carry10;
    s10 -= carry10 << 21;
    carry11 = s11 >> 21;
    s12 += carry11;
    s11 -= carry11 << 21;

    s0 += s12 * 666643;
    s1 += s12 * 470296;
    s2 += s12 * 654183;
    s3 -= s12 * 997805;
    s4 += s12 * 136657;
    s5 -= s12 * 683901;

    carry0 = s0 >> 21;
    s1 += carry0;
    s0 -= carry0 << 21;
    carry1 = s1 >> 21;
    s2 += carry1;
    s1 -= carry1 << 21;
    carry2 = s2 >> 21;
    s3 += carry2;
    s2 -= carry2 << 21;
    carry3 = s3 >> 21;
    s4 += carry3;
    s3 -= carry3 << 21;
    carry4 = s4 >> 21;
    s5 += carry4;
    s4 -= carry4 << 21;
    carry5 = s5 >> 21;
    s6 += carry5;
    s5 -= carry5 << 21;
    carry6 = s6 >> 21;
    s7 += carry6;
    s6 -= carry6 << 21;
    carry7 = s7 >> 21;
    s8 += carry7;
    s7 -= carry7 << 21;
    carry8 = s8 >> 21;
    s9 += carry8;
    s8 -= carry8 << 21;
    carry9 = s9 >> 21;
    s10 += carry9;
    s9 -= carry9 << 21;
    carry10 = s10 >> 21;
    s11 += carry10;
    s10 -= carry10 << 21;

    // s0, ..., s11 got 21 bits each.
    final Uint8List result = new Uint8List(32);
    result[0] = (s0);
    result[1] = (s0 >> 8);
    result[2] = ((s0 >> 16) | (s1 << 5));
    result[3] = (s1 >> 3);
    result[4] = (s1 >> 11);
    result[5] = ((s1 >> 19) | (s2 << 2));
    result[6] = (s2 >> 6);
    result[7] = ((s2 >> 14) | (s3 << 7));
    result[8] = (s3 >> 1);
    result[9] = (s3 >> 9);
    result[10] = ((s3 >> 17) | (s4 << 4));
    result[11] = (s4 >> 4);
    result[12] = (s4 >> 12);
    result[13] = ((s4 >> 20) | (s5 << 1));
    result[14] = (s5 >> 7);
    result[15] = ((s5 >> 15) | (s6 << 6));
    result[16] = (s6 >> 2);
    result[17] = (s6 >> 10);
    result[18] = ((s6 >> 18) | (s7 << 3));
    result[19] = (s7 >> 5);
    result[20] = (s7 >> 13);
    result[21] = (s8);
    result[22] = (s8 >> 8);
    result[23] = ((s8 >> 16) | (s9 << 5));
    result[24] = (s9 >> 3);
    result[25] = (s9 >> 11);
    result[26] = ((s9 >> 19) | (s10 << 2));
    result[27] = (s10 >> 6);
    result[28] = ((s10 >> 14) | (s11 << 7));
    result[29] = (s11 >> 1);
    result[30] = (s11 >> 9);
    result[31] = (s11 >> 17);

    return new Ed25519EncodedFieldElement(result);
  }

  /// Multiplies this encoded field element with another and adds a third.
  /// The result is reduced modulo the group order.
  ///
  /// See the comments in the method modQ() for an explanation of the algorithm.
  Ed25519EncodedFieldElement multiplyAndAddModQ(
      final Ed25519EncodedFieldElement b, final Ed25519EncodedFieldElement c) {
    final int a0 = 0x1FFFFF & _threeBytesToInt(this._values, 0);
    final int a1 = 0x1FFFFF & (_fourBytesToInt(this._values, 2) >> 5);
    final int a2 = 0x1FFFFF & (_threeBytesToInt(this._values, 5) >> 2);
    final int a3 = 0x1FFFFF & (_fourBytesToInt(this._values, 7) >> 7);
    final int a4 = 0x1FFFFF & (_fourBytesToInt(this._values, 10) >> 4);
    final int a5 = 0x1FFFFF & (_threeBytesToInt(this._values, 13) >> 1);
    final int a6 = 0x1FFFFF & (_fourBytesToInt(this._values, 15) >> 6);
    final int a7 = 0x1FFFFF & (_threeBytesToInt(this._values, 18) >> 3);
    final int a8 = 0x1FFFFF & _threeBytesToInt(this._values, 21);
    final int a9 = 0x1FFFFF & (_fourBytesToInt(this._values, 23) >> 5);
    final int a10 = 0x1FFFFF & (_threeBytesToInt(this._values, 26) >> 2);
    final int a11 = (_fourBytesToInt(this._values, 28) >> 7);
    final int b0 = 0x1FFFFF & _threeBytesToInt(b.getRaw(), 0);
    final int b1 = 0x1FFFFF & (_fourBytesToInt(b.getRaw(), 2) >> 5);
    final int b2 = 0x1FFFFF & (_threeBytesToInt(b.getRaw(), 5) >> 2);
    final int b3 = 0x1FFFFF & (_fourBytesToInt(b.getRaw(), 7) >> 7);
    final int b4 = 0x1FFFFF & (_fourBytesToInt(b.getRaw(), 10) >> 4);
    final int b5 = 0x1FFFFF & (_threeBytesToInt(b.getRaw(), 13) >> 1);
    final int b6 = 0x1FFFFF & (_fourBytesToInt(b.getRaw(), 15) >> 6);
    final int b7 = 0x1FFFFF & (_threeBytesToInt(b.getRaw(), 18) >> 3);
    final int b8 = 0x1FFFFF & _threeBytesToInt(b.getRaw(), 21);
    final int b9 = 0x1FFFFF & (_fourBytesToInt(b.getRaw(), 23) >> 5);
    final int b10 = 0x1FFFFF & (_threeBytesToInt(b.getRaw(), 26) >> 2);
    final int b11 = (_fourBytesToInt(b.getRaw(), 28) >> 7);
    final int c0 = 0x1FFFFF & _threeBytesToInt(c.getRaw(), 0);
    final int c1 = 0x1FFFFF & (_fourBytesToInt(c.getRaw(), 2) >> 5);
    final int c2 = 0x1FFFFF & (_threeBytesToInt(c.getRaw(), 5) >> 2);
    final int c3 = 0x1FFFFF & (_fourBytesToInt(c.getRaw(), 7) >> 7);
    final int c4 = 0x1FFFFF & (_fourBytesToInt(c.getRaw(), 10) >> 4);
    final int c5 = 0x1FFFFF & (_threeBytesToInt(c.getRaw(), 13) >> 1);
    final int c6 = 0x1FFFFF & (_fourBytesToInt(c.getRaw(), 15) >> 6);
    final int c7 = 0x1FFFFF & (_threeBytesToInt(c.getRaw(), 18) >> 3);
    final int c8 = 0x1FFFFF & _threeBytesToInt(c.getRaw(), 21);
    final int c9 = 0x1FFFFF & (_fourBytesToInt(c.getRaw(), 23) >> 5);
    final int c10 = 0x1FFFFF & (_threeBytesToInt(c.getRaw(), 26) >> 2);
    final int c11 = (_fourBytesToInt(c.getRaw(), 28) >> 7);
    int s0;
    int s1;
    int s2;
    int s3;
    int s4;
    int s5;
    int s6;
    int s7;
    int s8;
    int s9;
    int s10;
    int s11;
    int s12;
    int s13;
    int s14;
    int s15;
    int s16;
    int s17;
    int s18;
    int s19;
    int s20;
    int s21;
    int s22;
    int s23;
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
    int carry10;
    int carry11;
    int carry12;
    int carry13;
    int carry14;
    int carry15;
    int carry16;

    s0 = c0 + a0 * b0;
    s1 = c1 + a0 * b1 + a1 * b0;
    s2 = c2 + a0 * b2 + a1 * b1 + a2 * b0;
    s3 = c3 + a0 * b3 + a1 * b2 + a2 * b1 + a3 * b0;
    s4 = c4 + a0 * b4 + a1 * b3 + a2 * b2 + a3 * b1 + a4 * b0;
    s5 = c5 + a0 * b5 + a1 * b4 + a2 * b3 + a3 * b2 + a4 * b1 + a5 * b0;
    s6 = c6 +
        a0 * b6 +
        a1 * b5 +
        a2 * b4 +
        a3 * b3 +
        a4 * b2 +
        a5 * b1 +
        a6 * b0;
    s7 = c7 +
        a0 * b7 +
        a1 * b6 +
        a2 * b5 +
        a3 * b4 +
        a4 * b3 +
        a5 * b2 +
        a6 * b1 +
        a7 * b0;
    s8 = c8 +
        a0 * b8 +
        a1 * b7 +
        a2 * b6 +
        a3 * b5 +
        a4 * b4 +
        a5 * b3 +
        a6 * b2 +
        a7 * b1 +
        a8 * b0;
    s9 = c9 +
        a0 * b9 +
        a1 * b8 +
        a2 * b7 +
        a3 * b6 +
        a4 * b5 +
        a5 * b4 +
        a6 * b3 +
        a7 * b2 +
        a8 * b1 +
        a9 * b0;
    s10 = c10 +
        a0 * b10 +
        a1 * b9 +
        a2 * b8 +
        a3 * b7 +
        a4 * b6 +
        a5 * b5 +
        a6 * b4 +
        a7 * b3 +
        a8 * b2 +
        a9 * b1 +
        a10 * b0;
    s11 = c11 +
        a0 * b11 +
        a1 * b10 +
        a2 * b9 +
        a3 * b8 +
        a4 * b7 +
        a5 * b6 +
        a6 * b5 +
        a7 * b4 +
        a8 * b3 +
        a9 * b2 +
        a10 * b1 +
        a11 * b0;
    s12 = a1 * b11 +
        a2 * b10 +
        a3 * b9 +
        a4 * b8 +
        a5 * b7 +
        a6 * b6 +
        a7 * b5 +
        a8 * b4 +
        a9 * b3 +
        a10 * b2 +
        a11 * b1;
    s13 = a2 * b11 +
        a3 * b10 +
        a4 * b9 +
        a5 * b8 +
        a6 * b7 +
        a7 * b6 +
        a8 * b5 +
        a9 * b4 +
        a10 * b3 +
        a11 * b2;
    s14 = a3 * b11 +
        a4 * b10 +
        a5 * b9 +
        a6 * b8 +
        a7 * b7 +
        a8 * b6 +
        a9 * b5 +
        a10 * b4 +
        a11 * b3;
    s15 = a4 * b11 +
        a5 * b10 +
        a6 * b9 +
        a7 * b8 +
        a8 * b7 +
        a9 * b6 +
        a10 * b5 +
        a11 * b4;
    s16 =
        a5 * b11 + a6 * b10 + a7 * b9 + a8 * b8 + a9 * b7 + a10 * b6 + a11 * b5;
    s17 = a6 * b11 + a7 * b10 + a8 * b9 + a9 * b8 + a10 * b7 + a11 * b6;
    s18 = a7 * b11 + a8 * b10 + a9 * b9 + a10 * b8 + a11 * b7;
    s19 = a8 * b11 + a9 * b10 + a10 * b9 + a11 * b8;
    s20 = a9 * b11 + a10 * b10 + a11 * b9;
    s21 = a10 * b11 + a11 * b10;
    s22 = a11 * b11;
    s23 = 0;

    carry0 = (s0 + (1 << 20)) >> 21;
    s1 += carry0;
    s0 -= carry0 << 21;
    carry2 = (s2 + (1 << 20)) >> 21;
    s3 += carry2;
    s2 -= carry2 << 21;
    carry4 = (s4 + (1 << 20)) >> 21;
    s5 += carry4;
    s4 -= carry4 << 21;
    carry6 = (s6 + (1 << 20)) >> 21;
    s7 += carry6;
    s6 -= carry6 << 21;
    carry8 = (s8 + (1 << 20)) >> 21;
    s9 += carry8;
    s8 -= carry8 << 21;
    carry10 = (s10 + (1 << 20)) >> 21;
    s11 += carry10;
    s10 -= carry10 << 21;
    carry12 = (s12 + (1 << 20)) >> 21;
    s13 += carry12;
    s12 -= carry12 << 21;
    carry14 = (s14 + (1 << 20)) >> 21;
    s15 += carry14;
    s14 -= carry14 << 21;
    carry16 = (s16 + (1 << 20)) >> 21;
    s17 += carry16;
    s16 -= carry16 << 21;
    final int carry18 = (s18 + (1 << 20)) >> 21;
    s19 += carry18;
    s18 -= carry18 << 21;
    final int carry20 = (s20 + (1 << 20)) >> 21;
    s21 += carry20;
    s20 -= carry20 << 21;
    final int carry22 = (s22 + (1 << 20)) >> 21;
    s23 += carry22;
    s22 -= carry22 << 21;

    carry1 = (s1 + (1 << 20)) >> 21;
    s2 += carry1;
    s1 -= carry1 << 21;
    carry3 = (s3 + (1 << 20)) >> 21;
    s4 += carry3;
    s3 -= carry3 << 21;
    carry5 = (s5 + (1 << 20)) >> 21;
    s6 += carry5;
    s5 -= carry5 << 21;
    carry7 = (s7 + (1 << 20)) >> 21;
    s8 += carry7;
    s7 -= carry7 << 21;
    carry9 = (s9 + (1 << 20)) >> 21;
    s10 += carry9;
    s9 -= carry9 << 21;
    carry11 = (s11 + (1 << 20)) >> 21;
    s12 += carry11;
    s11 -= carry11 << 21;
    carry13 = (s13 + (1 << 20)) >> 21;
    s14 += carry13;
    s13 -= carry13 << 21;
    carry15 = (s15 + (1 << 20)) >> 21;
    s16 += carry15;
    s15 -= carry15 << 21;
    final int carry17 = (s17 + (1 << 20)) >> 21;
    s18 += carry17;
    s17 -= carry17 << 21;
    final int carry19 = (s19 + (1 << 20)) >> 21;
    s20 += carry19;
    s19 -= carry19 << 21;
    final int carry21 = (s21 + (1 << 20)) >> 21;
    s22 += carry21;
    s21 -= carry21 << 21;

    s11 += s23 * 666643;
    s12 += s23 * 470296;
    s13 += s23 * 654183;
    s14 -= s23 * 997805;
    s15 += s23 * 136657;
    s16 -= s23 * 683901;

    s10 += s22 * 666643;
    s11 += s22 * 470296;
    s12 += s22 * 654183;
    s13 -= s22 * 997805;
    s14 += s22 * 136657;
    s15 -= s22 * 683901;

    s9 += s21 * 666643;
    s10 += s21 * 470296;
    s11 += s21 * 654183;
    s12 -= s21 * 997805;
    s13 += s21 * 136657;
    s14 -= s21 * 683901;

    s8 += s20 * 666643;
    s9 += s20 * 470296;
    s10 += s20 * 654183;
    s11 -= s20 * 997805;
    s12 += s20 * 136657;
    s13 -= s20 * 683901;

    s7 += s19 * 666643;
    s8 += s19 * 470296;
    s9 += s19 * 654183;
    s10 -= s19 * 997805;
    s11 += s19 * 136657;
    s12 -= s19 * 683901;

    s6 += s18 * 666643;
    s7 += s18 * 470296;
    s8 += s18 * 654183;
    s9 -= s18 * 997805;
    s10 += s18 * 136657;
    s11 -= s18 * 683901;

    carry6 = (s6 + (1 << 20)) >> 21;
    s7 += carry6;
    s6 -= carry6 << 21;
    carry8 = (s8 + (1 << 20)) >> 21;
    s9 += carry8;
    s8 -= carry8 << 21;
    carry10 = (s10 + (1 << 20)) >> 21;
    s11 += carry10;
    s10 -= carry10 << 21;
    carry12 = (s12 + (1 << 20)) >> 21;
    s13 += carry12;
    s12 -= carry12 << 21;
    carry14 = (s14 + (1 << 20)) >> 21;
    s15 += carry14;
    s14 -= carry14 << 21;
    carry16 = (s16 + (1 << 20)) >> 21;
    s17 += carry16;
    s16 -= carry16 << 21;

    carry7 = (s7 + (1 << 20)) >> 21;
    s8 += carry7;
    s7 -= carry7 << 21;
    carry9 = (s9 + (1 << 20)) >> 21;
    s10 += carry9;
    s9 -= carry9 << 21;
    carry11 = (s11 + (1 << 20)) >> 21;
    s12 += carry11;
    s11 -= carry11 << 21;
    carry13 = (s13 + (1 << 20)) >> 21;
    s14 += carry13;
    s13 -= carry13 << 21;
    carry15 = (s15 + (1 << 20)) >> 21;
    s16 += carry15;
    s15 -= carry15 << 21;

    s5 += s17 * 666643;
    s6 += s17 * 470296;
    s7 += s17 * 654183;
    s8 -= s17 * 997805;
    s9 += s17 * 136657;
    s10 -= s17 * 683901;

    s4 += s16 * 666643;
    s5 += s16 * 470296;
    s6 += s16 * 654183;
    s7 -= s16 * 997805;
    s8 += s16 * 136657;
    s9 -= s16 * 683901;

    s3 += s15 * 666643;
    s4 += s15 * 470296;
    s5 += s15 * 654183;
    s6 -= s15 * 997805;
    s7 += s15 * 136657;
    s8 -= s15 * 683901;

    s2 += s14 * 666643;
    s3 += s14 * 470296;
    s4 += s14 * 654183;
    s5 -= s14 * 997805;
    s6 += s14 * 136657;
    s7 -= s14 * 683901;

    s1 += s13 * 666643;
    s2 += s13 * 470296;
    s3 += s13 * 654183;
    s4 -= s13 * 997805;
    s5 += s13 * 136657;
    s6 -= s13 * 683901;

    s0 += s12 * 666643;
    s1 += s12 * 470296;
    s2 += s12 * 654183;
    s3 -= s12 * 997805;
    s4 += s12 * 136657;
    s5 -= s12 * 683901;
    s12 = 0;

    carry0 = (s0 + (1 << 20)) >> 21;
    s1 += carry0;
    s0 -= carry0 << 21;
    carry2 = (s2 + (1 << 20)) >> 21;
    s3 += carry2;
    s2 -= carry2 << 21;
    carry4 = (s4 + (1 << 20)) >> 21;
    s5 += carry4;
    s4 -= carry4 << 21;
    carry6 = (s6 + (1 << 20)) >> 21;
    s7 += carry6;
    s6 -= carry6 << 21;
    carry8 = (s8 + (1 << 20)) >> 21;
    s9 += carry8;
    s8 -= carry8 << 21;
    carry10 = (s10 + (1 << 20)) >> 21;
    s11 += carry10;
    s10 -= carry10 << 21;

    carry1 = (s1 + (1 << 20)) >> 21;
    s2 += carry1;
    s1 -= carry1 << 21;
    carry3 = (s3 + (1 << 20)) >> 21;
    s4 += carry3;
    s3 -= carry3 << 21;
    carry5 = (s5 + (1 << 20)) >> 21;
    s6 += carry5;
    s5 -= carry5 << 21;
    carry7 = (s7 + (1 << 20)) >> 21;
    s8 += carry7;
    s7 -= carry7 << 21;
    carry9 = (s9 + (1 << 20)) >> 21;
    s10 += carry9;
    s9 -= carry9 << 21;
    carry11 = (s11 + (1 << 20)) >> 21;
    s12 += carry11;
    s11 -= carry11 << 21;

    s0 += s12 * 666643;
    s1 += s12 * 470296;
    s2 += s12 * 654183;
    s3 -= s12 * 997805;
    s4 += s12 * 136657;
    s5 -= s12 * 683901;
    s12 = 0;

    carry0 = s0 >> 21;
    s1 += carry0;
    s0 -= carry0 << 21;
    carry1 = s1 >> 21;
    s2 += carry1;
    s1 -= carry1 << 21;
    carry2 = s2 >> 21;
    s3 += carry2;
    s2 -= carry2 << 21;
    carry3 = s3 >> 21;
    s4 += carry3;
    s3 -= carry3 << 21;
    carry4 = s4 >> 21;
    s5 += carry4;
    s4 -= carry4 << 21;
    carry5 = s5 >> 21;
    s6 += carry5;
    s5 -= carry5 << 21;
    carry6 = s6 >> 21;
    s7 += carry6;
    s6 -= carry6 << 21;
    carry7 = s7 >> 21;
    s8 += carry7;
    s7 -= carry7 << 21;
    carry8 = s8 >> 21;
    s9 += carry8;
    s8 -= carry8 << 21;
    carry9 = s9 >> 21;
    s10 += carry9;
    s9 -= carry9 << 21;
    carry10 = s10 >> 21;
    s11 += carry10;
    s10 -= carry10 << 21;
    carry11 = s11 >> 21;
    s12 += carry11;
    s11 -= carry11 << 21;

    s0 += s12 * 666643;
    s1 += s12 * 470296;
    s2 += s12 * 654183;
    s3 -= s12 * 997805;
    s4 += s12 * 136657;
    s5 -= s12 * 683901;

    carry0 = s0 >> 21;
    s1 += carry0;
    s0 -= carry0 << 21;
    carry1 = s1 >> 21;
    s2 += carry1;
    s1 -= carry1 << 21;
    carry2 = s2 >> 21;
    s3 += carry2;
    s2 -= carry2 << 21;
    carry3 = s3 >> 21;
    s4 += carry3;
    s3 -= carry3 << 21;
    carry4 = s4 >> 21;
    s5 += carry4;
    s4 -= carry4 << 21;
    carry5 = s5 >> 21;
    s6 += carry5;
    s5 -= carry5 << 21;
    carry6 = s6 >> 21;
    s7 += carry6;
    s6 -= carry6 << 21;
    carry7 = s7 >> 21;
    s8 += carry7;
    s7 -= carry7 << 21;
    carry8 = s8 >> 21;
    s9 += carry8;
    s8 -= carry8 << 21;
    carry9 = s9 >> 21;
    s10 += carry9;
    s9 -= carry9 << 21;
    carry10 = s10 >> 21;
    s11 += carry10;
    s10 -= carry10 << 21;

    final Uint8List result = new Uint8List(32);
    result[0] = (s0);
    result[1] = (s0 >> 8);
    result[2] = ((s0 >> 16) | (s1 << 5));
    result[3] = (s1 >> 3);
    result[4] = (s1 >> 11);
    result[5] = ((s1 >> 19) | (s2 << 2));
    result[6] = (s2 >> 6);
    result[7] = ((s2 >> 14) | (s3 << 7));
    result[8] = (s3 >> 1);
    result[9] = (s3 >> 9);
    result[10] = ((s3 >> 17) | (s4 << 4));
    result[11] = (s4 >> 4);
    result[12] = (s4 >> 12);
    result[13] = ((s4 >> 20) | (s5 << 1));
    result[14] = (s5 >> 7);
    result[15] = ((s5 >> 15) | (s6 << 6));
    result[16] = (s6 >> 2);
    result[17] = (s6 >> 10);
    result[18] = ((s6 >> 18) | (s7 << 3));
    result[19] = (s7 >> 5);
    result[20] = (s7 >> 13);
    result[21] = (s8);
    result[22] = (s8 >> 8);
    result[23] = ((s8 >> 16) | (s9 << 5));
    result[24] = (s9 >> 3);
    result[25] = (s9 >> 11);
    result[26] = ((s9 >> 19) | (s10 << 2));
    result[27] = (s10 >> 6);
    result[28] = ((s10 >> 14) | (s11 << 7));
    result[29] = (s11 >> 1);
    result[30] = (s11 >> 9);
    result[31] = (s11 >> 17);

    return new Ed25519EncodedFieldElement(result);
  }

  // -------------------- private / protected functions -------------------- //

  static int _threeBytesToInt(final Uint8List byteArray, int offset) {
    int result = byteArray[offset++] & 0xff;
    result |= (byteArray[offset++] & 0xff) << 8;
    result |= (byteArray[offset] & 0xff) << 16;
    return result;
  }

  static int _fourBytesToInt(final Uint8List byteArray, int offset) {
    int result = byteArray[offset++] & 0xff;
    result |= (byteArray[offset++] & 0xff) << 8;
    result |= (byteArray[offset++] & 0xff) << 16;
    result |= byteArray[offset] << 24;
    return result & 0xffffffff;
  }
}
