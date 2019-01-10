library nem2_sdk_dart.core.utils.hex_utils;

import 'dart:convert' show utf8;
import 'dart:typed_data' show Uint8List;

import 'package:convert/convert.dart' show hex;

/// A utility class that provides functions for converting hex strings
class HexUtils {

  /// Converts a [hexString] to [Uint8List]
  static Uint8List hexStringToBytes(final String hexString) {
    int i = 0;
    final Uint8List bytes = new Uint8List(hexString.length ~/ 2);
    final RegExp regex = new RegExp('[0-9a-f]{2}');
    for (Match match in regex.allMatches(hexString.toLowerCase())) {
      bytes[i++] = int.parse(
          hexString.toLowerCase().substring(match.start, match.end),
          radix: 16);
    }
    return bytes;
  }

  /// Converts a hex string to a byte array.
  static List<int> getBytes(final String hexString) {
    try {
      return getBytesInternal(hexString);
    } catch (e) {
      throw new ArgumentError(e);
    }
  }

  /// Converts a hex string to a byte array.
  /// The output will be null if the input is malformed
  static List<int> tryGetBytes(final String hexString) {
    try {
      return getBytesInternal(hexString);
    } catch (e) {
      return null;
    }
  }

  /// Converts a byte array to a hex string.
  static String getString(final List<int> bytes) {
    final String encodedString = hex.encode(bytes);
    final List<int> decodedBytes = new List<int>();
    for (var i = 0; i < encodedString.length; i++) {
      decodedBytes.add(encodedString.codeUnitAt(i));
    }
    return utf8.decode(decodedBytes);
  }

  // -------------------- private / protected functions -------------------- //

  static List<int> getBytesInternal(final String hexString) {
    final String paddedHexString =
        0 == hexString.length % 2 ? hexString : "0" + hexString;
    final List<int> encodedBytes = utf8.encode(paddedHexString);
    final StringBuffer sb = new StringBuffer();
    for (int byte in encodedBytes) {
      sb.writeCharCode(byte);
    }
    return hex.decode(sb.toString());
  }
}
