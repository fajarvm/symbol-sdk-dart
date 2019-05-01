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

library nem2_sdk_dart.test.sdk.model.mosaic.mosaic_levy_type_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show MosaicLevyType;

void main() {
  group('MosaicLevyType', () {
    test('creating a new instance returns a singleton', () {
      final type1 = new MosaicLevyType();
      final type2 = new MosaicLevyType();

      expect(identical(type1, type2), isTrue);
    });
    test('valid mosaic levy types', () {
      expect(MosaicLevyType.ABSOLUTE, 1);
      expect(MosaicLevyType.CALCULATED, 2);
    });

    test('Can retrieve a valid mosaic levy types', () {
      expect(MosaicLevyType.getType(1), MosaicLevyType.ABSOLUTE);
      expect(MosaicLevyType.getType(2), MosaicLevyType.CALCULATED);
    });

    test('Trying to retrieve an invalid levy type will throw an error', () {
      expect(
              () => MosaicLevyType.getType(null),
          throwsA(
              predicate((e) => e is ArgumentError && e.message == 'invalid mosaic levy type')));
      expect(
              () => MosaicLevyType.getType(0),
          throwsA(
              predicate((e) => e is ArgumentError && e.message == 'invalid mosaic levy type')));
      expect(
              () => MosaicLevyType.getType(-1),
          throwsA(
              predicate((e) => e is ArgumentError && e.message == 'invalid mosaic levy type')));
      expect(
              () => MosaicLevyType.getType(3),
          throwsA(
              predicate((e) => e is ArgumentError && e.message == 'invalid mosaic levy type')));
    });
  });
}
