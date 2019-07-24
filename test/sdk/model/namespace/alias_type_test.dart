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

import 'package:nem2_sdk_dart/sdk.dart' show AliasType;
import 'package:test/test.dart';

void main() {
  group('AliasType', () {
    test('valid alias types', () {
      expect(AliasType.NONE.value, 0);
      expect(AliasType.MOSAIC.value, 1);
      expect(AliasType.ADDRESS.value, 2);
    });

    test('Can retrieve a valid alias types', () {
      expect(AliasType.fromInt(0), AliasType.NONE);
      expect(AliasType.fromInt(1), AliasType.MOSAIC);
      expect(AliasType.fromInt(2), AliasType.ADDRESS);
    });

    test('Trying to retrieve an invalid alias type will throw an error', () {
      String errorMessage = AliasType.UNKNOWN_ALIAS_TYPE;
      expect(() => AliasType.fromInt(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => AliasType.fromInt(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => AliasType.fromInt(3),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });
  });
}
