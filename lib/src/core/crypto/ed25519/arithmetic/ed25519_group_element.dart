part of nem2_sdk_dart.core.crypto.ed25519.arithmetic;

/// A point on the ED25519 curve which represents a group element.
/// This implementation is based on the ref10 implementation of SUPERCOP.
///
/// Literature:
/// [1] Daniel J. Bernstein, Niels Duif, Tanja Lange, Peter Schwabe
/// and Bo-Yin Yang : High-speed high-security signatures
/// [2] Huseyin Hisil, Kenneth Koon-Ho Wong, Gary Carter,
/// Ed Dawson: Twisted Edwards Curves Revisited
/// [3] Daniel J. Bernsteina, Tanja Lange: A complete set of addition laws
/// for incomplete Edwards curves
/// [4] Daniel J. Bernstein, Peter Birkner, Marc Joye, Tanja Lange and
/// Christiane Peters: Twisted Edwards Curves
/// [5] Christiane Pascale Peters: Curves, Codes, and Cryptography (PhD thesis)
/// [6] Daniel J. Bernstein, Peter Birkner, Tanja Lange and
/// Christiane Peters: Optimizing double-base elliptic-curve single-scalar
/// multiplication
/// TODO: let this class implements Built<T>. (It's Dart version Serializable for Java).
/// TODO: See package: built_value v6.2.0 (for serialization) and built_value_generator v6.2.0 (it's a dev dependency)
class Ed25519GroupElement {
  final CoordinateSystem _coordinateSystem;
  final Ed25519FieldElement _X;
  final Ed25519FieldElement _Y;
  final Ed25519FieldElement _Z;
  final Ed25519FieldElement _T;

  /// Precomputed table for a single scalar multiplication.
  List<List<Ed25519GroupElement>> _precomputedForSingle;

  /// Precomputed table for a double scalar multiplication
  List<Ed25519GroupElement> _precomputedForDouble;

  // ---------------------------- constructors ---------------------------- //

  /// Creates a group element for a curve.
  Ed25519GroupElement(
      this._coordinateSystem, this._X, this._Y, this._Z, this._T);

  static Ed25519GroupElement affine(final Ed25519FieldElement x,
      final Ed25519FieldElement y, final Ed25519FieldElement Z) {
    return new Ed25519GroupElement(CoordinateSystem.AFFINE, x, y, Z, null);
  }

  /// Creates a new group element using the P2 coordinate system.
  static Ed25519GroupElement p2(final Ed25519FieldElement X,
      final Ed25519FieldElement Y, final Ed25519FieldElement Z) {
    return new Ed25519GroupElement(CoordinateSystem.P2, X, Y, Z, null);
  }

  /// Creates a new group element using the P3 coordinate system.
  static Ed25519GroupElement p3(
      final Ed25519FieldElement X,
      final Ed25519FieldElement Y,
      final Ed25519FieldElement Z,
      final Ed25519FieldElement T) {
    return new Ed25519GroupElement(CoordinateSystem.P3, X, Y, Z, T);
  }

  /// Creates a new group element using the P1xP1 coordinate system.
  static Ed25519GroupElement p1xp1(
      final Ed25519FieldElement X,
      final Ed25519FieldElement Y,
      final Ed25519FieldElement Z,
      final Ed25519FieldElement T) {
    return new Ed25519GroupElement(CoordinateSystem.P1xP1, X, Y, Z, T);
  }

  /// Creates a new group element using the PRECOMPUTED coordinate system.
  static Ed25519GroupElement precomputed(final Ed25519FieldElement yPlusx,
      final Ed25519FieldElement yMinusx, final Ed25519FieldElement xy2d) {
    //noinspection SuspiciousNameCombination
    return new Ed25519GroupElement(
        CoordinateSystem.PRECOMPUTED, yPlusx, yMinusx, xy2d, null);
  }

  /// Creates a new group element using the CACHED coordinate system.
  static Ed25519GroupElement cached(
      final Ed25519FieldElement YPlusX,
      final Ed25519FieldElement YMinusX,
      final Ed25519FieldElement Z,
      final Ed25519FieldElement T2d) {
    return new Ed25519GroupElement(
        CoordinateSystem.CACHED, YPlusX, YMinusX, Z, T2d);
  }

  // ------------------------------ accessors ------------------------------ //

  /// Gets the coordinate system for the group element.
  CoordinateSystem get coordinateSystem => this._coordinateSystem;

  /// Gets the X value of the group element.
  /// This is for most coordinate systems the projective X coordinate.
  Ed25519FieldElement get X => this._X;

  /// Gets the Y value of the group element.
  /// This is for most coordinate systems the projective Y coordinate.
  Ed25519FieldElement get Y => this._Y;

  /// Gets the Z value of the group element.
  /// This is for most coordinate systems the projective Z coordinate.
  Ed25519FieldElement get Z => this._Z;

  /// Gets the T value of the group element.
  /// This is for most coordinate systems the projective T coordinate.
  Ed25519FieldElement get T => this._T;

  /// Gets a value indicating whether or not the group element has a
  /// precomputed table for double scalar multiplication.
  bool isPrecomputedForDoubleScalarMultiplication() {
    return null != this._precomputedForDouble;
  }

  /// Verify that the group element satisfies the curve equation.
  bool satisfiesCurveEquation() {
    switch (this._coordinateSystem) {
      case CoordinateSystem.P2:
      case CoordinateSystem.P3:
        final Ed25519FieldElement inverse = this._Z.invert();
        final Ed25519FieldElement x = this._X.multiply(inverse);
        final Ed25519FieldElement y = this._Y.multiply(inverse);
        final Ed25519FieldElement xSquare = x.square();
        final Ed25519FieldElement ySquare = y.square();
        final Ed25519FieldElement dXSquareYSquare =
            Ed25519Field.D.multiply(xSquare).multiply(ySquare);
        return Ed25519Field.ONE.add(dXSquareYSquare).add(xSquare) == (ySquare);
      default:
        return this.toP2().satisfiesCurveEquation();
    }
  }

  /// Gets the table with the precomputed group elements for
  /// single scalar multiplication.
  List<List<Ed25519GroupElement>> get precomputedForSingle =>
      this._precomputedForSingle;

  /// Gets the table with the precomputed group elements for
  /// double scalar multiplication.
  List<Ed25519GroupElement> get precomputedForDouble =>
      this._precomputedForDouble;

  @override
  int get hashCode {
    return this.encode().hashCode;
  }

  @override
  bool operator ==(final other) {
    if (!(other is Ed25519GroupElement)) {
      return false;
    }

    Ed25519GroupElement ge = other;

    if (!(this._coordinateSystem == ge.coordinateSystem)) {
      try {
        ge = ge._toCoordinateSystem(this._coordinateSystem);
      } catch (e) {
        return false;
      }
    }

    switch (this._coordinateSystem) {
      case CoordinateSystem.P2:
      case CoordinateSystem.P3:
        if (this._Z == ge.Z) {
          return (this.X == ge.X) && (this.Y == ge.Y);
        }

        final Ed25519FieldElement x1 = this.X.multiply(ge.Z);
        final Ed25519FieldElement y1 = this.Y.multiply(ge.Z);
        final Ed25519FieldElement x2 = ge.X.multiply(this.Z);
        final Ed25519FieldElement y2 = ge.Y.multiply(this.Z);

        return x1 == x2 && y1 == y2;
      case CoordinateSystem.P1xP1:
        return this.toP2() == ge;
      case CoordinateSystem.PRECOMPUTED:
        return this.X == ge.X && this.Y == ge.Y && this.Z == ge.Z;
      case CoordinateSystem.CACHED:
        if (this.Z == ge.Z) {
          return this.X == ge.X && this.Y == ge.Y && this.T == ge.T;
        }

        final Ed25519FieldElement x3 = this.X.multiply(ge.Z);
        final Ed25519FieldElement y3 = this.Y.multiply(ge.Z);
        final Ed25519FieldElement t3 = this.T.multiply(ge.Z);
        final Ed25519FieldElement x4 = ge.X.multiply(this.Z);
        final Ed25519FieldElement y4 = ge.Y.multiply(this.Z);
        final Ed25519FieldElement t4 = ge.T.multiply(this.Z);

        return x3 == x4 && y3 == y4 && t3 == t4;
      default:
        return false;
    }
  }

  @override
  String toString() {
    return "X=${this._X.toString()}\n"
        "Y=${this._Y.toString()}\n"
        "Z=${this._Z.toString()}\n"
        "T=${this._T.toString()}\n";
  }

  // -------------------- math operations and functions -------------------- //

  /// Converts the group element to an encoded point on the curve.
  Ed25519EncodedGroupElement encode() {
    switch (this._coordinateSystem) {
      case CoordinateSystem.P2:
      case CoordinateSystem.P3:
        final Ed25519FieldElement inverse = this._Z.invert();
        final Ed25519FieldElement x = this._X.multiply(inverse);
        final Ed25519FieldElement y = this._Y.multiply(inverse);
        final Uint8List s = y.encode().getRaw();
        s[s.length - 1] |= (x.isNegative() ? 0x80 : 0);

        return new Ed25519EncodedGroupElement(s);
      default:
        return this.toP2().encode();
    }
  }

  /// Converts the group element to the P2 coordinate system.
  Ed25519GroupElement toP2() {
    return this._toCoordinateSystem(CoordinateSystem.P2);
  }

  /// Converts the group element to the P3 coordinate system.
  Ed25519GroupElement toP3() {
    return this._toCoordinateSystem(CoordinateSystem.P3);
  }

  /// Converts the group element to the CACHED coordinate system.
  Ed25519GroupElement toCached() {
    return this._toCoordinateSystem(CoordinateSystem.CACHED);
  }

  /// Precomputes the group elements needed to speed up a scalar multiplication.
  void precomputeForScalarMultiplication() {
    if (null != this._precomputedForSingle) {
      return;
    }

    Ed25519GroupElement Bi = this;
    this._precomputedForSingle = List<List<Ed25519GroupElement>>.generate(
        32, (index) => new List<Ed25519GroupElement>(8));

    for (int i = 0; i < 32; i++) {
      Ed25519GroupElement Bij = Bi;
      for (int j = 0; j < 8; j++) {
        final Ed25519FieldElement inverse = Bij.Z.invert();
        final Ed25519FieldElement x = Bij.X.multiply(inverse);
        final Ed25519FieldElement y = Bij.Y.multiply(inverse);
        this.precomputedForSingle[i][j] = precomputed(y.add(x), y.subtract(x),
            x.multiply(y).multiply(Ed25519Field.D_Times_TWO));
        Bij = Bij.add(Bi.toCached()).toP3();
      }

      /// Only every second summand is precomputed (16^2 = 256).
      for (int k = 0; k < 8; k++) {
        Bi = Bi.add(Bi.toCached()).toP3();
      }
    }
  }

  /// Precomputes the group elements used to speed up a double scalar
  /// multiplication.
  void precomputeForDoubleScalarMultiplication() {
    if (null != this._precomputedForDouble) {
      return;
    }
    Ed25519GroupElement Bi = this;
    this._precomputedForDouble = new List<Ed25519GroupElement>(8);
    for (int i = 0; i < 8; i++) {
      final Ed25519FieldElement inverse = Bi.Z.invert();
      final Ed25519FieldElement x = Bi.X.multiply(inverse);
      final Ed25519FieldElement y = Bi.Y.multiply(inverse);
      this._precomputedForDouble[i] = precomputed(y.add(x), y.subtract(x),
          x.multiply(y).multiply(Ed25519Field.D_Times_TWO));
      Bi = this.add(this.add(Bi.toCached()).toP3().toCached()).toP3();
    }
  }

  /// Doubles a given group element p in P^2 or P^3 coordinate system and
  /// returns the result in P x P coordinate system.
  /// r = 2 * p where p = (X : Y : Z) or p = (X : Y : Z : T)
  ///
  /// r in P x P coordinate system:
  ///
  /// r = ((X' : Z'), (Y' : T')) where
  /// X' = (X + Y)^2 - (Y^2 + X^2)
  /// Y' = Y^2 + X^2
  /// Z' = y^2 - X^2
  /// T' = 2 * Z^2 - (y^2 - X^2)
  ///
  /// r converted from P x P to P^2 coordinate system:
  ///
  /// r = (X'' : Y'' : Z'') where
  /// X'' = X' * T' = ((X + Y)^2 - Y^2 - X^2) * (2 * Z^2 - (y^2 - X^2))
  /// Y'' = Y' * Z' = (Y^2 + X^2) * (y^2 - X^2)
  /// Z'' = Z' * T' = (y^2 - X^2) * (2 * Z^2 - (y^2 - X^2))
  ///
  /// Formula for the P^2 coordinate system is in agreement with the formula
  /// given in [4] page 12 (with a = -1)
  /// (up to a common factor -1 which does not matter):
  ///
  /// B = (X + Y)^2; C = X^2; D = Y^2; E = -C = -X^2; F := E + D = Y^2 - X^2;
  /// H = Z^2; J = F − 2 * H;
  /// X3 = (B − C − D) · J = X' * (-T');
  /// Y3 = F · (E − D) = Z' * (-Y');
  /// Z3 = F · J = Z' * (-T').
  Ed25519GroupElement dbl() {
    switch (this._coordinateSystem) {
      case CoordinateSystem.P2:
      case CoordinateSystem.P3:
        final Ed25519FieldElement XSquare = this.X.square();
        final Ed25519FieldElement YSquare = this.Y.square();
        final Ed25519FieldElement B = this.Z.squareAndDouble();
        final Ed25519FieldElement A = this.X.add(this.Y);
        final Ed25519FieldElement ASquare = A.square();
        final Ed25519FieldElement YSquarePlusXSquare = YSquare.add(XSquare);
        final Ed25519FieldElement YSquareMinusXSquare =
            YSquare.subtract(XSquare);
        return p1xp1(ASquare.subtract(YSquarePlusXSquare), YSquarePlusXSquare,
            YSquareMinusXSquare, B.subtract(YSquareMinusXSquare));
      default:
        throw new UnsupportedError("Unsupported operation");
    }
  }

  /// Ed25519GroupElement addition using the twisted Edwards addition law for
  /// extended coordinates.
  /// this must be given in P^3 coordinate system and g in PRECOMPUTED
  /// coordinate system.
  /// r = this + g where this = (X1 : Y1 : Z1 : T1), g = (g.X, g.Y, g.Z)
  /// = (Y2/Z2 + X2/Z2, Y2/Z2 - X2/Z2, 2 * d * X2/Z2 * Y2/Z2)
  /// <br>
  /// r in P x P coordinate system:
  /// <br>
  /// r = ((X' : Z'), (Y' : T')) where
  /// X' = (Y1 + X1) * g.X - (Y1 - X1) * q.Y = ((Y1 + X1) * (Y2 + X2)
  /// - (Y1 - X1) * (Y2 - X2)) * 1/Z2
  /// Y' = (Y1 + X1) * g.X + (Y1 - X1) * q.Y = ((Y1 + X1) * (Y2 + X2)
  /// + (Y1 - X1) * (Y2 - X2)) * 1/Z2
  /// Z' = 2 * Z1 + T1 * g.Z = 2 * Z1 + T1 * 2 * d * X2 * Y2 * 1/Z2^2
  /// = (2 * Z1 * Z2 + 2 * d * T1 * T2) * 1/Z2
  /// T' = 2 * Z1 - T1 * g.Z = 2 * Z1 - T1 * 2 * d * X2 * Y2 * 1/Z2^2
  /// = (2 * Z1 * Z2 - 2 * d * T1 * T2) * 1/Z2
  /// <br>
  /// Formula for the P x P coordinate system is in agreement with
  /// the formula given in
  /// file ge25519.c method add_p1p1() in ref implementation.
  /// Setting A = (Y1 - X1) * (Y2 - X2),
  /// B = (Y1 + X1) * (Y2 + X2),
  /// C= 2 * d * T1 * T2, D = 2 * Z1 * Z2
  /// we get
  /// X' = (B - A) * 1/Z2
  /// Y' = (B + A) * 1/Z2
  /// Z' = (D + C) * 1/Z2
  /// T' = (D - C) * 1/Z2
  /// <br>
  /// r converted from P x P to P^2 coordinate system:
  /// <br>
  /// r = (X'' : Y'' : Z'' : T'') where
  /// X'' = X' * T' = (B - A) * (D - C) * 1/Z2^2
  /// Y'' = Y' * Z' = (B + A) * (D + C) * 1/Z2^2
  /// Z'' = Z' * T' = (D + C) * (D - C) * 1/Z2^2
  /// T'' = X' * Y' = (B - A) * (B + A) * 1/Z2^2
  /// <br>
  /// Formula above for the P^2 coordinate system is in agreement with
  /// the formula given in [2] page 6
  /// (the common factor 1/Z2^2 does not matter)
  /// E = B - A, F = D - C, G = D + C, H = B + A
  /// X3 = E * F = (B - A) * (D - C);
  /// Y3 = G * H = (D + C) * (B + A);
  /// Z3 = F * G = (D - C) * (D + C);
  /// T3 = E * H = (B - A) * (B + A);
  Ed25519GroupElement _precomputedAdd(final Ed25519GroupElement g) {
    if (this._coordinateSystem != CoordinateSystem.P3) {
      throw new UnsupportedError("Unsupported operation");
    }
    if (g.coordinateSystem != CoordinateSystem.PRECOMPUTED) {
      throw new ArgumentError("Illegal argument");
    }

    final Ed25519FieldElement YPlusX = this.Y.add(this.X);
    final Ed25519FieldElement YMinusX = this.Y.subtract(this.X);
    final Ed25519FieldElement A = YPlusX.multiply(g.X);
    final Ed25519FieldElement B = YMinusX.multiply(g.Y);
    final Ed25519FieldElement C = g.Z.multiply(this.T);
    final Ed25519FieldElement D = this.Z.add(this.Z);

    return p1xp1(A.subtract(B), A.add(B), D.add(C), D.subtract(C));
  }

  /// Ed25519GroupElement subtraction using the twisted Edwards addition law
  /// for extended coordinates.
  /// this must be given in P^3 coordinate system and g in PRECOMPUTED
  /// coordinate system.
  /// r = this - g where this = (X1 : Y1 : Z1 : T1), g = (g.X, g.Y, g.Z)
  /// = (Y2/Z2 + X2/Z2, Y2/Z2 - X2/Z2, 2 * d * X2/Z2 * Y2/Z2)
  ///
  /// Negating g means negating the value of X2 and T2
  /// (the latter is irrelevant here).
  /// The formula is in accordance to the above addition.
  Ed25519GroupElement _precomputedSubtract(final Ed25519GroupElement g) {
    if (this._coordinateSystem != CoordinateSystem.P3) {
      throw new UnsupportedError("Unsupported operation");
    }
    if (g.coordinateSystem != CoordinateSystem.PRECOMPUTED) {
      throw new ArgumentError("Illegal argument");
    }

    final Ed25519FieldElement YPlusX = this.Y.add(this.X);
    final Ed25519FieldElement YMinusX = this.Y.subtract(this.X);
    final Ed25519FieldElement A = YPlusX.multiply(g.Y);
    final Ed25519FieldElement B = YMinusX.multiply(g.X);
    final Ed25519FieldElement C = g.Z.multiply(this.T);
    final Ed25519FieldElement D = this.Z.add(this.Z);

    return p1xp1(A.subtract(B), A.add(B), D.subtract(C), D.add(C));
  }

  /// Ed25519GroupElement addition using the twisted Edwards addition law
  /// for extended coordinates.
  /// this must be given in P^3 coordinate system and g in CACHED
  /// coordinate system.
  /// r = this + g where this = (X1 : Y1 : Z1 : T1),
  /// g = (g.X, g.Y, g.Z, g.T) = (Y2 + X2, Y2 - X2, Z2, 2 * d * T2)
  ///
  /// r in P x P coordinate system.:
  /// X' = (Y1 + X1) * (Y2 + X2) - (Y1 - X1) * (Y2 - X2)
  /// Y' = (Y1 + X1) * (Y2 + X2) + (Y1 - X1) * (Y2 - X2)
  /// Z' = 2 * Z1 * Z2 + 2 * d * T1 * T2
  /// T' = 2 * Z1 * T2 - 2 * d * T1 * T2
  ///
  /// Setting A = (Y1 - X1) * (Y2 - X2), B = (Y1 + X1) * (Y2 + X2),
  /// C = 2 * d * T1 * T2, D = 2 * Z1 * Z2 we get
  /// X' = (B - A)
  /// Y' = (B + A)
  /// Z' = (D + C)
  /// T' = (D - C)
  ///
  /// Same result as in precomputedAdd() (up to a common factor
  /// which does not matter).
  Ed25519GroupElement add(final Ed25519GroupElement g) {
    if (this._coordinateSystem != CoordinateSystem.P3) {
      throw new UnsupportedError("Unsupported coordinate system");
    }
    if (g.coordinateSystem != CoordinateSystem.CACHED) {
      throw new ArgumentError("Illegal argument");
    }

    final Ed25519FieldElement YPlusX = this.Y.add(this.X);
    final Ed25519FieldElement YMinusX = this.Y.subtract(this.X);
    final Ed25519FieldElement A = YPlusX.multiply(g.X);
    final Ed25519FieldElement B = YMinusX.multiply(g.Y);
    final Ed25519FieldElement C = g.T.multiply(this.T);
    final Ed25519FieldElement ZSquare = this.Z.multiply(g.Z);
    final Ed25519FieldElement D = ZSquare.add(ZSquare);

    return p1xp1(A.subtract(B), A.add(B), D.add(C), D.subtract(C));
  }

  /// Ed25519GroupElement subtraction using the twisted Edwards addition
  /// law for extended coordinates.
  ///
  /// Negating g means negating the value of the coordinate X2 and T2.
  /// The formula is in accordance to the above addition.
  Ed25519GroupElement subtract(final Ed25519GroupElement g) {
    if (this._coordinateSystem != CoordinateSystem.P3) {
      throw new UnsupportedError("Unsupported coordinate system");
    }
    if (g.coordinateSystem != CoordinateSystem.CACHED) {
      throw new ArgumentError("Illegal argument");
    }

    final Ed25519FieldElement YPlusX = this.Y.add(this.X);
    final Ed25519FieldElement YMinusX = this.Y.subtract(this.X);
    final Ed25519FieldElement A = YPlusX.multiply(g.Y);
    final Ed25519FieldElement B = YMinusX.multiply(g.X);
    final Ed25519FieldElement C = g.T.multiply(this.T);
    final Ed25519FieldElement ZSquare = this.Z.multiply(g.Z);
    final Ed25519FieldElement D = ZSquare.add(ZSquare);

    return p1xp1(A.subtract(B), A.add(B), D.subtract(C), D.add(C));
  }

  /// Negates this group element by subtracting it from the neutral
  /// group element.
  /// (only used in MathUtils so it doesn't have to be fast)
  Ed25519GroupElement negate() {
    if (this._coordinateSystem != CoordinateSystem.P3) {
      throw new UnsupportedError("Unsupported coordinate system");
    }

    return Ed25519Group.ZERO_P3.subtract(this.toCached()).toP3();
  }

  /// h = a * B where a = a[0]+256*a[1]+...+256^31 a[31] and
  /// B is this point. If its lookup table has not been precomputed, it
  /// will be at the start of the method (and cached for later calls).
  /// Constant time.
  Ed25519GroupElement scalarMultiply(final Ed25519EncodedFieldElement a) {
    Ed25519GroupElement g;
    int i;
    final Uint8List e = _toRadix16(a);
    Ed25519GroupElement h = Ed25519Group.ZERO_P3;
    for (i = 1; i < 64; i += 2) {
      /// TODO: verify the validity of this operation.
      /// The original argument was select(1/2, e[i]);
      g = this._select((i / 2).round(), e[i]);
      h = h._precomputedAdd(g).toP3();
    }

    h = h.dbl().toP2().dbl().toP2().dbl().toP2().dbl().toP3();

    for (i = 0; i < 64; i += 2) {
      /// TODO: verify the validity of this operation.
      /// The original argument was select(1/2, e[i]);
      g = this._select((i / 2).round(), e[i]);
      h = h._precomputedAdd(g).toP3();
    }

    return h;
  }

  /// r = b * B - a * A  where
  /// a and b are encoded field elements and
  /// B is this point.
  /// A must have been previously precomputed for double scalar multiplication.
  Ed25519GroupElement doubleScalarMultiplyVariableTime(
      final Ed25519GroupElement A,
      final Ed25519EncodedFieldElement a,
      final Ed25519EncodedFieldElement b) {
    final Uint8List aSlide = _slide(a);
    final Uint8List bSlide = _slide(b);
    Ed25519GroupElement r = Ed25519Group.ZERO_P2;

    int i;
    for (i = 255; i >= 0; --i) {
      if (aSlide[i] != 0 || bSlide[i] != 0) {
        break;
      }
    }

    for (; i >= 0; --i) {
      Ed25519GroupElement t = r.dbl();

      /// TODO: verify the validity of this operation.
      /// The original argument was precomputedForDouble[aSlide[i] / 2]);
      if (aSlide[i] > 0) {
        t = t.toP3()._precomputedSubtract(
            A.precomputedForDouble[(aSlide[i] / 2).round()]);
      } else if (aSlide[i] < 0) {
        t = t.toP3()._precomputedAdd(
            A.precomputedForDouble[((-aSlide[i]) / 2).round()]);
      }

      if (bSlide[i] > 0) {
        t = t.toP3()._precomputedAdd(
            this.precomputedForDouble[(bSlide[i] / 2).round()]);
      } else if (bSlide[i] < 0) {
        t = t.toP3()._precomputedSubtract(
            this.precomputedForDouble[((-bSlide[i]) / 2).round()]);
      }

      r = t.toP2();
    }

    return r;
  }

  // -------------------- private / protected functions -------------------- //

  /// Convert a to 2^16 bit representation.
  static Uint8List _toRadix16(final Ed25519EncodedFieldElement encoded) {
    final Uint8List a = encoded.getRaw();
    final Uint8List e = new Uint8List(64);
    int i;
    for (i = 0; i < 32; i++) {
      e[2 * i] = (a[i] & 15);
      e[2 * i + 1] = ((a[i] >> 4) & 15);
    }

    /// each e[i] is between 0 and 15
    /// e[63] is between 0 and 7
    int carry = 0;
    for (i = 0; i < 63; i++) {
      e[i] += carry;
      carry = e[i] + 8;
      carry >>= 4;
      e[i] -= carry << 4;
    }
    e[63] += carry;

    return e;
  }

  /// Calculates a sliding-windows base 2 representation for a given
  /// encoded field element a.
  /// To learn more about it see [6] page 8.
  ///
  /// Output: r which satisfies
  /// a = r0 * 2^0 + r1 * 2^1 + ... + r255 * 2^255 with ri in
  /// {-15, -13, -11, -9, -7, -5, -3, -1, 0, 1, 3, 5, 7, 9, 11, 13, 15}
  ///
  /// Method is package private only so that tests run.
  static Uint8List _slide(final Ed25519EncodedFieldElement encoded) {
    final Uint8List a = encoded.getRaw();
    final Uint8List r = new Uint8List(256);

    /// Put each bit of 'a' into a separate byte, 0 or 1
    for (int i = 0; i < 256; ++i) {
      r[i] = (1 & (a[i >> 3] >> (i & 7)));
    }

    /// Note: r[i] will always be odd.
    for (int i = 0; i < 256; ++i) {
      if (r[i] != 0) {
        for (int b = 1; b <= 6 && i + b < 256; ++b) {
          /// Accumulate bits if possible
          if (r[i + b] != 0) {
            if (r[i] + (r[i + b] << b) <= 15) {
              r[i] += r[i + b] << b;
              r[i + b] = 0;
            } else if (r[i] - (r[i + b] << b) >= -15) {
              r[i] -= r[i + b] << b;
              for (int k = i + b; k < 256; ++k) {
                if (r[k] == 0) {
                  r[k] = 1;
                  break;
                }
                r[k] = 0;
              }
            } else {
              break;
            }
          }
        }
      }
    }

    return r;
  }

  /// Convert a Ed25519GroupElement from one coordinate system to another.
  ///
  /// Supported conversions:
  /// - P3 -> P2
  /// - P3 -> CACHED (1 multiply, 1 add, 1 subtract)
  /// - P1xP1 -> P2 (3 multiply)
  /// - P1xP1 -> P3 (4 multiply)
  Ed25519GroupElement _toCoordinateSystem(
      final CoordinateSystem newCoordinateSystem) {
    switch (this._coordinateSystem) {
      case CoordinateSystem.P2:
        switch (newCoordinateSystem) {
          case CoordinateSystem.P2:
            return p2(this._X, this._Y, this._Z);
          default:
            throw new ArgumentError();
        }
        break;
      case CoordinateSystem.P3:
        switch (newCoordinateSystem) {
          case CoordinateSystem.P2:
            return p2(this._X, this._Y, this._Z);
          case CoordinateSystem.P3:
            return p3(this._X, this._Y, this._Z, this._T);
          case CoordinateSystem.CACHED:
            return cached(this._Y.add(this._X), this._Y.subtract(this._X),
                this._Z, this._T.multiply(Ed25519Field.D_Times_TWO));
          default:
            throw new ArgumentError();
        }
        break;
      case CoordinateSystem.P1xP1:
        switch (newCoordinateSystem) {
          case CoordinateSystem.P2:
            return p2(this._X.multiply(this._T), this._Y.multiply(this._Z),
                this._Z.multiply(this._T));
          case CoordinateSystem.P3:
            return p3(this._X.multiply(this._T), this._Y.multiply(this._Z),
                this._Z.multiply(this._T), this._X.multiply(this._Y));
          case CoordinateSystem.P1xP1:
            return p1xp1(this._X, this._Y, this._Z, this._T);
          default:
            throw new ArgumentError();
        }
        break;
      case CoordinateSystem.PRECOMPUTED:
        switch (newCoordinateSystem) {
          case CoordinateSystem.PRECOMPUTED:
            //noinspection SuspiciousNameCombination
            return precomputed(this._X, this._Y, this._Z);
          default:
            throw new ArgumentError();
        }
        break;
      case CoordinateSystem.CACHED:
        switch (newCoordinateSystem) {
          case CoordinateSystem.CACHED:
            return cached(this._X, this._Y, this._Z, this._T);
          default:
            throw new ArgumentError();
        }
        break;
      default:
        throw new ArgumentError();
    }
  }

  /// Constant-time conditional move.
  /// Replaces this with u if b == 1.
  /// Replaces this with this if b == 0.
  Ed25519GroupElement _cmov(final Ed25519GroupElement u, final int b) {
    Ed25519GroupElement ret = null;
    for (int i = 0; i < b; i++) {
      /// Only for b == 1
      ret = u;
    }
    for (int i = 0; i < 1 - b; i++) {
      /// Only for b == 0
      ret = this;
    }
    return ret;
  }

  /// Look up 16^i r_i B in the precomputed table.
  /// No secret array indices, no secret branching.
  /// Constant time.
  ///
  /// Must have previously precomputed.
  Ed25519GroupElement _select(final int pos, final int b) {
    /// Is r_i negative?
    final int bNegative = ByteUtils.isNegativeConstantTime(b);

    /// |r_i|
    final int bAbs = b - (((-bNegative) & b) << 1);

    /// 16^i |r_i| B
    final Ed25519GroupElement t = Ed25519Group.ZERO_PRECOMPUTED
        ._cmov(this._precomputedForSingle[pos][0],
            ByteUtils.isEqualConstantTime(bAbs, 1))
        ._cmov(this._precomputedForSingle[pos][1],
            ByteUtils.isEqualConstantTime(bAbs, 2))
        ._cmov(this._precomputedForSingle[pos][2],
            ByteUtils.isEqualConstantTime(bAbs, 3))
        ._cmov(this._precomputedForSingle[pos][3],
            ByteUtils.isEqualConstantTime(bAbs, 4))
        ._cmov(this._precomputedForSingle[pos][4],
            ByteUtils.isEqualConstantTime(bAbs, 5))
        ._cmov(this._precomputedForSingle[pos][5],
            ByteUtils.isEqualConstantTime(bAbs, 6))
        ._cmov(this._precomputedForSingle[pos][6],
            ByteUtils.isEqualConstantTime(bAbs, 7))
        ._cmov(this._precomputedForSingle[pos][7],
            ByteUtils.isEqualConstantTime(bAbs, 8));

    /// -16^i |r_i| B
    ///noinspection SuspiciousNameCombination
    final Ed25519GroupElement tMinus = precomputed(t.Y, t.X, t.Z.negate());

    /// 16^i r_i B
    return t._cmov(tMinus, bNegative);
  }
}
