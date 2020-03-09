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

library symbol_sdk_dart.test.sdk.model.restriction.mosaic_address_restriction_test;

import 'package:symbol_sdk_dart/sdk.dart'
    show Address, MosaicAddressRestriction, MosaicId, MosaicRestrictionEntryType;
import 'package:test/test.dart';

void main() {
  group('MosaicAddressRestriction', () {
    test('Can create mosaic address restriction object', () {
      const hash = '57F7DA205008026C776CB6AED843393F04CD458E0AA2D9F1D5F31A402072B2D6';
      final mosaicId = MosaicId.fromHex('85BBEA6CC462B244');
      final address = Address.fromEncoded('9050B9837EFAB4BBE8A4B9BB32D812F9885C00D8FC1650E142');
      final restrictions = <String, String>{'testKey': 'testValue'};

      final mosaicAddressRestriction = new MosaicAddressRestriction(
          hash, MosaicRestrictionEntryType.ADDRESS, mosaicId, address, restrictions);

      expect(mosaicAddressRestriction.compositeHash, equals(hash));
      expect(mosaicAddressRestriction.entryType, equals(MosaicRestrictionEntryType.ADDRESS));
      expect(mosaicAddressRestriction.targetAddress.plain, equals(address.plain));
      expect(mosaicAddressRestriction.restrictions.length, 1);
      expect(mosaicAddressRestriction.restrictions['testKey'], equals('testValue'));
    });
  });
}
