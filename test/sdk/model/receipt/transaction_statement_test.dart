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

library nem2_sdk_dart.test.sdk.model.receipt.transaction_statement_test;

import 'package:nem2_sdk_dart/core.dart' show ArrayUtils;
import 'package:nem2_sdk_dart/sdk.dart'
    show
        Account,
        Address,
        ArtifactExpiryReceipt,
        BalanceChangeReceipt,
        BalanceTransferReceipt,
        MosaicId,
        NetworkType,
        Receipt,
        ReceiptSource,
        ReceiptType,
        ReceiptVersion,
        TransactionStatement,
        Uint64;
import 'package:test/test.dart';

void main() {
  group('TransactionStatement', () {
    // setup
    const privateKey = 'D242FB34C2C4DD36E995B9C865F93940065E326661BA5A4A247331D211FE3A3D';
    final testAccount = Account.fromPrivateKey(privateKey, NetworkType.MIJIN_TEST);
    const addressString = 'SDGLFW-DSHILT-IUHGIB-H5UGX2-VYF5VN-JEKCCD-BR26';
    final recipientAddress = Address.fromRawAddress(addressString);
    final mosaicId = MosaicId.fromHex('85bbea6cc462b244');
    final receiptSource = new ReceiptSource(0, 0);
    final height = Uint64.fromBigInt(BigInt.from(52));
    final amount = Uint64.fromBigInt(BigInt.from(1000));

    // Create receipts
    final mosaicExpiryReceipt = new ArtifactExpiryReceipt(
        mosaicId, ReceiptType.MOSAIC_EXPIRED, ReceiptVersion.ARTIFACT_EXPIRY);
    final balanceChangeReceipt = new BalanceChangeReceipt(testAccount.publicAccount, mosaicId,
        amount, ReceiptType.HARVEST_FEE, ReceiptVersion.BALANCE_CHANGE);
    final balanceTransferReceipt = new BalanceTransferReceipt(
        testAccount.publicAccount,
        recipientAddress,
        mosaicId,
        amount,
        ReceiptType.MOSAIC_RENTAL_FEE,
        ReceiptVersion.BALANCE_TRANSFER);

    final receipts = <Receipt>[mosaicExpiryReceipt, balanceChangeReceipt, balanceTransferReceipt];

    test('Can create a transaction statement object', () {
      // Create a new transaction statement
      final transactionStatement = new TransactionStatement(height, receiptSource, receipts);
      expect(transactionStatement.height, equals(height));
      expect(transactionStatement.source, equals(receiptSource));
      expect(ArrayUtils.deepEqual(transactionStatement.receipts, receipts), isTrue);
    });

    test('Can generate hash', () {
      final List<Receipt> receipts = [balanceChangeReceipt];
      final transactionStatement = new TransactionStatement(height, receiptSource, receipts);
      final hash = transactionStatement.generateHash();

      expect(hash.isNotEmpty, isTrue);
      expect(hash, equals('78E5F66EC55D1331646528F9BF7EC247C68F58E651223E7F05CBD4FBF0BF88FA'));
    });
  });
}
