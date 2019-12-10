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

library nem2_sdk_dart.sdk.model.receipt.balance_change_receipt;

import 'dart:typed_data' show ByteData, Endian, Uint8List;

import 'package:nem2_sdk_dart/core.dart' show HexUtils;

import '../account/public_account.dart';
import '../common/uint64.dart';
import '../mosaic/mosaic_id.dart';
import 'receipt.dart';
import 'receipt_type.dart';
import 'receipt_version.dart';

/// Balance Change: A mosaic credit or debit was triggered.
class BalanceChangeReceipt extends Receipt {
  /// The target account public account.
  final PublicAccount account;

  /// The mosaic id.
  final MosaicId mosaicId;

  /// The amount of mosaic.
  final Uint64 amount;

  BalanceChangeReceipt._(
      this.account, this.mosaicId, this.amount, ReceiptType type, ReceiptVersion version, int size)
      : super(type, version, size);

  factory BalanceChangeReceipt(PublicAccount account, MosaicId mosaicId, Uint64 amount,
      ReceiptType type, ReceiptVersion version,
      [int size]) {
    ArgumentError.checkNotNull(account);
    ArgumentError.checkNotNull(mosaicId);
    ArgumentError.checkNotNull(type);
    ArgumentError.checkNotNull(version);
    _validate(type);
    return BalanceChangeReceipt._(account, mosaicId, amount, type, version, size);
  }

  /// Validates the receipt type.
  static void _validate(ReceiptType type) {
    if (!ReceiptType.BalanceChange.contains(type)) {
      throw new ArgumentError('Invalid receipt type: $type');
    }
  }

  @override
  Uint8List serialize() {
    ByteData data = new ByteData(20);
    data.setUint16(0, version.value, Endian.little); // version part
    data.setUint16(2, type.value, Endian.little); // type part
    // mosaic part
    final Uint64 mosaicValue = Uint64.fromHex(mosaicId.toHex());
    final ByteData mosaicData = ByteData.view(mosaicValue.toBytes().buffer);
    data.setUint64(4, mosaicData.getUint64(0));
    // amount part
    final Uint64 amountValue = Uint64.fromHex(amount.toHex());
    final ByteData amountData = ByteData.view(amountValue.toBytes().buffer);
    data.setUint64(12, amountData.getUint64(0));

    final Uint8List firstParts = data.buffer.asUint8List();

    // public account part
    final Uint8List accountBytes = HexUtils.getBytes(account.publicKey);

    final Uint8List result = Uint8List(52);
    result.setAll(0, firstParts);
    result.setAll(20, accountBytes);
    return result;
  }
}
