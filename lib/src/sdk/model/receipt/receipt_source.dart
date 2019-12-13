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

library nem2_sdk_dart.sdk.model.receipt.receipt_source;

import 'dart:typed_data' show ByteData, Endian, Uint8List;

/// The Receipt Source class.
class ReceiptSource {
  /// The transaction primary source (e.g. index within block).
  final int primaryId;

  /// The transaction secondary source (e.g. index within aggregate).
  final int secondaryId;

  ReceiptSource(this.primaryId, this.secondaryId);

  /// Serializes this receipt and returns receipt bytes.
  Uint8List serialize() {
    ByteData data = new ByteData(8);
    data.setUint32(0, primaryId, Endian.little);
    data.setUint32(4, secondaryId, Endian.little);

    return data.buffer.asUint8List();
  }
}
