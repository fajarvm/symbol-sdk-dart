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

library nem2_sdk_dart.test.sdk.model.receipt.resolution_statement_test;

import 'package:nem2_sdk_dart/core.dart' show ArrayUtils;
import 'package:nem2_sdk_dart/sdk.dart'
    show
        Address,
        AddressAlias,
        MosaicAlias,
        MosaicId,
        ReceiptSource,
        ReceiptType,
        ResolutionEntry,
        ResolutionStatement,
        Uint64;
import 'package:test/test.dart';

void main() {
  group('ResolutionStatement', () {
    // setup
    const String plainAddress = 'SDGLFW-DSHILT-IUHGIB-H5UGX2-VYF5VN-JEKCCD-BR26';
    final Address testAddress = Address.fromRawAddress(plainAddress);
    final AddressAlias addressAlias = new AddressAlias(testAddress);
    final MosaicId mosaicId = MosaicId.fromHex('85bbea6cc462b244');
    final MosaicAlias mosaicAlias = new MosaicAlias(mosaicId);
    final ReceiptSource receiptSource = new ReceiptSource(1, 2);
    final ResolutionEntry<AddressAlias> addressAliasEntry =
        new ResolutionEntry(addressAlias, receiptSource, ReceiptType.ADDRESS_ALIAS_RESOLUTION);
    final ResolutionEntry<MosaicAlias> mosaicAliasEntry =
        new ResolutionEntry(mosaicAlias, receiptSource, ReceiptType.MOSAIC_ALIAS_RESOLUTION);
    final Uint64 height = Uint64.fromBigInt(BigInt.from(10));

    test('Check the ResolutionStatement collection', () {
      expect(ReceiptType.ResolutionStatement.length, 2);
      expect(
          ReceiptType.ResolutionStatement.contains(ReceiptType.ADDRESS_ALIAS_RESOLUTION), isTrue);
      expect(ReceiptType.ResolutionStatement.contains(ReceiptType.MOSAIC_ALIAS_RESOLUTION), isTrue);
    });

    test('Can create address resolution statement', () {
      List<ResolutionEntry<AddressAlias>> entries = <ResolutionEntry<AddressAlias>>[];
      entries.add(addressAliasEntry);

      ResolutionStatement statement = new ResolutionStatement(height, testAddress, entries);
      expect(statement.height, equals(height));
      expect(statement.unresolved, equals(testAddress));
      expect(ArrayUtils.deepEqual(statement.resolutionEntries, entries), isTrue);
    });

    test('Can create mosaic resolution statement', () {
      List<ResolutionEntry<MosaicAlias>> entries = <ResolutionEntry<MosaicAlias>>[];
      entries.add(mosaicAliasEntry);

      ResolutionStatement statement = new ResolutionStatement(height, mosaicId, entries);
      expect(statement.height, equals(height));
      expect(statement.unresolved, equals(mosaicId));
      expect(ArrayUtils.deepEqual(statement.resolutionEntries, entries), isTrue);
    });

    test('Should throw an exception when creating an entry with invalid parameter values', () {
      // invalid unresolved object type
      expect(
          () => new ResolutionStatement(height, '', null),
          throwsA(predicate((e) =>
              e is ArgumentError && e.message.toString().contains('Invalid ResolutionStatement'))));

      // invalid resolution entries
      List<ResolutionEntry<MosaicAlias>> entries = <ResolutionEntry<MosaicAlias>>[];
      entries.add(mosaicAliasEntry);
      expect(
          () => new ResolutionStatement(height, testAddress, entries),
          throwsA(predicate((e) =>
              e is ArgumentError && e.message.toString().contains('Invalid ResolutionStatement'))));
    });
  });
}
