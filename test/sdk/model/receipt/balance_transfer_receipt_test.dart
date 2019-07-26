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

library nem2_sdk_dart.test.sdk.model.receipt.balance_transfer_receipt_test;

import 'package:nem2_sdk_dart/sdk.dart'
    show
        Account,
        Address,
        AddressAlias,
        BalanceTransferReceipt,
        MosaicId,
        NetworkType,
        PublicAccount,
        ReceiptType,
        ReceiptVersion,
        Uint64;
import 'package:test/test.dart';

void main() {
  group('BalanceTransferReceipt', () {
    // setup
    final Account testAccount = Account.fromPrivateKey(
        '787225aaff3d2c71f4ffa32d4f19ec4922f3cd869747f267378f81f8e3fcb12d', NetworkType.MIJIN_TEST);
    final PublicAccount sender = testAccount.publicAccount;
    final MosaicId mosaicId = MosaicId.fromHex('85bbea6cc462b244');
    final Uint64 amount = Uint64.fromBigInt(BigInt.from(10));
    final Address testAddress =
        Address.fromRawAddress('SDGLFW-DSHILT-IUHGIB-H5UGX2-VYF5VN-JEKCCD-BR26');
    final AddressAlias testAlias = new AddressAlias(testAddress);

    // helper methods
    BalanceTransferReceipt _newBalanceTransferReceipt(
        PublicAccount account, recipient, MosaicId id, ReceiptType type) {
      return new BalanceTransferReceipt(
          account, recipient, id, amount, type, ReceiptVersion.BALANCE_TRANSFER);
    }

    void _createAndAssertReceipt(ReceiptType type, recipient) {
      BalanceTransferReceipt receipt =
          _newBalanceTransferReceipt(sender, recipient, mosaicId, type);

      expect(receipt.sender.publicKey, equals(sender.publicKey));
      if (recipient is Address) {
        expect((receipt.recipient as Address).pretty, equals(testAddress.pretty));
      }
      if (recipient is AddressAlias) {
        expect((receipt.recipient as AddressAlias), equals(testAlias));
      }
      expect(receipt.mosaicId.toHex(), equals('85bbea6cc462b244'));
      expect(receipt.amount.value, equals(amount.value));
      expect(receipt.type, equals(type));
      expect(receipt.version, equals(ReceiptVersion.BALANCE_TRANSFER));
      expect(receipt.size, isNull);
    }

    test('Check the number of receipts with type BalanceTransfer', () {
      expect(ReceiptType.BalanceTransfer.length, 2);
    });

    int count = 1;
    for (var type in ReceiptType.BalanceTransfer) {
      test('Can create balance transfer receipt using address and type #$count: $type', () {
        _createAndAssertReceipt(type, testAddress);
      });
      test('Can create balance transfer receipt using address alias and type #$count: $type', () {
        _createAndAssertReceipt(type, testAlias);
      });
      count++;
    }

    test('Should throw an exception when creating a receipt with bad parameter values', () {
      // null sender
      expect(
          () => _newBalanceTransferReceipt(
              null, testAddress, mosaicId, ReceiptType.MOSAIC_RENTAL_FEE),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));

      // null recipient
      expect(
          () => _newBalanceTransferReceipt(sender, null, mosaicId, ReceiptType.MOSAIC_RENTAL_FEE),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));

      // null mosaic id
      expect(
          () =>
              _newBalanceTransferReceipt(sender, testAddress, null, ReceiptType.MOSAIC_RENTAL_FEE),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));

      // null receipt type
      expect(
          () => _newBalanceTransferReceipt(sender, testAddress, mosaicId, null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));

      // null receipt version
      expect(
          () => BalanceTransferReceipt(
              sender, testAddress, mosaicId, null, ReceiptType.MOSAIC_RENTAL_FEE, null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));

      // invalid recipient
      expect(
          () => _newBalanceTransferReceipt(sender, '', mosaicId, ReceiptType.MOSAIC_RENTAL_FEE),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message.toString().contains('Invalid BalanceTransferReceipt'))));

      // invalid receipt type
      expect(
          () => _newBalanceTransferReceipt(sender, testAddress, mosaicId, ReceiptType.INFLATION),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message.toString().contains('Invalid BalanceTransferReceipt'))));
    });
  });
}
