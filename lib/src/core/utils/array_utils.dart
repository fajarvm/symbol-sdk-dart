library nem2_sdk_dart.core.utils.array_utils;

import 'dart:typed_data' show Uint8List;

import 'byte_utils.dart';

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

  /// Duplicates a given byte array.
  static Uint8List duplicate(final Uint8List source) {
    final Uint8List copy = new Uint8List(source.length);
    for (var element in source.toList()) {
      copy.add(element);
    }
    return copy;
  }

  /// Converts a BigInteger to a little endian byte array.
  static Uint8List toByteArray(final BigInt value, final int numBytes) {
    final Uint8List outputBytes = new Uint8List(numBytes);
    final Uint8List bigIntegerBytes = ByteUtils.bigIntToBytes(value);

    int copyStartIndex = (0x00 == bigIntegerBytes[0]) ? 1 : 0;
    int numBytesToCopy = bigIntegerBytes.length - copyStartIndex;
    if (numBytesToCopy > numBytes) {
      copyStartIndex += numBytesToCopy - numBytes;
      numBytesToCopy = numBytes;
    }

    for (int i = 0; i < numBytesToCopy; ++i) {
      outputBytes[i] = bigIntegerBytes[copyStartIndex + numBytesToCopy - i - 1];
    }

    return outputBytes;
  }

  /// Constant-time byte[] comparison.
  /// The constant time behavior eliminates side channel attacks.
  static int isEqualConstantTime(final Uint8List b, final Uint8List c) {
    int result = 0;
    result |= b.length - c.length;
    for (int i = 0; i < b.length; i++) {
      result |= b[i] ^ c[i];
    }

    return ByteUtils.isEqualConstantTime(result, 0);
  }

  /// Gets the i'th bit of a byte array.
  static int getBit(final Uint8List h, final int i) {
    return (h[i >> 3] >> (i & 7)) & 1;
  }

  /// Creates a List of int with 0 as the default value instead of null.
  ///
  /// This is a workaround to the fact that all variables in DartVM are
  /// nullable, including the seemingly "primitive" types like int, bool, etc.
  /// When compiled, all nulls will then be set to target-code's default value.
  /// For example, in Java, int wll be set to 0, and bool will be set to false.
  static List<int> createInstantiatedListInt(size) {
    return List<int>.generate(size, (index) => 0);
  }

  static Uint8List createInstantiatedUint8List(size) {
    return ByteUtils.bytesFromList(createInstantiatedListInt(size));
  }

  /// Sets null values to 0.
  static void replaceNullWithZero(List<int> values) {
    for (var value in values) {
      if (value == null) {
        value = 0;
      }
    }
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
