//
// Copyright (c) 2019 Fajar van Megen
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

library nem2_sdk_dart.core.utils.hex_utils;

import 'dart:convert' show utf8;

import 'package:convert/convert.dart' show hex;

/// A utility class that provides functions for converting hex strings.
class HexUtils {
  const HexUtils();

  /// Converts [hexString] to a byte array.
  static List<int> getBytes(final String hexString) {
    try {
      return _getBytesInternal(hexString);
    } catch (e) {
      throw new ArgumentError(e);
    }
  }

  /// Tries to convert [hexString] to a byte array.
  /// The output will be null if the input is malformed.
  static List<int> tryGetBytes(final String hexString) {
    try {
      return _getBytesInternal(hexString);
    } catch (e) {
      return null;
    }
  }

  /// Converts byte array to a hex string.
  static String getString(final List<int> bytes) {
    final String encodedString = hex.encode(bytes);
    return utf8.decode(encodedString.codeUnits);
  }

  /// Determines whether or not an [input] string is a hex string.
  static bool isHexString(final String input) {
    if (0 != (input.length % 2)) {
      return false;
    }

    // A valid hex consists of two hex characters
    // for (int i = 0; i < input.length; i += 2) {
    // // validate two hex chars (input[i] and input[i+1])
    // }

    return tryGetBytes(input) == null ? false : true;
  }

  /// Converts a UTF-8 [input] string to hex string.
  static String utf8ToHex(final String input) {
    final StringBuffer sb = new StringBuffer();
    final String rawString = _rawStringToUtf8(input);
    for (int i = 0; i < rawString.length; i++) {
      sb.write(rawString.codeUnitAt(i).toRadixString(16));
    }
    return sb.toString();
  }

  /// Convert a byte array [bytes] into a hex string
  static String bytesToHex(List<int> bytes) {
    var result = new StringBuffer();
    for (var part in bytes) {
      result.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
    }
    return result.toString();
  }

  // ------------------------------ private / protected functions ------------------------------ //

  /// Converts a hex string into byte array. Also tries to correct malformed hex string.
  static List<int> _getBytesInternal(final String hexString) {
    final String paddedHexString = 0 == hexString.length % 2 ? hexString : "0" + hexString;
    final List<int> encodedBytes = utf8.encode(paddedHexString);
    return hex.decode(String.fromCharCodes(encodedBytes));
  }

  /// Converts raw string into a string of single byte characters using UTF-8 encoding.
  static String _rawStringToUtf8(final String input) {
    final StringBuffer sb = new StringBuffer();
    for (int i = 0; i < input.length; i++) {
      final int cu = input.codeUnitAt(i);

      if (128 > cu) {
        sb.write(String.fromCharCode(cu));
      } else if ((127 < cu) && (2048 > cu)) {
        sb.write(String.fromCharCode((cu >> 6) | 192));
        sb.write(String.fromCharCode((cu & 63) | 128));
      } else {
        sb.write(String.fromCharCode((cu >> 12) | 224));
        sb.write(String.fromCharCode(((cu >> 6) & 63) | 128));
        sb.write(String.fromCharCode((cu & 63) | 128));
      }
    }

    return sb.toString();
  }
}
