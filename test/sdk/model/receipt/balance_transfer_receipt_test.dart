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

library symbol_sdk_dart.test.sdk.model.receipt.balance_transfer_receipt_test;

import 'dart:typed_data' show Uint8List;

import 'package:symbol_sdk_dart/core.dart' show HexUtils;
import 'package:symbol_sdk_dart/sdk.dart'
    show
        Account,
        Address,
        BalanceTransferReceipt,
        MosaicId,
        NamespaceId,
        NetworkType,
        PublicAccount,
        ReceiptType,
        ReceiptVersion,
        Uint64;
import 'package:test/test.dart';

void main() {
  group('BalanceTransferReceipt', () {
    // setup
    final NetworkType networkType = NetworkType.MIJIN_TEST;
    final Account testAccount = Account.fromPrivateKey(
        '787225aaff3d2c71f4ffa32d4f19ec4922f3cd869747f267378f81f8e3fcb12d', networkType);
    final PublicAccount sender = testAccount.publicAccount;
    final MosaicId mosaicId = MosaicId.fromHex('85bbea6cc462b244');
    final Uint64 amount = Uint64.fromBigInt(BigInt.from(10));
    final Address testAddress =
        Address.fromRawAddress('SDGLFW-DSHILT-IUHGIB-H5UGX2-VYF5VN-JEKCCD-BR26');
    final NamespaceId testNamespaceId = NamespaceId.fromInts(3646934825, 3576016193);

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
      if (recipient is NamespaceId) {
        expect((receipt.recipient as NamespaceId), equals(testNamespaceId));
      }
      expect(receipt.mosaicId.toHex(), equals('85bbea6cc462b244'));
      expect(receipt.amount.value, equals(amount.value));
      expect(receipt.type, equals(type));
      expect(receipt.version, equals(ReceiptVersion.BALANCE_TRANSFER));
      expect(receipt.size, isNull);
      Uint8List receiptByte = receipt.serialize();
      expect(receiptByte.length, equals(52 + receipt.getRecipientBytes().length));
    }

    test('Check the number of receipts with type BalanceTransfer', () {
      expect(ReceiptType.BalanceTransfer.length, 2);
    });

    int count = 1;
    for (var type in ReceiptType.BalanceTransfer) {
      test('Can create balance transfer receipt using address and type #$count: ${type.name}', () {
        _createAndAssertReceipt(type, testAddress);
      });
      test('Can create balance transfer receipt using namespaceId and type #$count: ${type.name}',
          () {
        _createAndAssertReceipt(type, testNamespaceId);
      });
      count++;
    }

    test('serialize() result should be the same as that produced by other SDKs', () {
      // Test result from TypeScript SDK
      BalanceTransferReceipt balanceTransferReceipt = new BalanceTransferReceipt(
          Account.fromPrivateKey(
                  'D242FB34C2C4DD36E995B9C865F93940065E326661BA5A4A247331D211FE3A3D', networkType)
              .publicAccount,
          Address.fromEncoded('9103B60AAF2762688300000000000000000000000000000000'),
          MosaicId.fromHex('941299B2B7E1291C'),
          Uint64(1000),
          ReceiptType.MOSAIC_RENTAL_FEE,
          ReceiptVersion.BALANCE_TRANSFER);

      Uint8List serialized = balanceTransferReceipt.serialize();
      String hex = HexUtils.bytesToHex(serialized);
      expect(
          '01004D121C29E1B7B2991294E8030000000000002FC3872A792933617D70E02AFF8FBDE152821'
          'A0DF0CA5FB04CB56FC3D21C88639103B60AAF2762688300000000000000000000000000000000',
          equals(hex.toUpperCase()));
    });

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
