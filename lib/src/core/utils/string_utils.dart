library nem2_sdk_dart.core.utils.string_utils;

// TODO: DELETE ME? I think this class is obsolete. Dart core provides solid string util methods.
/// A collection of utility functions to manipulate a String.
class StringUtils {
  static const String EMPTY_STRING = '';
  static final RegExp WHITESPACE = new RegExp(r'\\s');

  /// Removes all whitespaces from a String.
  /// That includes leading, trailing and in-between characters in the String.
  static String removeAllWhitespaces(String input) {
    return (input == null) ? EMPTY_STRING : input.replaceAll(WHITESPACE, '');
  }

  /// Removes leading whitespaces.
  static String trimLeft(String input) {
    return (input == null) ? EMPTY_STRING : input.trimLeft();
  }

  /// Removes trailing whitespaces.
  static String trimRight(String input) {
    return (input == null) ? EMPTY_STRING : input.trimRight();
  }

  /// Parses a String to a int.
  static int parseInt(String input) {
    return (input == null) ? null : int.parse(input);
  }
}
