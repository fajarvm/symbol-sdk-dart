part of nem2_sdk_dart.core.utils;

/// A collection of utility functions to manipulate a String
class StringUtils {
  static final String EMPTY_STRING = "";
  static final RegExp WHITESPACE = new RegExp(r'\\s');

  /// Remove all whitespaces from a String.
  /// That includes leading, trailing and in-between characters in the String.
  static String removeAllWhitespaces(String input) {
    return (input == null) ? EMPTY_STRING : input.replaceAll(WHITESPACE, "");
  }

  /// Remove leading whitespaces
  static String trimLeft(String input) {
    return (input == null) ? EMPTY_STRING : input.trimLeft();
  }

  /// Remove trailing whitespaces
  static String trimRight(String input) {
    return (input == null) ? EMPTY_STRING : input.trimRight();
  }

  /// Parse a String to a int
  static int parseInt(String input) {
    return (input == null) ? null : int.parse(input);
  }
}
