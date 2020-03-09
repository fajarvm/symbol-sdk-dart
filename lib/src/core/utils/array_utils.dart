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

library symbol_sdk_dart.core.utils.array_utils;

import 'dart:math' show min;

/// A collection of utility functions to manipulate arrays.
class ArrayUtils {
  /// Copies elements from the [source] array to the [destination] array.
  ///
  /// Both the [source] and the [destination] array must have a fixed-length.
  /// If [numOfElements] is not given, it will try to copy all elements from the [source] array.
  ///
  /// Warning: Any occurred index out-of-bound error will exit the process. And the already copied
  /// elements will not be rolled back.
  static void copy(List<int> destination, List<int> source,
      {int numOfElements = 0, final int destOffset = 0, final int srcOffset = 0}) {
    ArgumentError.checkNotNull(source);
    ArgumentError.checkNotNull(destination);

    if (source.isEmpty || destination.isEmpty) {
      throw new ArgumentError('The source and destination array must have a fixed-length.');
    }

    if (numOfElements < 0 || destOffset < 0 || srcOffset < 0) {
      throw new ArgumentError('Negative value is not accepted.');
    }

    // By default, copy all source elements.
    if (numOfElements == 0) {
      // Ensure the length to be within destination's range.
      numOfElements = source.length <= destination.length ? source.length : destination.length;
    }

    for (int i = 0; i < numOfElements; i++) {
      // will throw an error when index is out of bound
      destination[destOffset + i] = source[srcOffset + i];
    }
  }

  /// Copies the specified range of the specified array into a new array.
  static List<int> copyOfRange(List<int> original, int fromIndex, int toIndex) {
    ArgumentError.checkNotNull(original);

    if (fromIndex < 0 || toIndex < 0) {
      throw new ArgumentError('Negative value is not accepted.');
    }

    final int newLength = toIndex - fromIndex;
    if (newLength < 0) {
      throw new ArgumentError('From index is larger than to index: $fromIndex > $toIndex');
    }
    List<int> result = List<int>(newLength);
    final int toCopy = min(original.length - fromIndex, newLength);
    copy(result, original, numOfElements: toCopy, destOffset: 0, srcOffset: fromIndex);

    return result;
  }

  /// Determines whether or not an array is zero-filled.
  /// Returns true if all elements of the array is zero-filled, false otherwise.
  static bool isZero(List<int> input) => input.every((value) => 0 == value);

  /// Returns true if two specified arrays of bytes are equal to one another.
  ///
  /// Two arrays are considered equal if both arrays contain the same number
  /// of elements, and all corresponding pairs of elements in the two arrays
  /// are equal.  In other words, two arrays are equal if they contain the
  /// same elements in the same order.  Also, two array references are
  /// considered equal if both are null
  static bool deepEqual(List first, List second, {final int numElementsToCompare = 0}) {
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
