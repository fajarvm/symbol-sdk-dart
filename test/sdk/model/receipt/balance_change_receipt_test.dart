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

library symbol_sdk_dart.test.sdk.model.receipt.balance_change_receipt_test;

import 'package:symbol_sdk_dart/core.dart' show HexUtils;
import 'package:symbol_sdk_dart/sdk.dart'
    show
        Account,
        BalanceChangeReceipt,
        MosaicId,
        NetworkType,
        PublicAccount,
        ReceiptType,
        ReceiptVersion,
        Uint64;
import 'package:test/test.dart';

void main() {
  // TODO: fix me
//  group('BalanceChangeReceipt', () {
//    // setup
//    final testAccount = Account.fromPrivateKey(
//        '787225aaff3d2c71f4ffa32d4f19ec4922f3cd869747f267378f81f8e3fcb12d', NetworkType.MIJIN_TEST);
//    final account = testAccount.publicAccount;
//    final mosaicId = MosaicId.fromHex('85bbea6cc462b244');
//    final amount = Uint64.fromBigInt(BigInt.from(10));
//
//    // helper methods
//    BalanceChangeReceipt _newBalanceChangeReceipt(
//        PublicAccount account, MosaicId id, ReceiptType type) {
//      return new BalanceChangeReceipt(account, id, amount, type, ReceiptVersion.BALANCE_CHANGE);
//    }
//
//    void _createAndAssertReceipt(ReceiptType type) {
//      BalanceChangeReceipt receipt = _newBalanceChangeReceipt(account, mosaicId, type);
//
//      expect(receipt.account.publicKey, equals(account.publicKey));
//      expect(receipt.mosaicId.toHex(), equals('85bbea6cc462b244'));
//      expect(receipt.type, equals(type));
//      expect(receipt.version, equals(ReceiptVersion.BALANCE_CHANGE));
//      expect(receipt.amount.value, equals(amount.value));
//      expect(receipt.size, isNull);
//
//      String hex = HexUtils.bytesToHex(receipt.serialize());
//      if (ReceiptType.HARVEST_FEE == receipt.type) {
//        expect(
//            hex,
//            equals(
//                '0100432144b262c46ceabb850a000000000000001026d70e1954775749c6811084d6450a3184d977383f0e4282cd47118af37755'));
//      }
//      if (ReceiptType.LOCKHASH_CREATED == receipt.type) {
//        expect(
//            hex,
//            equals(
//                '0100483144b262c46ceabb850a000000000000001026d70e1954775749c6811084d6450a3184d977383f0e4282cd47118af37755'));
//      }
//      if (ReceiptType.LOCKHASH_EXPIRED == receipt.type) {
//        expect(
//            hex,
//            equals(
//                '0100482344b262c46ceabb850a000000000000001026d70e1954775749c6811084d6450a3184d977383f0e4282cd47118af37755'));
//      }
//      if (ReceiptType.LOCKHASH_COMPLETED == receipt.type) {
//        expect(
//            hex,
//            equals(
//                '0100482244b262c46ceabb850a000000000000001026d70e1954775749c6811084d6450a3184d977383f0e4282cd47118af37755'));
//      }
//      if (ReceiptType.LOCKSECRET_CREATED == receipt.type) {
//        expect(
//            hex,
//            equals(
//                '0100523144b262c46ceabb850a000000000000001026d70e1954775749c6811084d6450a3184d977383f0e4282cd47118af37755'));
//      }
//      if (ReceiptType.LOCKSECRET_EXPIRED == receipt.type) {
//        expect(
//            hex,
//            equals(
//                '0100522344b262c46ceabb850a000000000000001026d70e1954775749c6811084d6450a3184d977383f0e4282cd47118af37755'));
//      }
//      if (ReceiptType.LOCKSECRET_COMPLETED == receipt.type) {
//        expect(
//            hex,
//            equals(
//                '0100522244b262c46ceabb850a000000000000001026d70e1954775749c6811084d6450a3184d977383f0e4282cd47118af37755'));
//      }
//    }
//
//    test('Check the number of receipts with type BalanceChange', () {
//      expect(ReceiptType.BalanceChange.length, 7);
//    });
//
//    int count = 1;
//    for (var type in ReceiptType.BalanceChange) {
//      test('Can create balance change receipt #$count: ${type.name}', () {
//        _createAndAssertReceipt(type);
//      });
//      count++;
//    }
//
//    test('Should throw an exception when creating a receipt with bad parameter values', () {
//      // null account
//      expect(
//          () => _newBalanceChangeReceipt(null, mosaicId, ReceiptType.HARVEST_FEE),
//          throwsA(predicate(
//              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));
//
//      // null mosaic id
//      expect(
//          () => _newBalanceChangeReceipt(account, null, ReceiptType.HARVEST_FEE),
//          throwsA(predicate(
//              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));
//
//      // null receipt type
//      expect(
//          () => _newBalanceChangeReceipt(account, mosaicId, null),
//          throwsA(predicate(
//              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));
//
//      // null receipt version
//      expect(
//          () => BalanceChangeReceipt(account, mosaicId, amount, ReceiptType.HARVEST_FEE, null),
//          throwsA(predicate(
//              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));
//
//      // invalid receipt type
//      expect(
//          () => _newBalanceChangeReceipt(account, mosaicId, ReceiptType.INFLATION),
//          throwsA(predicate(
//              (e) => e is ArgumentError && e.message.toString().contains('Invalid receipt type'))));
//    });
//  });
}
