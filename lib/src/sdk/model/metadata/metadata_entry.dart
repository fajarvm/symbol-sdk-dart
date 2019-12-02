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

library nem2_sdk_dart.sdk.model.metadata.metadata_entry;

import 'package:nem2_sdk_dart/nem2_sdk_dart.dart';

import '../common/id.dart';
import '../common/uint64.dart';
import 'metadata_type.dart';

/// The metadata entry.
class MetadataEntry {
  /// The composite hash.
  final String compositeHash;

  /// The metadata sender's public key.
  final String senderPublicKey;

  /// The metadata target's public key.
  final String targetPublicKey;

  /// The key scoped to source, target and type.
  final Uint64 scopedMetadataKey;

  /// The type of metadata.
  final MetadataType metadataType;

  /// The metadata value.
  final String value;

  /// The identifier of metadata target.
  ///
  /// The target can be a [MosaicId] or a [NamespaceId]. This property is optional.
  final Id targetId;

  MetadataEntry(this.compositeHash, this.senderPublicKey, this.targetPublicKey,
      this.scopedMetadataKey, this.metadataType, this.value,
      [this.targetId]);
}
