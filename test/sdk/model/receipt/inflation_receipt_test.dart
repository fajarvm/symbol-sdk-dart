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

library nem2_sdk_dart.test.sdk.model.receipt.inflation_receipt_test;

import 'package:nem2_sdk_dart/core.dart' show HexUtils;
import 'package:nem2_sdk_dart/sdk.dart'
    show InflationReceipt, MosaicId, ReceiptType, ReceiptVersion, Uint64;
import 'package:test/test.dart';

void main() {
  group('InflationReceipt', () {
    // setup
    final MosaicId mosaicId = MosaicId.fromHex('85bbea6cc462b244');
    final Uint64 amount = Uint64.fromBigInt(BigInt.from(10));

    test('Can create inflation receipt', () {
      InflationReceipt receipt = new InflationReceipt(
          mosaicId, amount, ReceiptType.INFLATION, ReceiptVersion.INFLATION_RECEIPT);

      expect(receipt.type, equals(ReceiptType.INFLATION));
      expect(receipt.version, equals(ReceiptVersion.INFLATION_RECEIPT));
      expect(receipt.mosaicId.toHex(), equals('85bbea6cc462b244'));
      expect(receipt.amount, equals(amount));
      expect(receipt.size, isNull);
      String hex = HexUtils.bytesToHex(receipt.serialize());
      expect(hex, equals('0100435144b262c46ceabb850a00000000000000'));
    });

    test('Can create inflation receipt with size', () {
      InflationReceipt receipt = new InflationReceipt(
          mosaicId, amount, ReceiptType.INFLATION, ReceiptVersion.INFLATION_RECEIPT, 100);

      expect(receipt.type, equals(ReceiptType.INFLATION));
      expect(receipt.version, equals(ReceiptVersion.INFLATION_RECEIPT));
      expect(receipt.mosaicId.toHex(), equals('85bbea6cc462b244'));
      expect(receipt.amount, equals(amount));
      expect(receipt.size, 100);
      String hex = HexUtils.bytesToHex(receipt.serialize());
      expect(hex, equals('0100435144b262c46ceabb850a00000000000000'));
    });

    test('Should throw an exception when creating a receipt with bad parameter values', () {
      // null mosaicId
      expect(
          () => InflationReceipt(
              null, amount, ReceiptType.INFLATION, ReceiptVersion.INFLATION_RECEIPT),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));

      // null receipt type
      expect(
          () => InflationReceipt(mosaicId, amount, null, ReceiptVersion.INFLATION_RECEIPT),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));

      // null receipt version
      expect(
          () => InflationReceipt(mosaicId, amount, ReceiptType.INFLATION, null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));

      // invalid receipt type
      expect(
          () => InflationReceipt(
              mosaicId, amount, ReceiptType.MOSAIC_RENTAL_FEE, ReceiptVersion.INFLATION_RECEIPT),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Invalid receipt type'))));
    });
  });
}
