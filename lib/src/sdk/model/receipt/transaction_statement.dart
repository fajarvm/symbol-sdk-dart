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

library nem2_sdk_dart.sdk.model.receipt.transaction_statement;

import '../common/uint64.dart';
import 'receipt.dart';
import 'receipt_source.dart';

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

  /// The transaction that triggered the creation of the receipt.
  final ReceiptSource receiptSource;

  /// A collection of receipts.
  final List<Receipt> receipts;

  TransactionStatement(this.height, this.receiptSource, this.receipts);
}
