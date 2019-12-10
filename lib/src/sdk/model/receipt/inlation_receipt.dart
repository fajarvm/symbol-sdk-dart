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

library nem2_sdk_dart.sdk.model.receipt.inflation_receipt;

import 'dart:typed_data' show ByteData, Endian, Uint8List;

import '../common/uint64.dart';
import '../mosaic/mosaic_id.dart';
import 'receipt.dart';
import 'receipt_type.dart';
import 'receipt_version.dart';

/// Balance Change: A mosaic credit or debit was triggered.
class InflationReceipt extends Receipt {
  /// The mosaic id.
  final MosaicId mosaicId;

  /// The amount of mosaic.
  final Uint64 amount;

  InflationReceipt._(this.mosaicId, this.amount, ReceiptType type, ReceiptVersion version, int size)
      : super(type, version, size);

  factory InflationReceipt(
      MosaicId mosaicId, Uint64 amount, ReceiptType type, ReceiptVersion version,
      [int size]) {
    ArgumentError.checkNotNull(mosaicId);
    ArgumentError.checkNotNull(type);
    ArgumentError.checkNotNull(version);
    _validate(type);
    return InflationReceipt._(mosaicId, amount, type, version, size);
  }

  /// Validates the receipt type.
  static void _validate(ReceiptType type) {
    if (ReceiptType.INFLATION != type) {
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

    return data.buffer.asUint8List();
  }
}
