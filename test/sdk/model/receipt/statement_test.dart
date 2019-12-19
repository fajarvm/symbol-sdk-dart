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
        ArtifactExpiryReceipt,
        MosaicId,
        NamespaceId,
        NetworkType,
        Receipt,
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
    final Uint64 height = Uint64(1473);
    final Uint64 height2 = Uint64(1500);
    NetworkType networkType = NetworkType.MIJIN_TEST;
    MosaicId mosaicId1 = MosaicId.fromHex('AAAAAAAAAAAAAAA1');
    MosaicId mosaicId2 = MosaicId.fromHex('AAAAAAAAAAAAAAA2');
    MosaicId mosaicId3 = MosaicId.fromHex('AAAAAAAAAAAAAAA3');
    MosaicId mosaicId4 = MosaicId.fromHex('AAAAAAAAAAAAAAA4');
    NamespaceId mosaicNamespace1 = NamespaceId.fromFullName('mosaicnamespace1');
    NamespaceId mosaicNamespace3 = NamespaceId.fromFullName('mosaicnamespace3');
    NamespaceId mosaicNamespace4 = NamespaceId.fromFullName('mosaicnamespace4');
    Address address1 = Account.generate(networkType).publicAccount.address;
    NamespaceId addressNamespace1 = NamespaceId.fromFullName('addressnamespace1');

    // setup statement
    Account account = Account.fromPrivateKey(
        '81C18245507F9C15B61BDEDAFA2C10D9DC2C4E401E573A10935D45AA2A461FD5', networkType);

    // Resolution entries
    final addressEntries = <ResolutionEntry>[ResolutionEntry(address1, ReceiptSource(1, 0))];
    final mosaicEntries = <ResolutionEntry>[
      ResolutionEntry(mosaicId1, ReceiptSource(1, 0)),
      ResolutionEntry(mosaicId2, ReceiptSource(3, 5))
    ];
    final mosaicEntries2 = <ResolutionEntry>[ResolutionEntry(mosaicId3, ReceiptSource(3, 1))];
    final mosaicEntries3 = <ResolutionEntry>[
      ResolutionEntry(mosaicId1, ReceiptSource(1, 1)),
      ResolutionEntry(mosaicId2, ReceiptSource(1, 4)),
      ResolutionEntry(mosaicId3, ReceiptSource(1, 7)),
      ResolutionEntry(mosaicId3, ReceiptSource(2, 4))
    ];

    // Statements
    final transactionStatements = <TransactionStatement>[];

    final addressResolutionStatements = <ResolutionStatement>[
      new ResolutionStatement(ResolutionType.ADDRESS, height, addressNamespace1, addressEntries)
    ];

    final mosaicResolutionStatements = <ResolutionStatement>[
      new ResolutionStatement(ResolutionType.MOSAIC, height, mosaicNamespace1, mosaicEntries),
      new ResolutionStatement(ResolutionType.MOSAIC, height, mosaicNamespace3, mosaicEntries2),
      new ResolutionStatement(ResolutionType.MOSAIC, height2, mosaicNamespace4, mosaicEntries3),
    ];

    // Create a new statement
    Statement statement = new Statement(
        transactionStatements, addressResolutionStatements, mosaicResolutionStatements);

    test('Can create a statement object', () {
      expect(statement, isNotNull);
      expect(statement.transactionStatements.length, 0);
      expect(statement.addressResolutionStatements.length, 1);
      expect(statement.mosaicResolutionStatements.length, 3);
    });

    // TODO: complete test
    test('Can get resolved entry when primaryId > maxMosaicId', () {
//      final resolved = statement.resolve(
//          unresolved: mosaicNamespace1,
//          type: ResolutionType.MOSAIC,
//          height: '1473',
//          transactionIndex: 4,
//          aggregateTransactionIndex: 0);
//      expect(resolved, isNotNull);
//      expect(resolved, equals(mosaicId2));
    });

    test('Can resolve an address from receipt', () {});
    test('Can resolve a mosaic from receipt', () {});
  });
}
