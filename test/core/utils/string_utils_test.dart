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

library symbol_sdk_dart.test.core.utils.string_utils_test;

import 'package:test/test.dart';

import 'package:symbol_sdk_dart/core.dart' show StringUtils;

void main() {
  group('StringUtils', () {
    test('valid constants', () {
      expect(StringUtils.EMPTY_STRING, equals(''));
      expect(StringUtils.WHITESPACE.hasMatch('^_^'), isFalse);
      expect(StringUtils.WHITESPACE.hasMatch('   carriage return\r   '), isTrue);
    });

    test('removeAllWhitespaces() can remove all whitespaces inside a string', () {
      expect(StringUtils.removeAllWhitespaces(null), equals(StringUtils.EMPTY_STRING));
      expect(StringUtils.removeAllWhitespaces('   \t\r\nte  st   '), equals('test'));
    });

    test('trim() can remove leading and trailing whitespaces', () {
      expect(StringUtils.trim('   \t\r\nte  st\t\r\n   '), equals('te  st'));
    });

    test('trimLeft() can remove leading whitespaces', () {
      expect(StringUtils.trimLeft('   \t\r\nte  st\t\r\n   '), equals('te  st\t\r\n   '));
    });

    test('trimRight() can remove trailing whitespaces', () {
      expect(StringUtils.trimRight('   \t\r\nte  st\t\r\n   '), equals('   \t\r\nte  st'));
    });

    test('isEmpty()', () {
      expect('   '.isEmpty, isFalse); // Dart's built-in is not clearing any whitespaces
      expect(StringUtils.isEmpty('  \t\r\n  '), isTrue);
    });

    test('isNotEmpty()', () {
      expect('   '.isNotEmpty, isTrue);
      expect(StringUtils.isNotEmpty('  \t\r\n  '), isFalse);
    });

    test('parseIntOrNull() can parse a string into an int', () {
      expect(StringUtils.parseIntOrNull(null), equals(null));
      expect(StringUtils.parseIntOrNull('  100  '), equals(100));
    });

    test('padLeft() can left pad a string', () {
      // Pad with default pad character
      String actual = StringUtils.padLeft('hello', 16);
      expect(actual, equals('           hello'));
      expect(actual.length, equals(16));

      // Pad with custom pad character
      actual = StringUtils.padLeft('12345', 16, '0');
      expect(actual, equals('0000000000012345'));
      expect(actual.length, equals(16));
    });

    test('padRight() can right pad a string', () {
      // Pad with default pad character
      String actual = StringUtils.padRight('hello', 16);
      expect(actual, equals('hello           '));
      expect(actual.length, equals(16));

      // Pad with custom pad character
      actual = StringUtils.padRight('12345', 16, '0');
      expect(actual, equals('1234500000000000'));
      expect(actual.length, equals(16));
    });
  });
}
