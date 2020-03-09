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

library symbol_sdk_dart.test.core.utils.array_utils_test;

import 'package:test/test.dart';

import 'package:symbol_sdk_dart/core.dart' show ArrayUtils;

void main() {
  group('copy()', () {
    test('default optional parameter values', () {
      List<int> source = [4, 2, 0];
      List<int> destination = [null, null, null, null];

      ArrayUtils.copy(destination, source);
      // Expect all source elements to be copied over.
      expect(destination[0], 4);
      expect(destination[1], 2);
      expect(destination[2], 0);
      expect(destination[3], null);
    });

    test('custom parameter value: length', () {
      List<int> source = [4, 2, 0];
      List<int> destination = [null, null, null, null];

      ArrayUtils.copy(destination, source, numOfElements: 2);
      // Expect the first two elements of source array to be copied over.
      expect(destination[0], 4);
      expect(destination[1], 2);
      expect(destination[2], null);
      expect(destination[3], null);
    });

    test('custom parameter value: offsets', () {
      List<int> source = [4, 2, 0];
      List<int> destination = [null, null, null, null];

      ArrayUtils.copy(destination, source, numOfElements: 2, srcOffset: 1);
      // Expect the first two elements of source array to be copied over.
      expect(destination[0], 2);
      expect(destination[1], 0);
      expect(destination[2], null);
      expect(destination[3], null);

      // reset destination
      destination = [null, null, null, null];

      ArrayUtils.copy(destination, source, numOfElements: 2, srcOffset: 1, destOffset: 2);
      // Expect the first two elements of source array to be copied over.
      expect(destination[0], null);
      expect(destination[1], null);
      expect(destination[2], 2);
      expect(destination[3], 0);
    });

    test('cannot copy empty or non-fixed length array', () {
      List<int> source, destination;
      expect(
          () => ArrayUtils.copy(destination, source),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));

      source = [];
      expect(
          () => ArrayUtils.copy(destination, source),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));

      destination = [];
      expect(
          () => ArrayUtils.copy(destination, source),
          throwsA(predicate((e) =>
              e is ArgumentError && e.message.toString().contains('must have a fixed-length'))));
    });

    test('cannot use negative value parameters', () {
      List<int> source = [4, 2, 0];
      List<int> destination = [null, null, null, null];

      expect(
          () => ArrayUtils.copy(destination, source, numOfElements: -1),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message.toString().contains('Negative value is not accepted'))));

      expect(
          () => ArrayUtils.copy(destination, source, destOffset: -1),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message.toString().contains('Negative value is not accepted'))));

      expect(
          () => ArrayUtils.copy(destination, source, srcOffset: -1),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message.toString().contains('Negative value is not accepted'))));
    });
  });

  group('copyOfRange()', () {
    test('can copy specified range into a new array', () {
      List<int> source = [4, 2, 0];

      List<int> result = ArrayUtils.copyOfRange(source, 0, 2);
      expect(result.length, 2);
      expect(result[0], 4);
      expect(result[1], 2);
    });

    test('can copy specified range from a specific index', () {
      List<int> source = [4, 2, 0];
      List<int> result = ArrayUtils.copyOfRange(source, 1, 3);
      expect(result.length, 2);
      expect(result[0], 2);
      expect(result[1], 0);
    });

    test('cannot copy range at negative value index', () {
      List<int> source = [4, 2, 0];
      expect(
          () => ArrayUtils.copyOfRange(source, -1, 0),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Negative value'))));
      expect(
          () => ArrayUtils.copyOfRange(source, 0, -1),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Negative value'))));
    });

    test('cannot copy range from a large to small index', () {
      List<int> source = [4, 2, 0];
      expect(
          () => ArrayUtils.copyOfRange(source, 1, 0),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message.toString().contains('From index is larger than to index'))));
    });
  });

  group('isZero()', () {
    test('can determine that an array is zero filled', () {
      List<int> array = [0, 0, 0, 0, 0];
      bool isZeroFilled = ArrayUtils.isZero(array);
      expect(isZeroFilled, isTrue);

      array = [0, 0, 0, 1];
      isZeroFilled = ArrayUtils.isZero(array);
      expect(isZeroFilled, isFalse);

      array = [null, 0, 0, 0];
      isZeroFilled = ArrayUtils.isZero(array);
      expect(isZeroFilled, isFalse);
    });
  });

  group('deepEqual()', () {
    test('compare two arrays', () {
      List<int> array1 = [0, 0, 0, 0, 1];
      List<int> array2 = [0, 0, 0, 0, 1];
      bool isEqual = ArrayUtils.deepEqual(array1, array2);
      expect(isEqual, isTrue);

      array2 = [0, 0, 0, 1, 1];
      isEqual = ArrayUtils.deepEqual(array1, array2);
      expect(isEqual, isFalse);

      array2 = null;
      isEqual = ArrayUtils.deepEqual(array1, array2);
      expect(isEqual, isFalse);
    });

    test('compare a number of elements between ', () {
      List<int> array1 = [0, 0, 0, 0, 1];
      List<int> array2 = [0, 0, 0, 0, 1];
      bool isEqual = ArrayUtils.deepEqual(array1, array2, numElementsToCompare: 2);
      expect(isEqual, isTrue);

      array2 = [0, 0, 1, 1, 1];
      isEqual = ArrayUtils.deepEqual(array1, array2, numElementsToCompare: 2);
      expect(isEqual, isTrue);

      isEqual = ArrayUtils.deepEqual(array1, array2, numElementsToCompare: 3);
      expect(isEqual, isFalse);
    });
  });
}
