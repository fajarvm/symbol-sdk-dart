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

library nem2_sdk_dart.sdk.model.receipt.receipt;

import 'dart:typed_data' show ByteData, Endian, Uint8List;

import 'receipt_type.dart';
import 'receipt_version.dart';

/// A Receipt provides proof for a conditional state change in the background as a result of a
/// complex or hidden transaction.
///
/// This is an abstract class that serves as the base class of all receipts.
abstract class Receipt {
  /// The receipt type.
  final ReceiptType type;

  /// The receipt version.
  final ReceiptVersion version;

  /// The receipt size. The size is optional.
  final int size;

  Receipt(this.type, this.version, this.size) : assert(type != null && version != null);

  /// Serializes this receipt and returns receipt bytes.
  Uint8List serialize() {
    // default binary layout for this receipt is: version + type
    ByteData data = new ByteData(8);
    data.setUint16(0, version.value, Endian.little);
    data.setUint16(2, type.value, Endian.little);
    return data.buffer.asUint8List();
  }
}
