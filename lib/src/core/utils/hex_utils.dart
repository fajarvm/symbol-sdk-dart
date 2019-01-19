library nem2_sdk_dart.core.utils.hex_utils;

import 'dart:convert' show utf8;
import 'package:convert/convert.dart' show hex;

/// A utility class that provides functions for converting hex strings
class HexUtils {
  const HexUtils();

  /// Converts a hex string to a byte array.
  static List<int> getBytes(final String hexString) {
    try {
      return _getBytesInternal(hexString);
    } catch (e) {
      throw new ArgumentError(e);
    }
  }

  /// Converts a hex string to a byte array.
  /// The output will be null if the input is malformed
  static List<int> tryGetBytes(final String hexString) {
    try {
      return _getBytesInternal(hexString);
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

  static List<int> _getBytesInternal(final String hexString) {
    final String paddedHexString =
        0 == hexString.length % 2 ? hexString : "0" + hexString;
    final List<int> encodedBytes = utf8.encode(paddedHexString);
    return hex.decode(String.fromCharCodes(encodedBytes));
  }
}
