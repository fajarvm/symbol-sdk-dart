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

import 'package:nem2_sdk_dart/core.dart' show ArrayUtils;
import 'package:nem2_sdk_dart/sdk.dart'
    show
        Address,
        ArtifactExpiryReceipt,
        MosaicId,
        Receipt,
        ReceiptSource,
        ReceiptType,
        ReceiptVersion,
        ResolutionEntry,
        ResolutionStatement,
        ResolutionType,
        Statement,
        TransactionStatement,
        Uint64;
import 'package:test/test.dart';

void main() {
  group('Statement', () {
    test('Can create a statement object', () {
      // setup
      const plainAddress = 'SDGLFW-DSHILT-IUHGIB-H5UGX2-VYF5VN-JEKCCD-BR26';
      final address = Address.fromRawAddress(plainAddress);
      final mosaicId = MosaicId.fromHex('85bbea6cc462b244');
      final receiptSource = new ReceiptSource(1, 2);
      final height = Uint64.fromBigInt(BigInt.from(10));

      // Resolution entries
      final addressEntry = new ResolutionEntry<Address>(address, receiptSource);
      final mosaicEntry = new ResolutionEntry<MosaicId>(mosaicId, receiptSource);
      final addressEntries = <ResolutionEntry<Address>>[addressEntry];
      final mosaicEntries = <ResolutionEntry<MosaicId>>[mosaicEntry];

      // artifact receipt
      final mosaicExpiryReceipt = new ArtifactExpiryReceipt<MosaicId>(
          mosaicId, ReceiptType.MOSAIC_EXPIRED, ReceiptVersion.ARTIFACT_EXPIRY);
      final receipts = <Receipt>[mosaicExpiryReceipt];

      // Statements
      final List<TransactionStatement> transactionStatements = <TransactionStatement>[];
      transactionStatements.add(new TransactionStatement(height, receiptSource, receipts));
      final List<ResolutionStatement<Address>> addressResolutionStatements =
          <ResolutionStatement<Address>>[];
      addressResolutionStatements
          .add(new ResolutionStatement(ResolutionType.ADDRESS, height, address, addressEntries));
      final List<ResolutionStatement<MosaicId>> mosaicResolutionStatements =
          <ResolutionStatement<MosaicId>>[];
      mosaicResolutionStatements
          .add(new ResolutionStatement(ResolutionType.MOSAIC, height, mosaicId, mosaicEntries));

      // Create a new statement
      Statement statement = new Statement(
          transactionStatements, addressResolutionStatements, mosaicResolutionStatements);
      expect(ArrayUtils.deepEqual(statement.transactionStatements, transactionStatements), isTrue);
      expect(
          ArrayUtils.deepEqual(statement.addressResolutionStatements, addressResolutionStatements),
          isTrue);
      expect(ArrayUtils.deepEqual(statement.mosaicResolutionStatements, mosaicResolutionStatements),
          isTrue);
    });
  });
}
