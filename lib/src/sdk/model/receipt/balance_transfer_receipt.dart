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

library symbol_sdk_dart.sdk.model.receipt.balance_transfer_receipt;

import 'dart:typed_data' show Uint8List;

import 'package:symbol_sdk_dart/core.dart' show HexUtils;

import '../account/address.dart';
import '../account/public_account.dart';
import '../common/uint64.dart';
import '../mosaic/mosaic_id.dart';
import '../namespace/namespace_id.dart';
import '../utils/unresolved_utils.dart';
import 'receipt.dart';
import 'receipt_type.dart';
import 'receipt_version.dart';

/// A receipt that is created when there is an invisible state change triggered by a mosaic
/// transfer.
class BalanceTransferReceipt extends Receipt {
  /// The sender's public account.
  final PublicAccount sender;

  /// The recipient. Must either be an [Address] or a [NamespaceId].
  final dynamic recipient;

  /// The mosaic id.
  final MosaicId mosaicId;

  /// The amount of mosaic.
  final Uint64 amount;

  BalanceTransferReceipt._(this.sender, this.recipient, this.mosaicId, this.amount,
      ReceiptType type, ReceiptVersion version, int size)
      : super(type, version, size);

  factory BalanceTransferReceipt(
      final PublicAccount sender,
      final dynamic recipient,
      final MosaicId mosaicId,
      final Uint64 amount,
      final ReceiptType type,
      final ReceiptVersion version,
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
    return UnresolvedUtils.toUnresolvedAddressBytes(recipient, sender.address.networkType);
  }

  @override
  Uint8List serialize() {
    final Uint8List senderBytes = HexUtils.getBytes(sender.publicKey);
    final Uint8List recipientBytes = getRecipientBytes();
    final Uint8List result = Uint8List(52 + recipientBytes.length);
    // version and type part
    result.setAll(0, super.serialize());
    // mosaic part
    result.setAll(4, mosaicId.id.toBytes());
    // amount part
    result.setAll(12, amount.toBytes());
    // sender part
    result.setAll(20, senderBytes);
    // recipient part
    result.setAll(52, recipientBytes);
    return result;
  }
}
