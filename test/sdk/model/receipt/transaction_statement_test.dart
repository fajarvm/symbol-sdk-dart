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
    test('Can create a transaction statement object', () {
      // setup
      const privateKey = '787225aaff3d2c71f4ffa32d4f19ec4922f3cd869747f267378f81f8e3fcb12d';
      final testAccount = Account.fromPrivateKey(privateKey, NetworkType.MIJIN_TEST);
      const addressString = 'SDGLFW-DSHILT-IUHGIB-H5UGX2-VYF5VN-JEKCCD-BR26';
      final recipientAddress = Address.fromRawAddress(addressString);
      final mosaicId = MosaicId.fromHex('85bbea6cc462b244');
      final receiptSource = new ReceiptSource(1, 2);
      final height = Uint64.fromBigInt(BigInt.from(10));
      final amount = Uint64.fromBigInt(BigInt.from(100));

      // Create receipts
      final mosaicExpiryReceipt = new ArtifactExpiryReceipt<MosaicId>(
          mosaicId, ReceiptType.MOSAIC_EXPIRED, ReceiptVersion.ARTIFACT_EXPIRY);
      final balanceChangeReceipt = new BalanceChangeReceipt(testAccount.publicAccount, mosaicId,
          amount, ReceiptType.LOCKSECRET_EXPIRED, ReceiptVersion.BALANCE_CHANGE);
      final balanceTransferReceipt = new BalanceTransferReceipt<Address>(
          testAccount.publicAccount,
          recipientAddress,
          mosaicId,
          amount,
          ReceiptType.MOSAIC_RENTAL_FEE,
          ReceiptVersion.BALANCE_TRANSFER);

      final testReceipts = <Receipt>[
        mosaicExpiryReceipt,
        balanceChangeReceipt,
        balanceTransferReceipt
      ];

      // Create a new transaction statement
      TransactionStatement transactionStatement =
          new TransactionStatement(height, receiptSource, testReceipts);
      expect(transactionStatement.height, equals(height));
      expect(transactionStatement.receiptSource, equals(receiptSource));
      expect(ArrayUtils.deepEqual(transactionStatement.receipts, testReceipts), isTrue);
    });
  });
}
