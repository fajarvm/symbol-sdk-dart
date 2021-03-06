//
// Copyright (c) 2020 Fajar van Megen
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

library symbol_sdk_dart.core.utils.base32;

import 'dart:typed_data' show Uint8List;

import 'hex_utils.dart';

/// A utility class that provides functions for converting base32 strings.
class Base32 {
  static const int DECODED_BLOCK_SIZE = 5;
  static const int ENCODED_BLOCK_SIZE = 8;

  static const ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  // TODO: illegal characters are currently converted into 0xFF
  static const DIGIT_LOOKUP_TABLE = [
    /// '0', '1', '2', '3', '4', '5', '6', '7'
    0xFF, 0xFF, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F,

    /// '8', '9', ':', ';', '<', '=', '>', '?'
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,

    /// '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G'
    0xFF, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06,

    /// 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O'
    0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E,

    /// 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W'
    0x0F, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16,

    /// 'X', 'Y', 'Z', '[', '\', ']', '^', '_'
    0x17, 0x18, 0x19, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,

    /// '`', 'a', 'b', 'c', 'd', 'e', 'f', 'g'
    0xFF, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06,

    /// 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o'
    0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E,

    /// 'p', 'q', 'r', 's', 't', 'u', 'v', 'w'
    0x0F, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16,

    /// 'x', 'y', 'z', '{', '|', '}', '~', 'DEL'
    0x17, 0x18, 0x19, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
  ];

  /// Converts a [bytesList] to a [String] representation of the base32.
  ///
  /// The list of integer [bytesList] is converted into [Uint8List] first
  /// to perform bit operations on.
  static String encode(final List<int> bytesList) {
    if (0 != bytesList.length % DECODED_BLOCK_SIZE) {
      throw ArgumentError(
          'Decoded size must be multiple of $DECODED_BLOCK_SIZE');
    }

    final Uint8List bytes = new Uint8List(bytesList.length);
    bytes.setRange(0, bytes.length, bytesList, 0);
    int i = 0, index = 0, digit = 0;
    int currByte, nextByte;
    StringBuffer sb = new StringBuffer();

    while (i < bytes.length) {
      currByte = bytes[i];

      if (index > 3) {
        if ((i + 1) < bytes.length) {
          nextByte = bytes[i + 1];
        } else {
          nextByte = 0;
        }

        digit = currByte & (0xFF >> index);
        index = (index + 5) % ENCODED_BLOCK_SIZE;
        digit <<= index;
        digit |= nextByte >> (ENCODED_BLOCK_SIZE - index);
        i++;
      } else {
        digit = currByte >> (ENCODED_BLOCK_SIZE - (index + DECODED_BLOCK_SIZE)) & 0x1F;
        index = (index + DECODED_BLOCK_SIZE) % ENCODED_BLOCK_SIZE;
        if (index == 0) {
          i++;
        }
      }
      sb.write(ALPHABET[digit]);
    }
    return sb.toString();
  }

  /// Converts a [hex] to a [String] representation of the base32 bytes.
  static String encodeHexString(final String hex) {
    final Uint8List bytes = HexUtils.getBytes(hex);
    return encode(bytes);
  }

  /// Converts a [base32Encoded] string into a [Uint8List] bytes.
  static Uint8List decode(final String base32Encoded) {
    if (0 != base32Encoded.length % ENCODED_BLOCK_SIZE) {
      throw ArgumentError(
          'Encoded size must be multiple of $ENCODED_BLOCK_SIZE');
    }

    int index = 0, lookup, offset = 0, digit;
    final Uint8List bytes = new Uint8List(
        base32Encoded.length * DECODED_BLOCK_SIZE ~/ ENCODED_BLOCK_SIZE);

    for (int i = 0; i < bytes.length; i++) {
      bytes[i] = 0;
    }

    for (int i = 0; i < base32Encoded.length; i++) {
      lookup = base32Encoded.codeUnitAt(i) - '0'.codeUnitAt(0);
      if (lookup < 0 || lookup >= DIGIT_LOOKUP_TABLE.length) {
        throw ArgumentError(
            'illegal base32 character ${base32Encoded[i]}');
      }

      digit = DIGIT_LOOKUP_TABLE[lookup];
      if (digit == 0xFF) {
        throw ArgumentError(
            'illegal base32 character ${base32Encoded[i]}');
      }

      if (index <= 3) {
        index = (index + DECODED_BLOCK_SIZE) % ENCODED_BLOCK_SIZE;
        if (index == 0) {
          bytes[offset] |= digit;
          offset++;
          if (offset >= bytes.length) {
            break;
          }
        } else {
          bytes[offset] |= digit << (ENCODED_BLOCK_SIZE - index);
        }
      } else {
        index = (index + DECODED_BLOCK_SIZE) % ENCODED_BLOCK_SIZE;
        bytes[offset] |= digit >> index;
        offset++;

        if (offset >= bytes.length) {
          break;
        }

        bytes[offset] |= digit << (ENCODED_BLOCK_SIZE - index);
      }
    }
    return bytes;
  }
}
