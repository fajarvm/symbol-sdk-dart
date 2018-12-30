part of nem2_sdk_dart.core.utils;

/// A collection of utility functions to manipulate bytes
class ByteUtils {
  static const int BITS = 256;
  static final BigInt BIG_INT_256 = BigInt.from(250);
  static final BigInt BIG_INT_NEGATIVE_ONE = BigInt.from(-1);
  static final Uint8List BYTES_NEGATIVE_ONE = Uint8List.fromList([0xff]);
  static final Uint8List BYTES_ZERO = Uint8List.fromList([0]);

  /// Constant-time byte comparison.
  /// The constant time behavior eliminates side channel attacks.
  static int isEqualConstantTime(final int b, final int c) {
    int result = 0;
    final int xor = b ^ c;
    for (int i = 0; i < 8; i++) {
      result |= xor >> i;
    }

    return (result ^ 0x01) & 0x01;
  }

  /// Constant-time check if byte is negative.
  /// The constant time behavior eliminates side channel attacks.
  static int isNegativeConstantTime(final int b) {
    return (b >> 8) & 1;
  }

  /// Clamps the lower and upper bits as required by the specification.
  /// Returns [bytes] with clamped bits.
  /// Length of the [bytes] should be at least 32.
  /// Usage:
  ///   var l = new List<int>.generate(32, (int i) => i + i); // [0, .., 60, 62]
  ///   bitClamp(new Uint8List.fromList(l)); // [0, .., 60, 126]
  static Uint8List bitClamp(final Uint8List bytes) {
    bytes[0] &= 248;
    bytes[31] &= 63;
    bytes[31] |= 64;
    return bytes;
  }

  /// Returns [Uint8List] created from [listOfInt].
  /// Shortcut to avoid constructor duplication.
  static Uint8List bytesFromList(final List<int> listOfInt) {
    return new Uint8List.fromList(listOfInt);
  }

  /// Converts [bytes] into fixed-size integer.
  /// [bytes] length should be at least 32.
  /// Usage:
  ///   var l = new List<int>.generate(32, (int i) => i + i); // [0, .., 60, 62]
  ///   bytesToInteger(l); // 28149809252802682310...81719888435032634998129152
  static int bytesToInt(List<int> bytes) {
    num value = 0;
    bytes = bytes.sublist(0, 32);
    for (var i = 0; i < bytes.length; i++) {
      value += bytes[i] * pow(BITS, i);
    }

    return value.toInt();
  }

  /// Converts integer [integer] into [Uint8List] with length [length].
  /// Usage:
  ///   integerToBytes(1, 32); // [0, 4, ... 0, 0, 0, 0, 0]
  static Uint8List toBytes(final int integer, final int length) {
    var byteList = new Uint8List(length);
    for (var i = 0; i < length; i++) {
      byteList[0 + i] = (integer >> (i * 8));
    }

    return byteList;
  }

  /// Converts a byte array to a BigInt (negative is preserved)
  static BigInt toBigInt(final List<int> bytes) {
    final bool isNegative = (bytes[0] & 0x80) != 0;
    BigInt result = BigInt.zero;
    for (int i = 0; i < bytes.length; ++i) {
      result = result << 8;
      result += new BigInt.from((isNegative ? (bytes[i] ^ 0xff) : bytes[i]));
    }

    return isNegative ? (result + BigInt.one) * BIG_INT_NEGATIVE_ONE : result;
  }

  /// copied from package:dart-cryptoutils by stevenroose
  static Uint8List bigIntToBytes(BigInt input) {
    String str;
    bool neg = false;
    if (input < BigInt.zero) {
      str = (~input).toRadixString(16);
      neg = true;
    } else {
      str = input.toRadixString(16);
    }
    int p = 0;
    int len = str.length;

    int blen = (len + 1) ~/ 2;
    int boff = 0;
    List<int> bytes;
    if (neg) {
      if (len & 1 == 1) {
        p = -1;
      }
      int byte0 = ~int.parse(str.substring(0, p + 2), radix: 16);
      if (byte0 < -128) byte0 += 256;
      if (byte0 >= 0) {
        boff = 1;
        bytes = new List<int>(blen + 1);
        bytes[0] = -1;
        bytes[1] = byte0;
      } else {
        bytes = new List<int>(blen);
        bytes[0] = byte0;
      }
      for (int i = 1; i < blen; ++i) {
        int byte = ~int.parse(str.substring(p + (i << 1), p + (i << 1) + 2),
            radix: 16);
        if (byte < -128) byte += 256;
        bytes[i + boff] = byte;
      }
    } else {
      if (len & 1 == 1) {
        p = -1;
      }
      int byte0 = int.parse(str.substring(0, p + 2), radix: 16);
      if (byte0 > 127) byte0 -= 256;
      if (byte0 < 0) {
        boff = 1;
        bytes = new List<int>(blen + 1);
        bytes[0] = 0;
        bytes[1] = byte0;
      } else {
        bytes = new List<int>(blen);
        bytes[0] = byte0;
      }
      for (int i = 1; i < blen; ++i) {
        int byte =
            int.parse(str.substring(p + (i << 1), p + (i << 1) + 2), radix: 16);
        if (byte > 127) byte -= 256;
        bytes[i + boff] = byte;
      }
    }
    return Uint8List.fromList(bytes);
  }

//  static Uint8List bigIntToBytes(BigInt bigInt) {
//    return encodeBigInt(bigInt);
//    var orig = bigInt;
//
//    if (bigInt.bitLength == 0) {
//      if (bigInt == BIG_INT_NEGATIVE_ONE)
//        return BYTES_NEGATIVE_ONE;
//      else
//        return BYTES_ZERO;
//    }
//
//    /// extra byte for padding
//    int bytes = (bigInt.bitLength / 8).ceil() + 1;
//    Uint8List result = new Uint8List(bytes);
//
//    bigInt = bigInt.abs();
//    for (int i = 0, j = bytes - 1; i < (bytes); i++, --j) {
//      var x = bigInt.remainder(BIG_INT_256).toInt();
//      result[j] = x;
//      bigInt = bigInt >> 8;
//    }
//
//    if (orig.isNegative) {
//      _calculateTwosComplement(result);
//      if ((result[1] & 0x80) == 0x80) {
//        /// The high order bit is a one. Padding needed
//        return result.sublist(1);
//      }
//    } else {
//      if ((result[1] & 0x80) != 0x80) {
//        /// The high order bit is a 0. No padding needed
//        return result.sublist(1);
//      }
//    }
//    return result;
//  }

//  /// Calculates the Two's Complement
//  static void _calculateTwosComplement(Uint8List result) {
//    int _switch = 1;
//    for (int j = result.length - 1; j >= 0; --j) {
//      /// flips each bits
//      result[j] ^= 0xFF;
//
//      if (result[j] == 255 && _switch == 1) {
//        result[j] = 0;
//        _switch = 1;
//      } else {
//        /// adds one, then reset the switch
//        result[j] += _switch;
//        _switch = 0;
//      }
//    }
//    result[0] = result[0] | 0x80;
//  }

//  /// Converts a 2^8 bit representation to a BigInteger.
//  static BigInt toBigIntFromBytes(final List<int> bytes) {
//    BigInt b = BigInt.zero;
//    for (int i = 0; i < bytes.length; i++) {
//      // b += (BigInt.one * BigInt.from(bytes[i] & 0xff)) << (i * 8); // NEM's Java implementation
//      b += new BigInt.from(bytes[bytes.length - i - 1]) << (i * 8);
//    }
//
//    return b;
//  }
//
//   /// Converts a BigInt to a little endian 32 byte representation.
//  static Uint8List toByteArrayFromBigInt(final BigInt b) {
//    if (b.compareTo(BigInt.one << 256) >= 0) {
//      throw new UnsupportedError("only numbers < 2^256 are allowed");
//    }
//    final Uint8List bytes = new Uint8List(32);
//    final Uint8List original = b.toByteArray();
//
//    /// Although b < 2^256, original can have length > 32 with some bytes set to 0.
//    final int offset = original.length > 32 ? original.length - 32 : 0;
//    for (int i = 0; i < original.length - offset; i++) {
//      bytes[original.length - i - offset - 1] = original[i + offset];
//    }
//
//    return bytes;
//  }
//
//  /// ported from Java's BigInteger.toByteArray(); implementation
//  ///
//  ///  Returns a byte array containing the two's-complement
//  ///  representation of this BigInteger.  The byte array will be in
//  ///  <i>big-endian</i> byte-order: the most significant byte is in
//  ///  the zeroth element.  The array will contain the minimum number
//  ///  of bytes required to represent this BigInteger, including at
//  ///  least one sign bit, which is {@code (ceil((this.bitLength() +
//  ///  1)/8))}.
//  static Uint8List originalBigIntToByteArray(final BigInt input) {
//    final int byteLen = (input.bitLength / 8 + 1).round();
//    final Uint8List byteArray = new Uint8List(byteLen);
//
//    for (int i=byteLen-1, bytesCopied=4, nextInt=0, intIndex=0; i >= 0; i--) {
//      if (bytesCopied == 4) {
//        nextInt = getIntOfBigInt(intIndex++);
//        bytesCopied = 1;
//      } else {
//        nextInt = nextInt >> 8;
//    bytesCopied++;
//    }
//    byteArray[i] = nextInt;
//    }
//    return byteArray;
//  }
//
//   /// ported from Java's BigInteger.getInt(); implementation
//   ///
//   /// Returns the specified int of the little-endian two's complement
//   /// representation (int 0 is the least significant).  The int number can
//   /// be arbitrarily high (values are logically preceded by infinitely many
//   /// sign ints).
//  static int getIntOfBigInt(int n, BigInt bigInt) {
//    if (n < 0)
//      return 0;
//    if (n >= bigInt.mag.length)
//      return signInt();
//
//    int magInt = mag[mag.length-n-1];
//
//    return (signum >= 0 ? magInt :
//    (n <= firstNonzeroIntNum() ? -magInt : ~magInt));
//  }
}
