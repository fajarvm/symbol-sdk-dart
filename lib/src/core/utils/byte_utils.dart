import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';

/// A utility class that provides functions for converting Bytes.
class ByteUtils {
  static List<String> hexArray = '0123456789ABCDEF'.split('');

  /// Decode a BigInt from bytes in big-endian encoding.
  static BigInt _decodeBigInt(List<int> bytes) {
    BigInt result = BigInt.from(0);
    for (int i = 0; i < bytes.length; i++) {
      result += BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
    }
    return result;
  }

  /// Converts a [Uint8List] to a hex string./
  static String bytesToHex(Uint8List bytes) {
    return hex.encode(bytes).toUpperCase();
  }

  /// Converts bytes to [BigInt].
  static BigInt bytesToBigInt(Uint8List bigIntBytes) {
    return _decodeBigInt(bigIntBytes);
  }

  /// Converts a hex string to a [Uint8List].
  static Uint8List hexToBytes(String hexString) {
    return Uint8List.fromList(hex.decode(hexString));
  }

  /// Converts a bigint to a byte array.
  static Uint8List bigIntToBytes(BigInt bigInt) {
    return hexToBytes(bigInt.toRadixString(16).padLeft(32, '0'));
  }

  /// Converts a hex string to a binary string.
  static String hexToBinary(String hexString) {
    return BigInt.parse(hexString, radix: 16).toRadixString(2);
  }

  /// Converts a binary string into a hex string.
  static String binaryToHex(String binary) {
    return BigInt.parse(binary, radix: 2).toRadixString(16).toUpperCase();
  }

  /// Reverse the bytes.
  static Uint8List reverse(Uint8List bytes) {
    Uint8List reversed = Uint8List(bytes.length);
    for (int i = bytes.length; i > 0; i--) {
      reversed[bytes.length - i] = bytes[i - 1];
    }
    return reversed;
  }

  /// Determines whether the [input] string is a valid hex string.
  static bool isHexString(String input) {
    List<String> hexChars = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F'
    ];
    for (int i = 0; i < input.length; i++) {
      if (!hexChars.contains(input[i])) {
        return false;
      }
    }
    return true;
  }

  /// Converts an integer to a byte array.
  static Uint8List intToBytes(int integer, int length) {
    Uint8List ret = Uint8List(length);
    for (int i = 0; i < length; i++) {
      ret[i] = integer & 0xff;
      integer = (integer - ret[i]) ~/ 256;
    }
    return reverse(ret);
  }

  /// Converts string to byte array.
  static Uint8List stringToBytesUtf8(String str) {
    return utf8.encode(str);
  }

  /// Converts byte array to string UTF-8.
  static String bytesToUtf8String(Uint8List bytes) {
    return utf8.decode(bytes);
  }

  /// Concatenates one or more byte arrays.
  static Uint8List concat(List<Uint8List> bytes) {
    String hex = '';
    bytes.forEach((v) {
      hex += bytesToHex(v);
    });
    return hexToBytes(hex);
  }
}
