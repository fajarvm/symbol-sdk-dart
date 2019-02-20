library nem2_sdk_dart.core.utils.byte_utils;

/// A collection of utility functions to manipulate bytes
class ByteUtils {
  /// Convert a byte array into a hex string
  static String bytesToHex(List<int> bytes) {
    var result = new StringBuffer();
    for (var part in bytes) {
      result.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
    }
    return result.toString();
  }

  /// Converts a byte array into a [BigInt]
  static BigInt bytesToBigInt(final List<int> bytes) {
    if (bytes == null || bytes.length == 0) {
      return BigInt.zero;
    }

    int v = 0;
    for (int byte in bytes) {
      v = (v << 8) | (byte & 0xFF);
    }

    return BigInt.from(v);
  }

  /// Converts a [BigInt] to big endian bytes
  static List<int> bigIntToByteArray(BigInt input) {
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
    List bytes;
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
        int byte = ~int.parse(str.substring(p + (i << 1), p + (i << 1) + 2), radix: 16);
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
        int byte = int.parse(str.substring(p + (i << 1), p + (i << 1) + 2), radix: 16);
        if (byte > 127) byte -= 256;
        bytes[i + boff] = byte;
      }
    }
    return bytes;
  }
}
