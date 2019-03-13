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

library nem2_sdk_dart.test.sdk.model.namespace.alias_type_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show AliasType;

void main() {
  group('AliasType', () {
    test('creating a new instance returns a singleton', () {
      final type1 = new AliasType();
      final type2 = new AliasType();

      expect(identical(type1, type2), isTrue);
    });

    test('valid alias types', () {
      expect(AliasType.NONE, 0);
      expect(AliasType.MOSAIC, 1);
      expect(AliasType.ADDRESS, 2);
    });

    test('Can retrieve a valid alias types', () {
      expect(AliasType.getType(0), AliasType.NONE);
      expect(AliasType.getType(1), AliasType.MOSAIC);
      expect(AliasType.getType(2), AliasType.ADDRESS);
    });

    test('Trying to retrieve an invalid alias type will throw an error', () {
      expect(() => AliasType.getType(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'invalid alias type')));
      expect(() => AliasType.getType(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'invalid alias type')));
      expect(() => AliasType.getType(3),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'invalid alias type')));
    });
  });
}
