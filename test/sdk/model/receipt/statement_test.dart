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

library nem2_sdk_dart.test.sdk.model.receipt.statement_test;

import 'package:nem2_sdk_dart/sdk.dart'
    show
        Account,
        Address,
        BalanceChangeReceipt,
        Mosaic,
        MosaicId,
        NamespaceId,
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
  group('Statement', () {
    // setup
    NetworkType networkType = NetworkType.MIJIN_TEST;
    Account account = Account.fromPrivateKey(
        '81C18245507F9C15B61BDEDAFA2C10D9DC2C4E401E573A10935D45AA2A461FD5', networkType);
    final Uint64 height = Uint64(1473);

    // Statements
    // Transaction statements
    Account targetAccount = Account.fromPrivateKey(
        'B2708D49C46F8AB5CDBD7A09C959EEA12E4A782592F3D1D3D17D54622E655D7F', networkType);
    final balanceChangeReceipt = new BalanceChangeReceipt(
        targetAccount.publicAccount,
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
    final resolvedMosaic2 = MosaicId.fromHex('756482FB80FD406C');
    final mosaicResolutionStatements = <ResolutionStatement>[
      new ResolutionStatement(ResolutionType.MOSAIC, height, unresolvedMosaic1,
          [ResolutionEntry(resolvedMosaic1, ReceiptSource(1, 0))]),
      new ResolutionStatement(ResolutionType.MOSAIC, height, unresolvedMosaic2,
          [ResolutionEntry(resolvedMosaic2, ReceiptSource(1, 0))]),
    ];

    // Create a new statement
    Statement statement = new Statement(
        transactionStatements, addressResolutionStatements, mosaicResolutionStatements);

    test('Can create a statement object', () {
      expect(statement, isNotNull);
      expect(statement.transactionStatements.length, 1);
      expect(statement.addressResolutionStatements.length, 1);
      expect(statement.mosaicResolutionStatements.length, 2);
    });

    test('Should get resolved address', () {
      final unresolvedAddress =
          UnresolvedUtils.toUnresolvedAddress('9156258DE356F030A500000000000000000000000000000000');
      final resolved = statement.resolveAddress(unresolvedAddress as NamespaceId, '1473', 0);

      expect(resolved is Address, isTrue);
      expect(resolved, equals(account.publicAccount.address));
    });

    test('Should get resolved mosaicId', () {
      final unresolvedMosaic = UnresolvedUtils.toUnresolvedMosaic('E81F622A5B11A340');
      final resolved = statement.resolveMosaicId(unresolvedMosaic as NamespaceId, '1473', 0);

      expect(resolved is MosaicId, isTrue);

      final expected = MosaicId.fromHex('756482FB80FD406C');
      expect(resolved, equals(expected));
    });

    test('Should get resolved mosaic', () {
      final expectedMosaicId = MosaicId.fromHex('756482FB80FD406C');
      final expectedMosaic = Mosaic(expectedMosaicId, Uint64(1000));
      final resolved = statement.resolveMosaic(expectedMosaic, '1473', 0);

      expect(resolved is Mosaic, isTrue);
      expect((resolved as Mosaic).id, equals(expectedMosaic.id));
      expect((resolved as Mosaic).amount, equals(expectedMosaic.amount));
    });

    test('Should get resolved address without Harvesting Fee', () {
      final testUnresolvedAddress =
          UnresolvedUtils.toUnresolvedAddress('9156258DE356F030A500000000000000000000000000000000');
      final testResolvedAddress =
          Address.fromEncoded('901D8D4741F80299E66BF7FEEB4F30943DA7B68E068B182319');
      final Statement statementWithoutHarvesting = new Statement([], [
        new ResolutionStatement(ResolutionType.ADDRESS, height, testUnresolvedAddress,
            [ResolutionEntry(testResolvedAddress, ReceiptSource(1, 0))])
      ], []);

      final resolved = statementWithoutHarvesting.resolveAddress(testUnresolvedAddress, '1473', 0);
      expect(resolved is Address, isTrue);
      expect(resolved, equals(account.publicAccount.address));
    });

    test('Should get resolved mosaic without Harvesting Fee', () {
      final testUnresolvedMosaic1 = UnresolvedUtils.toUnresolvedMosaic('85BBEA6CC462B244');
      final testUnresolvedMosaic2 = UnresolvedUtils.toUnresolvedMosaic('E81F622A5B11A340');
      final resolvedMosaic1 = MosaicId.fromHex('504677C3281108DB');
      final resolvedMosaic2 = MosaicId.fromHex('756482FB80FD406C');

      final Statement statementWithoutHarvesting = new Statement([], [], [
        new ResolutionStatement(ResolutionType.MOSAIC, height, testUnresolvedMosaic1,
            [ResolutionEntry(resolvedMosaic1, ReceiptSource(1, 0))]),
        new ResolutionStatement(ResolutionType.MOSAIC, height, testUnresolvedMosaic2,
            [ResolutionEntry(resolvedMosaic2, ReceiptSource(1, 0))])
      ]);

      final resolved = statementWithoutHarvesting.resolveMosaicId(testUnresolvedMosaic2, '1473', 0);
      expect(resolved is MosaicId, isTrue);

      final expected = MosaicId.fromHex('756482FB80FD406C');
      expect(resolved, equals(expected));
    });
  });
}
