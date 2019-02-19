library nem2_sdk_dart.core.utils.array_utils;

/// A collection of utility functions to manipulate arrays.
class ArrayUtils {
  /// Copies elements from the source array to a destination array.
  static void copy(List<int> dest, List<int> source,
      {final int numElementsToCopy = 0, final int destOffset = 0, final int srcOffset = 0}) {
    final int length = numElementsToCopy == 0 ? dest.length : numElementsToCopy;
    for (int i = 0; i < length; i++) {
      dest[destOffset + i] = source[srcOffset + i];
    }
  }

  /// Determines whether or not an array is zero-filled.
  /// Returns true if all elements of the array is zero-filled, false otherwise.
  static bool isZero(List<int> input) {
    return input.every((value) => (0 == value));
  }

  /// Returns true if two specified arrays of bytes are equal to one another.
  ///
  /// Two arrays are considered equal if both arrays contain the same number
  /// of elements, and all corresponding pairs of elements in the two arrays
  /// are equal.  In other words, two arrays are equal if they contain the
  /// same elements in the same order.  Also, two array references are
  /// considered equal if both are null
  static bool deepEqual(List<int> first, List<int> second, {final int numElementsToCompare = 0}) {
    // type comparison
    if (first.hashCode == second.hashCode) {
      return true;
    }
    if (first == null || second == null) {
      return false;
    }

    // length comparison
    int length = numElementsToCompare;
    if (numElementsToCompare == 0) {
      if (first.length != second.length) {
        return false;
      }

      length = first.length;
    }
    if (length > first.length || length > second.length) {
      return false;
    }

    // value comparison
    for (int i = 0; i < length; i++) {
      if (first[i] != second[i]) {
        return false;
      }
    }

    return true;
  }
}
