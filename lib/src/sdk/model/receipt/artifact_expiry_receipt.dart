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

library nem2_sdk_dart.sdk.model.receipt.artifact_expiry_receipt;

import 'dart:typed_data' show ByteData, Endian, Uint8List;

import '../common/id.dart';
import '../common/uint64.dart';
import '../mosaic/mosaic_id.dart';
import '../namespace/namespace_id.dart';
import 'receipt.dart';
import 'receipt_type.dart';
import 'receipt_version.dart';

/// Artifact Expiry: An artifact (e.g. namespace, mosaic) expired.
class ArtifactExpiryReceipt<T> extends Receipt {
  /// The artifact id. It must either be a [MosaicId] or a [NamespaceId].
  final T artifactId;

  ArtifactExpiryReceipt._(this.artifactId, ReceiptType type, ReceiptVersion version, int size)
      : super(type, version, size);

  factory ArtifactExpiryReceipt(T artifactId, ReceiptType type, ReceiptVersion version,
      [int size]) {
    ArgumentError.checkNotNull(artifactId);
    ArgumentError.checkNotNull(type);
    ArgumentError.checkNotNull(version);
    _validate(artifactId, type);
    return ArtifactExpiryReceipt._(artifactId, type, version, size);
  }

  /// Validates the artifact id and receipt type.
  ///
  /// The [artifactId] must either be a [MosaicId] or a [NamespaceId].
  static void _validate(final dynamic artifactId, final ReceiptType type) {
    if (artifactId is MosaicId || artifactId is NamespaceId) {
      if (ReceiptType.ArtifactExpiry.contains(type)) {
        // OK. Match found.
        return;
      }
    }

    throw new ArgumentError('Invalid ArtifactExpiryReceipt: ['
        'artifactId="$artifactId",'
        'receiptType="$type",'
        ']');
  }

  Uint64 getArtifactIdValue() {
    if (artifactId is! Id) {
      throw new StateError('artifactId should be a valid Id object');
    }

    return Uint64.fromHex((artifactId as Id).toHex());
  }

  @override
  Uint8List serialize() {
    ByteData data = new ByteData(12);
    data.setUint16(0, version.value, Endian.little); // version part
    data.setUint16(2, type.value, Endian.little); // type part
    // artifactId part
    final Uint64 artifactIdValue = getArtifactIdValue();
    final ByteData idData = ByteData.view(artifactIdValue.toBytes().buffer);
    data.setUint64(4, idData.getUint64(0));

    return data.buffer.asUint8List();
  }
}
