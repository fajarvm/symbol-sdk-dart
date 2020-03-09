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

library symbol_sdk_dart.sdk.model.receipt.balance_change_receipt;

import 'dart:typed_data' show Uint8List;

import 'package:symbol_sdk_dart/core.dart' show HexUtils;

import '../account/public_account.dart';
import '../common/uint64.dart';
import '../mosaic/mosaic_id.dart';
import 'receipt.dart';
import 'receipt_type.dart';
import 'receipt_version.dart';

/// A receipt that is created when there is an invisible state change triggered by a change to mosaic
/// balance of the account.
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

  factory BalanceChangeReceipt(final PublicAccount account, final MosaicId mosaicId,
      final Uint64 amount, final ReceiptType type, final ReceiptVersion version,
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
    final Uint8List result = Uint8List(52);
    // version and type part
    result.setAll(0, super.serialize());
    // mosaic part
    result.setAll(4, mosaicId.id.toBytes());
    // amount part
    result.setAll(12, amount.toBytes());
    // public account part
    final Uint8List accountBytes = HexUtils.getBytes(account.publicKey);
    result.setAll(20, accountBytes);
    return result;
  }
}
