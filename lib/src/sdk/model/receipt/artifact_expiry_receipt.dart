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

import '../mosaic/mosaic_id.dart';
import '../namespace/namespace_id.dart';
import 'receipt.dart';
import 'receipt_type.dart';
import 'receipt_version.dart';

/// Artifact Expiry: An artifact (e.g. namespace, mosaic) expired.
class ArtifactExpiryReceipt<T> extends Receipt {
  /// The artifact id. It can either be a [MosaicId] or a [NamespaceId].
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
  static void _validate(Object artifactId, ReceiptType type) {
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
}
