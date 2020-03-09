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

library symbol_sdk_dart.test.sdk.model.restriction.mosaic_restriction_type_test;

import 'package:symbol_sdk_dart/sdk.dart' show MosaicRestrictionType;
import 'package:test/test.dart';

void main() {
  group('MosaicRestrictionType', () {
    test('valid types', () {
      expect(MosaicRestrictionType.NONE.value, 0);
      expect(MosaicRestrictionType.EQ.value, 1);
      expect(MosaicRestrictionType.NE.value, 2);
      expect(MosaicRestrictionType.LT.value, 3);
      expect(MosaicRestrictionType.LE.value, 4);
      expect(MosaicRestrictionType.GT.value, 5);
      expect(MosaicRestrictionType.GE.value, 6);

      expect(MosaicRestrictionType.NONE.toString(),
          equals('MosaicRestrictionType{value: ${MosaicRestrictionType.NONE.value}}'));
    });

    test('Can retrieve a valid restriction type', () {
      expect(MosaicRestrictionType.fromInt(0), MosaicRestrictionType.NONE);
      expect(MosaicRestrictionType.fromInt(1), MosaicRestrictionType.EQ);
      expect(MosaicRestrictionType.fromInt(2), MosaicRestrictionType.NE);
      expect(MosaicRestrictionType.fromInt(3), MosaicRestrictionType.LT);
      expect(MosaicRestrictionType.fromInt(4), MosaicRestrictionType.LE);
      expect(MosaicRestrictionType.fromInt(5), MosaicRestrictionType.GT);
      expect(MosaicRestrictionType.fromInt(6), MosaicRestrictionType.GE);
    });

    test('Trying to retrieve an unknown restriction type will throw an error', () {
      String errorMessage = MosaicRestrictionType.UNKNOWN_MOSAIC_RESTRICTION_TYPE;
      expect(errorMessage, equals('unknown mosaic restriction type'));

      expect(() => MosaicRestrictionType.fromInt(null),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains(errorMessage))));
      expect(() => MosaicRestrictionType.fromInt(7),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains(errorMessage))));
      expect(() => MosaicRestrictionType.fromInt(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains(errorMessage))));
    });
  });
}
