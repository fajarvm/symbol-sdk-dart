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

library nem2_sdk_dart.core.utils.string_utils;

/// A collection of utility functions to manipulate a String.
class StringUtils {
  static const String EMPTY_STRING = '';
  static final RegExp WHITESPACE = new RegExp(r'\s+\b|\b\s+');

  /// Removes all whitespaces from a String.
  /// That includes leading, trailing and in-between characters in the String.
  static String removeAllWhitespaces(String input) =>
      (input == null || input.isEmpty) ? EMPTY_STRING : input.replaceAll(WHITESPACE, '');

  /// Removes leading and trailing whitespaces.
  static String trim(final String input) => (input == null) ? EMPTY_STRING : input.trim();

  /// Removes leading whitespaces.
  static String trimLeft(final String input) => (input == null) ? EMPTY_STRING : input.trimLeft();

  /// Removes trailing whitespaces.
  static String trimRight(final String input) => (input == null) ? EMPTY_STRING : input.trimRight();

  /// Determines whether an [input] string is empty or not. Returns true if it's empty.
  /// Unlike the built-in `String.isEmpty`, this method trims the input string first.
  static bool isEmpty(final String input) {
    final String trimmed = trim(input);
    return trimmed == null || trimmed.isEmpty;
  }

  /// Determines whether an [input] string is empty or not. Returns true if it's not empty.
  static bool isNotEmpty(final String input) => !isEmpty(input);

  /// Parses a String to a int. Returns null
  static int parseIntOrNull(final String input) {
    final String cleanInput = removeAllWhitespaces(input);
    return (cleanInput == null || cleanInput == EMPTY_STRING) ? null : int.parse(cleanInput);
  }

  /// Left pad an [input] string with a specified character until the specified length.
  ///
  /// Default character is spaces (' ').
  static String padLeft(final String input, final int length, [final String padChar = ' ']) {
    return '${_pad(input, length, padChar)}$input';
  }

  /// Right pad an [input] string with a specified character until the specified length.
  ///
  /// Default character is spaces (' ').
  static String padRight(final String input, final int length, [final String padChar = ' ']) {
    return '$input${_pad(input, length, padChar)}';
  }

  // ------------------------------ private / protected functions ------------------------------ //

  static String _pad(final String input, final int length, [final String padChar = ' ']) {
    return new List.filled(length - input.length, padChar).join();
  }
}
