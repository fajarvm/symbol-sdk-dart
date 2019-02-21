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

import 'package:nem2_sdk_dart/core.dart' show Uint64;
import 'package:nem2_sdk_dart/sdk.dart' show MosaicProperties;

main() {
  group('Create MosaicProperties via constructor', () {
    test('Can create via constructor', () {
      final MosaicProperties properties = new MosaicProperties(
          supplyMutable: true,
          transferable: false,
          levyMutable: true,
          divisibility: 5,
          duration: new Uint64(1000));

      expect(properties.supplyMutable, equals(true));
      expect(properties.transferable, equals(false));
      expect(properties.levyMutable, equals(true));
      expect(properties.divisibility, equals(5));
      expect(properties.duration.value.toInt(), equals(1000));
    });
  });

  group('Create MosaicProperties via helper method', () {
    test('Can create via static method create()', () {
      final MosaicProperties properties = MosaicProperties.create(new Uint64(3000));

      expect(properties.supplyMutable, equals(false));
      expect(properties.transferable, equals(true));
      expect(properties.levyMutable, equals(false));
      expect(properties.divisibility, equals(0));
      expect(properties.duration.value.toInt(), equals(3000));
    });
  });
}
