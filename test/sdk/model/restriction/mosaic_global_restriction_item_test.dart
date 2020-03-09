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

library symbol_sdk_dart.test.sdk.model.restriction.mosaic_global_restriction_item_test;

import 'package:symbol_sdk_dart/sdk.dart'
    show MosaicGlobalRestrictionItem, MosaicId, MosaicRestrictionType;
import 'package:test/test.dart';

void main() {
  group('MosaicGlobalRestrictionItem', () {
    test('Can create mosaic global restriction item object', () {
      final mosaicId = MosaicId.fromHex('85BBEA6CC462B244');

      final mosaicGlobalRestrictionItem =
          new MosaicGlobalRestrictionItem(mosaicId, '123', MosaicRestrictionType.EQ);

      expect(mosaicGlobalRestrictionItem.referenceMosaicId.toHex(), equals(mosaicId.toHex()));
      expect(mosaicGlobalRestrictionItem.restrictionValue, equals('123'));
      expect(mosaicGlobalRestrictionItem.restrictionType, equals(MosaicRestrictionType.EQ));
    });
  });
}
