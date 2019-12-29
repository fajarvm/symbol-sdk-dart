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

library nem2_sdk_dart.test.sdk.model.restriction.mosaic_global_restriction_test;

import 'package:nem2_sdk_dart/sdk.dart'
    show
        MosaicGlobalRestriction,
        MosaicGlobalRestrictionItem,
        MosaicId,
        MosaicRestrictionEntryType,
        MosaicRestrictionType;
import 'package:test/test.dart';

void main() {
  group('MosaicGlobalRestriction', () {
    test('Can create mosaic address restriction object', () {
      const hash = '57F7DA205008026C776CB6AED843393F04CD458E0AA2D9F1D5F31A402072B2D6';
      const mosaicHex = '85bbea6cc462b244';
      final mosaicId = MosaicId.fromHex(mosaicHex);
      final restrictionItem =
          new MosaicGlobalRestrictionItem(mosaicId, '123', MosaicRestrictionType.EQ);
      final restrictions = <String, MosaicGlobalRestrictionItem>{'testKey': restrictionItem};

      final mosaicGlobalRestriction = new MosaicGlobalRestriction(
          hash, MosaicRestrictionEntryType.GLOBAL, mosaicId, restrictions);

      expect(mosaicGlobalRestriction.compositeHash, equals(hash));
      expect(mosaicGlobalRestriction.entryType, equals(MosaicRestrictionEntryType.GLOBAL));
      expect(mosaicGlobalRestriction.mosaicId.toHex(), equals(mosaicHex));
      expect(mosaicGlobalRestriction.restrictions.length, 1);
      expect(mosaicGlobalRestriction.restrictions['testKey'], isNotNull);
      expect(mosaicGlobalRestriction.restrictions['testKey'].referenceMosaicId.toHex(),
          equals(mosaicHex));
      expect(mosaicGlobalRestriction.restrictions['testKey'].restrictionValue, equals('123'));
      expect(mosaicGlobalRestriction.restrictions['testKey'].restrictionType,
          equals(MosaicRestrictionType.EQ));
    });
  });
}
