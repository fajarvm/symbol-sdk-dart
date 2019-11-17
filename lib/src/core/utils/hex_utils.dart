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
  /// Converts [hex] string to a byte array.
  ///
  /// Throws an exception upon failing.
  static List<int> getBytes(final String hex) {
    try {
      return _getBytesInternal(hex);
    } catch (e) {
      throw new ArgumentError('Could not convert hex string into a byte array. Error: $e');
    }
  }

  /// Tries to convert [hex] string to a byte array.
  ///
  /// The output will be null if the input is malformed.
  static List<int> tryGetBytes(final String hex) {
    try {
      return _getBytesInternal(hex);
    } catch (e) {
      return null;
    }
  }

  /// Converts byte array to a hex string.
  static String getString(final List<int> bytes) {
    final String encodedString = hex.encode(bytes);
    return byteToUtf8(encodedString.codeUnits);
  }

  /// Determines whether or not an [input] string is a hex string.
  static bool isHex(final String input) {
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

  /// Tries to convert a [hex] string to a UTF-8 string.
  /// When it fails to decode UTF-8, it returns the non UTF-8 string instead.
  static String tryHexToUtf8(final String hex) {
    final List<int> codeUnits = _getCodeUnits(hex);
    try {
      return byteToUtf8(codeUnits);
    } catch (e) {
      return String.fromCharCodes(codeUnits);
    }
  }

  /// Converts a UTF-8 [input] string to an encoded byte array.
  static List<int> utf8ToByte(final String input) {
    return utf8.encode(input);
  }

  /// Converts an encoded byte array [input] to a UTF-8 string.
  static String byteToUtf8(final List<int> input) {
    return utf8.decode(input);
  }

  /// Convert a byte array [bytes] into a hex string
  static String bytesToHex(final List<int> bytes) {
    final StringBuffer result = new StringBuffer();
    for (var part in bytes) {
      result.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
    }
    return result.toString();
  }

  /// Returns the reversed order of the given [input] hex string.
  ///
  /// Throws an error if [input] could not be processed.
  static String reverseHexString(String input) {
    try {
      return getString(getBytes(input).reversed.toList());
    } catch (e) {
      throw ArgumentError('Failed reversing the input. Error: $e');
    }
  }

  // ------------------------------ private / protected functions ------------------------------ //

  /// Converts a hex string into byte array. Also tries to correct malformed hex string.
  static List<int> _getBytesInternal(final String hexString) {
    final String paddedHexString = 0 == hexString.length % 2 ? hexString : '0$hexString';
    final List<int> encodedBytes = utf8ToByte(paddedHexString);
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

  /// Get a list of code unit of a hex string.
  static List<int> _getCodeUnits(final String hex) {
    final List<int> codeUnits = <int>[];
    for (int i = 0; i < hex.length; i += 2) {
      codeUnits.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }

    return codeUnits;
  }
}
