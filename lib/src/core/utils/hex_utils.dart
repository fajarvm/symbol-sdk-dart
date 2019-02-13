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
    return utf8.decode(encodedString.codeUnits);
  }

  /// Determines whether or not an [input] string is a hex string.
  static bool isHexString(final String input) {
    if (0 != (input.length % 2)) {
      return false;
    }

    for (int i = 0; i < input.length; i += 2) {
      // TODO: check hext string char
    }
  }

  // -------------------- private / protected functions -------------------- //

  static List<int> _getBytesInternal(final String hexString) {
    final String paddedHexString = 0 == hexString.length % 2 ? hexString : "0" + hexString;
    final List<int> encodedBytes = utf8.encode(paddedHexString);
    return hex.decode(String.fromCharCodes(encodedBytes));
  }
}
