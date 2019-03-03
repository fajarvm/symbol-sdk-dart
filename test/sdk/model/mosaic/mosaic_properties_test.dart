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

library nem2_sdk_dart.test.sdk.model.mosaic.mosaic_properties_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show MosaicProperties, Uint64;

void main() {
  group('MosaicProperties', () {
    test('Valid constants', () {
      expect(MosaicProperties.MIN_DIVISIBILITY, 0);
      expect(MosaicProperties.MAX_DIVISIBILITY, 6);
    });

    test('Can create via constructor', () {
      final MosaicProperties properties = new MosaicProperties(
          supplyMutable: true,
          transferable: false,
          levyMutable: true,
          divisibility: 5,
          duration: Uint64(1000));

      expect(properties.supplyMutable, isTrue);
      expect(properties.transferable, isFalse);
      expect(properties.levyMutable, isTrue);
      expect(properties.divisibility, equals(5));
      expect(properties.duration.value.toInt(), equals(1000));
    });

    test('Can create via static method create()', () {
      final MosaicProperties properties = MosaicProperties.create(Uint64(3000));

      expect(properties.supplyMutable, isFalse);
      expect(properties.transferable, isTrue);
      expect(properties.levyMutable, isFalse);
      expect(properties.divisibility, equals(0));
      expect(properties.duration.value.toInt(), equals(3000));
    });

    test('Cannot create with invalid divisibility', () {
      expect(
          () => new MosaicProperties(
              supplyMutable: false,
              transferable: false,
              levyMutable: false,
              divisibility: -1,
              duration: Uint64(0)),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message ==
                  'The divisibility must be in the range of ${MosaicProperties.MIN_DIVISIBILITY} and ${MosaicProperties.MAX_DIVISIBILITY}')));

      expect(
          () => new MosaicProperties(
              supplyMutable: false,
              transferable: false,
              levyMutable: false,
              divisibility: 7,
              duration: Uint64(0)),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message ==
                  'The divisibility must be in the range of ${MosaicProperties.MIN_DIVISIBILITY} and ${MosaicProperties.MAX_DIVISIBILITY}')));
    });
  });
}
