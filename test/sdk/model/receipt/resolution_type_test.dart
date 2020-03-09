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

library symbol_sdk_dart.test.sdk.model.receipt.resolution_type_test;

import 'package:symbol_sdk_dart/sdk.dart' show ResolutionType;
import 'package:test/test.dart';

void main() {
  group('ResolutionType', () {
    test('Check supported types', () {
      // check collection size
      expect(ResolutionType.values.length, 2);
      // check values
      expect(ResolutionType.ADDRESS.value, 0);
      expect(ResolutionType.MOSAIC.value, 1);

      expect(ResolutionType.ADDRESS.isAddress, isTrue);
      expect(ResolutionType.ADDRESS.isMosaic, isFalse);
      expect(ResolutionType.MOSAIC.isAddress, isFalse);
      expect(ResolutionType.MOSAIC.isMosaic, isTrue);
    });

    test('Can retrieve a valid type from an int value', () {
      expect(ResolutionType.fromInt(0), ResolutionType.ADDRESS);
      expect(ResolutionType.fromInt(1), ResolutionType.MOSAIC);
    });

    test('invalid or unknown type should throw an error', () {
      String errorMessage = ResolutionType.UNKNOWN_RESOLUTION_TYPE;
      expect(() => ResolutionType.fromInt(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => ResolutionType.fromInt(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => ResolutionType.fromInt(2),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });
  });
}
