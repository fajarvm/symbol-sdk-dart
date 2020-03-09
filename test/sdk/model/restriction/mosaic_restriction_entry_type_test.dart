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

library symbol_sdk_dart.test.sdk.model.restriction.mosaic_restriction_entry_type_test;

import 'package:symbol_sdk_dart/sdk.dart' show MosaicRestrictionEntryType;
import 'package:test/test.dart';

void main() {
  group('MosaicRestrictionEntryType', () {
    test('valid types', () {
      expect(MosaicRestrictionEntryType.ADDRESS.value, 0);
      expect(MosaicRestrictionEntryType.GLOBAL.value, 1);

      expect(MosaicRestrictionEntryType.ADDRESS.toString(),
          equals('MosaicRestrictionEntryType{value: ${MosaicRestrictionEntryType.ADDRESS.value}}'));
    });

    test('Can retrieve a valid restriction entry type', () {
      expect(MosaicRestrictionEntryType.fromInt(0), MosaicRestrictionEntryType.ADDRESS);
      expect(MosaicRestrictionEntryType.fromInt(1), MosaicRestrictionEntryType.GLOBAL);
    });

    test('Trying to retrieve an unknown restriction entry type will throw an error', () {
      String errorMessage = MosaicRestrictionEntryType.UNKNOWN_MOSAIC_RESTRICTION_ENTRY_TYPE;
      expect(errorMessage, equals('unknown mosaic restriction entry type'));

      expect(() => MosaicRestrictionEntryType.fromInt(null),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains(errorMessage))));
      expect(() => MosaicRestrictionEntryType.fromInt(2),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains(errorMessage))));
      expect(() => MosaicRestrictionEntryType.fromInt(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains(errorMessage))));
    });
  });
}
