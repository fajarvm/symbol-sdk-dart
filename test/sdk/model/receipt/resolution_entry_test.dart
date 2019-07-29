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

library nem2_sdk_dart.test.sdk.model.receipt.resolution_entry_test;

import 'package:nem2_sdk_dart/sdk.dart'
    show Address, AddressAlias, MosaicAlias, MosaicId, ReceiptSource, ReceiptType, ResolutionEntry;
import 'package:test/test.dart';

void main() {
  group('ResolutionEntry', () {
    // setup
    const String plainAddress = 'SDGLFW-DSHILT-IUHGIB-H5UGX2-VYF5VN-JEKCCD-BR26';
    final Address testAddress = Address.fromRawAddress(plainAddress);
    final AddressAlias addressAlias = new AddressAlias(testAddress);
    final MosaicId mosaicId = MosaicId.fromHex('85bbea6cc462b244');
    final MosaicAlias mosaicAlias = new MosaicAlias(mosaicId);
    final ReceiptSource receiptSource = new ReceiptSource(1, 2);

    test('Can create address resolution entry', () {
      ResolutionEntry resolutionEntry =
          new ResolutionEntry(addressAlias, receiptSource, ReceiptType.ADDRESS_ALIAS_RESOLUTION);
      expect(resolutionEntry.receiptSource, equals(receiptSource));
      expect(resolutionEntry.receiptType, ReceiptType.ADDRESS_ALIAS_RESOLUTION);
      expect(resolutionEntry.resolved, equals(addressAlias));
    });

    test('Can create mosaic resolution entry', () {
      ResolutionEntry resolutionEntry =
          new ResolutionEntry(mosaicAlias, receiptSource, ReceiptType.MOSAIC_ALIAS_RESOLUTION);
      expect(resolutionEntry.receiptSource, equals(receiptSource));
      expect(resolutionEntry.receiptType, ReceiptType.MOSAIC_ALIAS_RESOLUTION);
      expect(resolutionEntry.resolved, equals(mosaicAlias));
    });

    test('Should throw an exception when creating an entry with invalid parameter values', () {
      // null resolved object
      expect(
          () => new ResolutionEntry(null, receiptSource, ReceiptType.ADDRESS_ALIAS_RESOLUTION),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));

      // null source
      expect(
          () => new ResolutionEntry(addressAlias, null, ReceiptType.ADDRESS_ALIAS_RESOLUTION),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));

      // null receipt type
      expect(
          () => new ResolutionEntry(addressAlias, receiptSource, null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));

      // invalid resolved object type
      expect(
          () => new ResolutionEntry('', receiptSource, ReceiptType.ADDRESS_ALIAS_RESOLUTION),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Invalid ResolutionEntry'))));

      // invalid receipt type
      expect(
          () => new ResolutionEntry(mosaicAlias, receiptSource, ReceiptType.MOSAIC_RENTAL_FEE),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Invalid ResolutionEntry'))));
    });
  });
}
