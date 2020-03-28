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

library symbol_sdk_dart.test.sdk.model.mosaic.mosaic_flags_test;

import 'package:symbol_sdk_dart/sdk.dart' show MosaicFlags;
import 'package:test/test.dart';

void main() {
  group('MosaicFlags', () {
    test('Can create via static method create() - default values', () {
      // create with default values
      final MosaicFlags flags = MosaicFlags.create();

      expect(flags.supplyMutable, isFalse);
      expect(flags.transferable, isTrue);
      expect(flags.restrictable, isTrue);
      expect(
          flags.toString(),
          equals('MosaicFlags{'
              'supplyMutable: ${flags.supplyMutable}, '
              'transferable: ${flags.transferable}, '
              'restrictable: ${flags.restrictable}'
              '}'));
    });

    test('Can create via static method create() - custom values', () {
      // create with custom values
      final MosaicFlags flags = MosaicFlags.create(false, false, false);

      expect(flags.supplyMutable, isFalse);
      expect(flags.transferable, isFalse);
      expect(flags.restrictable, isFalse);
    });

    test('Can create via static method fromByteValue()', () {
      // 0 - false, false, false
      MosaicFlags flags = MosaicFlags.fromByteValue(0);
      expect(flags.supplyMutable, isFalse);
      expect(flags.transferable, isFalse);
      expect(flags.restrictable, isFalse);
      expect(flags.value, equals(0));

      // 1 - true, false, false
      flags = MosaicFlags.fromByteValue(1);
      expect(flags.supplyMutable, isTrue);
      expect(flags.transferable, isFalse);
      expect(flags.restrictable, isFalse);
      expect(flags.value, equals(1));

      // 2 - false, true, false
      flags = MosaicFlags.fromByteValue(2);
      expect(flags.supplyMutable, isFalse);
      expect(flags.transferable, isTrue);
      expect(flags.restrictable, isFalse);
      expect(flags.value, equals(2));

      // 3 - true, true, false
      flags = MosaicFlags.fromByteValue(3);
      expect(flags.supplyMutable, isTrue);
      expect(flags.transferable, isTrue);
      expect(flags.restrictable, isFalse);
      expect(flags.value, equals(3));

      // 4 - false, false, true
      flags = MosaicFlags.fromByteValue(4);
      expect(flags.supplyMutable, isFalse);
      expect(flags.transferable, isFalse);
      expect(flags.restrictable, isTrue);
      expect(flags.value, equals(4));

      // 5 - true, false, true
      flags = MosaicFlags.fromByteValue(5);
      expect(flags.supplyMutable, isTrue);
      expect(flags.transferable, isFalse);
      expect(flags.restrictable, isTrue);
      expect(flags.value, equals(5));

      // 6 - false, true, true
      flags = MosaicFlags.fromByteValue(6);
      expect(flags.supplyMutable, isFalse);
      expect(flags.transferable, isTrue);
      expect(flags.restrictable, isTrue);
      expect(flags.value, equals(6));

      // 7 - true, true, true
      flags = MosaicFlags.fromByteValue(7);
      expect(flags.supplyMutable, isTrue);
      expect(flags.transferable, isTrue);
      expect(flags.restrictable, isTrue);
      expect(flags.value, equals(7));
    });
  });
}
