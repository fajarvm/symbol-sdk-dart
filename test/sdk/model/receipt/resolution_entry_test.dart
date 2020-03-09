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

library symbol_sdk_dart.test.sdk.model.receipt.resolution_entry_test;

import 'dart:typed_data' show Uint8List;

import 'package:symbol_sdk_dart/core.dart' show HexUtils;
import 'package:symbol_sdk_dart/sdk.dart' show Address, MosaicId, ReceiptSource, ResolutionEntry;
import 'package:test/test.dart';

void main() {
  group('ResolutionEntry', () {
    // setup
    const String plainAddress = 'SDGLFW-DSHILT-IUHGIB-H5UGX2-VYF5VN-JEKCCD-BR26';
    final Address address = Address.fromRawAddress(plainAddress);
    const String mosaicHex = '85bbea6cc462b244';
    final MosaicId mosaicId = MosaicId.fromHex(mosaicHex);
    final ReceiptSource receiptSource = new ReceiptSource(1, 2);

    test('Can create an address resolution entry', () {
      ResolutionEntry resolutionEntry = new ResolutionEntry(address, receiptSource);
      expect(resolutionEntry.source, equals(receiptSource));
      expect(resolutionEntry.resolved is Address, isTrue);
      expect(resolutionEntry.resolved, equals(address));
      expect((resolutionEntry.resolved as Address).pretty, equals(plainAddress));
    });

    test('Can create a mosaic resolution entry', () {
      ResolutionEntry resolutionEntry = new ResolutionEntry(mosaicId, receiptSource);
      expect(resolutionEntry.source, equals(receiptSource));
      expect(resolutionEntry.resolved is MosaicId, isTrue);
      expect(resolutionEntry.resolved, equals(mosaicId));
      expect((resolutionEntry.resolved as MosaicId).toHex(), equals(mosaicHex));
    });

    test('serialize()', () {
      ResolutionEntry resolutionEntry = new ResolutionEntry(address, receiptSource);

      Uint8List entryBytes = resolutionEntry.serialize();
      final String entryHex = HexUtils.bytesToHex(entryBytes);
      expect(entryHex, '90ccb2d8723a173450e6404fda1afaae0bdab524508430c75e0100000002000000');
    });

    test('Should throw an exception when creating an entry with invalid parameter values', () {
      // null resolved object
      expect(
          () => new ResolutionEntry(null, receiptSource),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));

      // null source
      expect(
          () => new ResolutionEntry(address, null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));

      // invalid resolved object type
      expect(
          () => new ResolutionEntry('', receiptSource),
          throwsA(predicate((e) =>
              e is ArgumentError && e.message.toString().contains('Invalid ResolutionEntry'))));
    });
  });
}
