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
        Account,
        Address,
        BalanceChangeReceipt,
        MosaicId,
        NetworkType,
        ReceiptSource,
        ReceiptType,
        ReceiptVersion,
        ResolutionEntry,
        ResolutionStatement,
        ResolutionType,
        Statement,
        TransactionStatement,
        Uint64,
        UnresolvedUtils;
import 'package:test/test.dart';

void main() {
  group('ResolutionStatement', () {
    // setup
    const String plainAddress = 'SDGLFW-DSHILT-IUHGIB-H5UGX2-VYF5VN-JEKCCD-BR26';
    final Address address = Address.fromRawAddress(plainAddress);
    final MosaicId mosaicId = MosaicId.fromHex('85bbea6cc462b244');
    final ReceiptSource receiptSource = new ReceiptSource(1, 2);
    final ResolutionEntry addressEntry = new ResolutionEntry(address, receiptSource);
    final ResolutionEntry mosaicEntry = new ResolutionEntry(mosaicId, receiptSource);
    final Uint64 height = Uint64(1473);
    NetworkType networkType = NetworkType.MIJIN_TEST;

    // Statements
    // Transaction statements
    Account account = Account.fromPrivateKey(
        '81C18245507F9C15B61BDEDAFA2C10D9DC2C4E401E573A10935D45AA2A461FD5', networkType);
    final balanceChangeReceipt = new BalanceChangeReceipt(
        account.publicAccount,
        MosaicId.fromHex('504677C3281108DB'),
        Uint64(0),
        ReceiptType.HARVEST_FEE,
        ReceiptVersion.BALANCE_CHANGE);
    final transactionStatements = <TransactionStatement>[
      new TransactionStatement(height, ReceiptSource(0, 0), [balanceChangeReceipt])
    ];

    // Address statements
    dynamic unresolvedAddress =
        UnresolvedUtils.toUnresolvedAddress('9156258DE356F030A500000000000000000000000000000000');
    Address resolvedAddress =
        Address.fromEncoded('901D8D4741F80299E66BF7FEEB4F30943DA7B68E068B182319');
    final addressResolutionStatements = <ResolutionStatement>[
      new ResolutionStatement(ResolutionType.ADDRESS, height, unresolvedAddress,
          [ResolutionEntry(resolvedAddress, ReceiptSource(1, 0))])
    ];

    // Mosaic statements
    dynamic unresolvedMosaic1 = UnresolvedUtils.toUnresolvedMosaic('85BBEA6CC462B244');
    dynamic unresolvedMosaic2 = UnresolvedUtils.toUnresolvedMosaic('E81F622A5B11A340');
    final resolvedMosaic1 = MosaicId.fromHex('504677C3281108DB');
    final resolvedMosaic2 = MosaicId.fromHex('401F622A3111A3E4');
    final resolvedMosaic3 = MosaicId.fromHex('756482FB80FD406C');
    final resolvedMosaic4 = MosaicId.fromHex('0DC67FBE1CAD29E5');
    final resolvedMosaic5 = MosaicId.fromHex('7CDF3B117A3C40CC');
    final mosaicResolutionStatements = <ResolutionStatement>[
      // 0
      new ResolutionStatement(ResolutionType.MOSAIC, height, unresolvedMosaic1, [
        ResolutionEntry(resolvedMosaic1, ReceiptSource(1, 0)),
        ResolutionEntry(resolvedMosaic2, ReceiptSource(3, 5))
      ]),
      // 1
      new ResolutionStatement(ResolutionType.MOSAIC, Uint64(1500), unresolvedMosaic2,
          [ResolutionEntry(resolvedMosaic3, ReceiptSource(3, 1))]),
      // 2
      new ResolutionStatement(ResolutionType.MOSAIC, height, unresolvedMosaic1, [
        ResolutionEntry(resolvedMosaic4, ReceiptSource(1, 1)),
        ResolutionEntry(resolvedMosaic5, ReceiptSource(1, 4)),
        ResolutionEntry(resolvedMosaic4, ReceiptSource(1, 7)),
        ResolutionEntry(resolvedMosaic5, ReceiptSource(2, 4)),
      ])
    ];

    // Create a new statement
    Statement statement = new Statement(
        transactionStatements, addressResolutionStatements, mosaicResolutionStatements);

    test('Check the ResolutionStatement collection', () {
      expect(ReceiptType.ResolutionStatement.length, 2);
      expect(
          ReceiptType.ResolutionStatement.contains(ReceiptType.ADDRESS_ALIAS_RESOLUTION), isTrue);
      expect(ReceiptType.ResolutionStatement.contains(ReceiptType.MOSAIC_ALIAS_RESOLUTION), isTrue);
    });

    test('Can create address resolution statement', () {
      List<ResolutionEntry> entries = <ResolutionEntry>[addressEntry];

      ResolutionStatement statement =
          new ResolutionStatement(ResolutionType.ADDRESS, height, address, entries);
      expect(statement.resolutionType, equals(ResolutionType.ADDRESS));
      expect(statement.height, equals(height));
      expect(statement.unresolved, equals(address));
      expect(ArrayUtils.deepEqual(statement.resolutionEntries, entries), isTrue);
    });

    test('Can create mosaic resolution statement', () {
      List<ResolutionEntry> entries = <ResolutionEntry>[mosaicEntry];

      ResolutionStatement statement =
          new ResolutionStatement(ResolutionType.MOSAIC, height, mosaicId, entries);
      expect(statement.resolutionType, equals(ResolutionType.MOSAIC));
      expect(statement.height, equals(height));
      expect(statement.unresolved, equals(mosaicId));
      expect(ArrayUtils.deepEqual(statement.resolutionEntries, entries), isTrue);
    });

    test('Should throw an exception when creating an entry with invalid parameter values', () {
      // invalid unresolved object type
      expect(
          () => new ResolutionStatement(ResolutionType.ADDRESS, height, '', null),
          throwsA(predicate((e) =>
              e is ArgumentError && e.message.toString().contains('Invalid ResolutionStatement'))));

      // invalid resolution entries
      List<ResolutionEntry> entries = <ResolutionEntry>[mosaicEntry];
      expect(
          () => new ResolutionStatement(ResolutionType.MOSAIC, height, address, entries),
          throwsA(predicate((e) =>
              e is ArgumentError && e.message.toString().contains('Invalid ResolutionStatement'))));
    });

    test('Can generate hash', () {
      List<ResolutionEntry> entries = <ResolutionEntry>[mosaicEntry];
      ResolutionStatement statement =
          new ResolutionStatement(ResolutionType.MOSAIC, Uint64(10), mosaicId, entries);

      String hash = statement.generateHash(NetworkType.MIJIN_TEST);

      expect(hash.isNotEmpty, isTrue);
      expect(hash, equals('F9641458615C9AAC4CEED5FABCA96809746368C2C62B4902D9809FC8B03CA531'));
    });

    test('Can get resolved entry when both primaryId and secondaryId matched', () {
      final entry = statement.addressResolutionStatements[0].getResolutionEntryById(1, 0);

      expect(entry.resolved is Address, isTrue);
      expect(entry.resolved as Address, equals(account.publicAccount.address));
    });

    test('Can get resolved entry when primaryId is greater than secondaryId', () {
      final entry = statement.mosaicResolutionStatements[0].getResolutionEntryById(4, 0);

      expect(entry.source.primaryId, 3);
      expect(entry.source.secondaryId, 5);
      expect(entry.resolved is MosaicId, isTrue);
      expect((entry.resolved as MosaicId).toHex(), equals('401f622a3111a3e4'));
    });

    test('Can get resolved entry when primaryId is in the middle of 2 primaryIds', () {
      final entry = statement.mosaicResolutionStatements[0].getResolutionEntryById(2, 1);

      expect(entry.source.primaryId, 1);
      expect(entry.source.secondaryId, 0);
      expect(entry.resolved is MosaicId, isTrue);
      expect((entry.resolved as MosaicId).toHex(), equals('504677c3281108db'));
    });

    test('Can get resolved entry when primaryId matches but not secondaryId', () {
      final entry = statement.mosaicResolutionStatements[0].getResolutionEntryById(3, 6);

      expect(entry.source.primaryId, 3);
      expect(entry.source.secondaryId, 5);
      expect(entry.resolved is MosaicId, isTrue);
      expect((entry.resolved as MosaicId).toHex(), equals('401f622a3111a3e4'));
    });

    test('Can get resolved entry when primaryId matches but secondaryId less than minimum', () {
      final entry = statement.mosaicResolutionStatements[0].getResolutionEntryById(3, 1);

      expect(entry.source.primaryId, 1);
      expect(entry.source.secondaryId, 0);
      expect(entry.resolved is MosaicId, isTrue);
      expect((entry.resolved as MosaicId).toHex(), equals('504677c3281108db'));
    });

    test('resolution change in the block (more than one AGGREGATE)', () {
      final resolution = statement.mosaicResolutionStatements[2];

      expect((resolution.getResolutionEntryById(1, 1).resolved as MosaicId).toHex(), equals('0dc67fbe1cad29e5'));
      expect((resolution.getResolutionEntryById(1, 4).resolved as MosaicId).toHex(), equals('7cdf3b117a3c40cc'));
      expect((resolution.getResolutionEntryById(1, 7).resolved as MosaicId).toHex(), equals('0dc67fbe1cad29e5'));
      expect((resolution.getResolutionEntryById(2, 1).resolved as MosaicId).toHex(), equals('0dc67fbe1cad29e5'));
      expect((resolution.getResolutionEntryById(2, 4).resolved as MosaicId).toHex(), equals('7cdf3b117a3c40cc'));
      expect((resolution.getResolutionEntryById(3, 0).resolved as MosaicId).toHex(), equals('7cdf3b117a3c40cc'));
      expect(resolution.getResolutionEntryById(1, 0), isNull);
      expect((resolution.getResolutionEntryById(1, 6).resolved as MosaicId).toHex(), equals('7cdf3b117a3c40cc'));
      expect((resolution.getResolutionEntryById(1, 2).resolved as MosaicId).toHex(), equals('0dc67fbe1cad29e5'));
    });
  });
}
