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

library symbol_sdk_dart.sdk.model.receipt.transaction_statement;

import 'dart:typed_data' show ByteData, Endian, Uint8List;

import 'package:symbol_sdk_dart/core.dart' show HexUtils, SHA3Hasher;

import '../common/uint64.dart';
import 'receipt.dart';
import 'receipt_source.dart';
import 'receipt_type.dart';
import 'receipt_version.dart';

/// A transaction statement is a collection of receipts linked with a transaction in a particular
/// block.
///
/// Statements can include receipts with the following basic types:
/// * Balance Transfer: The invisible state change triggered a mosaic transfer.
/// * Balance Change: The invisible state change altered an account balance.
/// * Mosaic Expiry: A mosaic expired.
/// * Namespace Expiry: A namespace expired.
/// * Inflation: Native currency mosaics were created due to inflation.
class TransactionStatement {
  /// The block height.
  final Uint64 height;

  /// The receipt source. The transaction that triggered the receipt.
  final ReceiptSource source;

  /// A collection of receipts.
  final List<Receipt> receipts;

  TransactionStatement(this.height, this.source, this.receipts);

  /// Serializes this transaction statement and generate hash.
  String generateHash() {
    ByteData data = new ByteData(12);
    // version part
    data.setUint16(0, ReceiptVersion.RESOLUTION_STATEMENT.value, Endian.little);

    // type part
    data.setUint16(2, ReceiptType.TRANSACTION_GROUP.value, Endian.little);

    // receipt source part
    final Uint8List receiptSource = source.serialize();
    final ByteData idData = ByteData.view(receiptSource.buffer);
    data.setUint64(4, idData.getUint64(0));

    // receipts bytes
    List<int> results = data.buffer.asUint8List().toList();
    receipts.forEach((entry) {
      final Uint8List bytes = entry.serialize();
      results.addAll(bytes.toList());
    });

    // hash SHA3-256
    final Uint8List hash =
        SHA3Hasher.hash(Uint8List.fromList(results), SHA3Hasher.HASH_SIZE_32_BYTES);
    return HexUtils.bytesToHex(hash).toUpperCase();
  }
}
