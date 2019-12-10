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

library nem2_sdk_dart.sdk.model.receipt.balance_transfer_receipt;

import 'dart:typed_data' show ByteData, Endian, Uint8List;

import 'package:nem2_sdk_dart/core.dart' show HexUtils;

import '../account/address.dart';
import '../account/public_account.dart';
import '../common/uint64.dart';
import '../common/unresolved_address.dart';
import '../mosaic/mosaic_id.dart';
import '../namespace/namespace_id.dart';
import 'receipt.dart';
import 'receipt_type.dart';
import 'receipt_version.dart';

/// Balance Transfer: A mosaic transfer was triggered.
class BalanceTransferReceipt<T> extends Receipt {
  /// The sender's public account.
  final PublicAccount sender;

  /// The recipient. Must either be an [Address] or a [NamespaceId].
  final T recipient;

  /// The mosaic id.
  final MosaicId mosaicId;

  /// The amount of mosaic.
  final Uint64 amount;

  BalanceTransferReceipt._(this.sender, this.recipient, this.mosaicId, this.amount,
      ReceiptType type, ReceiptVersion version, int size)
      : super(type, version, size);

  factory BalanceTransferReceipt(PublicAccount sender, dynamic recipient, MosaicId mosaicId,
      Uint64 amount, ReceiptType type, ReceiptVersion version,
      [int size]) {
    ArgumentError.checkNotNull(sender);
    ArgumentError.checkNotNull(recipient);
    ArgumentError.checkNotNull(mosaicId);
    ArgumentError.checkNotNull(type);
    ArgumentError.checkNotNull(version);
    _validate(recipient, type);
    return BalanceTransferReceipt._(sender, recipient, mosaicId, amount, type, version, size);
  }

  /// Validates the receipt type. The [recipient] must either be an [Address] or a [NamespaceId].
  ///
  /// Throws an error when the type is not valid.
  static void _validate(dynamic recipient, ReceiptType type) {
    if (recipient is Address || recipient is NamespaceId) {
      if (ReceiptType.BalanceTransfer.contains(type)) {
        return;
      }
    }

    throw new ArgumentError('Invalid BalanceTransferReceipt: ['
        'recipient="$recipient",'
        'type="$type",'
        ']');
  }

  /// Returns the recipient bytes of this receipt.
  Uint8List getRecipientBytes() {
    return UnresolvedAddress.toUnresolvedAddressBytes(recipient, sender.address.networkType);
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
    final Uint8List accountBytes = HexUtils.getBytes(sender.publicKey);

    // recipient part
    final Uint8List recipientBytes = getRecipientBytes();

    final Uint8List result = Uint8List(52 + recipientBytes.length);
    result.setAll(0, firstParts);
    result.setAll(20, accountBytes);
    result.setAll(52, recipientBytes);
    return result;
  }
}
