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

import '../account/address.dart';
import '../account/public_account.dart';
import '../common/uint64.dart';
import '../mosaic/mosaic_id.dart';
import '../namespace/address_alias.dart';
import 'receipt.dart';
import 'receipt_type.dart';
import 'receipt_version.dart';

/// Balance Transfer: A mosaic transfer was triggered.
class BalanceTransferReceipt<T> extends Receipt {
  /// The sender's public account.
  final PublicAccount sender;

  /// The recipient. Must either be an [Address] or an [AddressAlias].
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

  /// Validates the receipt type. The [recipient] must either be an [Address] or an [AddressAlias].
  ///
  /// Throws an error when the type is not valid.
  static void _validate(dynamic recipient, ReceiptType type) {
    if (recipient is Address || recipient is AddressAlias) {
      if (ReceiptType.BalanceTransfer.contains(type)) {
        return;
      }
    }

    throw new ArgumentError('Invalid BalanceTransferReceipt: ['
        'recipient="$recipient",'
        'type="$type",'
        ']');
  }
}
