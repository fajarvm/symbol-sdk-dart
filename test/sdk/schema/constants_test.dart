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

library nem2_sdk_dart.test.sdk.schema.constants_test;

import 'package:nem2_sdk_dart/sdk.dart' show Constants;
import 'package:test/test.dart';

void main() {
  group('Constants', () {
    test('creating a new instance returns a singleton', () {
      final type1 = new Constants();
      final type2 = new Constants();

      expect(identical(type1, type2), isTrue);
    });
    test('valid constants', () {
      expect(Constants.SIZEOF_BYTE, 1);
      expect(Constants.SIZEOF_SHORT, 2);
      expect(Constants.SIZEOF_INT, 4);
      expect(Constants.SIZEOF_FLOAT, 4);
      expect(Constants.SIZEOF_LONG, 8);
      expect(Constants.SIZEOF_DOUBLE, 8);
      expect(Constants.FILE_IDENTIFIER_LENGTH, 4);
    });

    test('Can retrieve a valid constant value', () {
      expect(Constants.getValue(1), Constants.SIZEOF_BYTE);
      expect(Constants.getValue(2), Constants.SIZEOF_SHORT);
      expect(Constants.getValue(4), Constants.SIZEOF_INT);
      expect(Constants.getValue(8), Constants.SIZEOF_LONG);
    });

    test('Trying to retrieve an unknown constant value will throw an error', () {
      expect(() => Constants.getValue(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'unknown schema constant')));
      expect(() => Constants.getValue(0),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'unknown schema constant')));
      expect(() => Constants.getValue(3),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'unknown schema constant')));
    });
  });
}
