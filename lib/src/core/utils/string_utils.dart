library nem2_sdk_dart.core.utils.string_utils;

// TODO: DELETE ME? I think this class is obsolete. Dart core provides solid string util methods.
/// A collection of utility functions to manipulate a String.
class StringUtils {
  static const String EMPTY_STRING = '';
  static final RegExp WHITESPACE = new RegExp(r'\\s');

  /// Removes all whitespaces from a String.
  /// That includes leading, trailing and in-between characters in the String.
  static String removeAllWhitespaces(String input) {
    return (input == null || input.isEmpty) ? EMPTY_STRING : input.replaceAll(WHITESPACE, '');
  }

  /// Removes leading and trailing whitespaces.
  static String trim(final String input) {
    return trimLeft(trimRight(input));
  }

  /// Removes leading whitespaces.
  static String trimLeft(final String input) {
    return (input == null) ? EMPTY_STRING : input.trimLeft();
  }

  /// Removes trailing whitespaces.
  static String trimRight(final String input) {
    return (input == null) ? EMPTY_STRING : input.trimRight();
  }

  /// Determines whether an [input] string is empty or not. Returns true if it's empty.
  /// Unlike the built-in `String.isEmpty`, this method trims the input string first.
  static bool isEmpty(final String input) {
    final String trimmed = trim(input);
    return trimmed == null || trimmed.isEmpty;
  }

  /// Determines whether an [input] string is empty or not. Returns true if it's not empty.
  static bool isNotEmpty(final String input) {
    return !isEmpty(input);
  }

  /// Parses a String to a int. Returns null
  static int parseIntOrNull(final String input) {
    final String cleanInput = removeAllWhitespaces(input);
    return (cleanInput == null) ? null : int.parse(cleanInput);
  }
}
