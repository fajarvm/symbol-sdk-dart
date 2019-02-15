library nem2_sdk_dart.core.utils.byte_utils;

import 'dart:math' show pow;
import 'dart:typed_data' show Uint8List;


// TODO: DELETE ME? I think this class is obsolete..
/// A collection of utility functions to manipulate bytes.
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

  /// Converts a byte array to a BigInt. Negative is preserved.
  static BigInt toBigInt(List<int> s, {bool fixSign = false}) {
    int data = 0;
    if (s == null || s.length == 0) {
      return BigInt.zero;
    }
    bool neg = false;
    int v = 0;
    if (!fixSign && s[0] & 0xFF > 0x7F) {
      neg = true;
    }
    if (neg) {
      for (int byte in s) {
        v = (v << 8) | (~((byte & 0xFF) - 256));
      }
      data = ~v;
    } else {
      for (int byte in s) {
        v = (v << 8) | (byte & 0xFF);
      }
      data = v;
    }

    return BigInt.from(data);
  }

  /// Converts a byte array to a BigInt (unsigned).
  static BigInt toBigIntUnsigned(final List<int> bytes) {
    BigInt b = BigInt.zero;
    for (int i = 0; i < bytes.length; i++) {
      b += BigInt.one * BigInt.from(bytes[i] & 0xff) << (i * 8);
    }

    return b;
  }

  // Copied from package:dart-cryptoutils by stevenroose.
  /// Converts a big integer into a byte array
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
}
