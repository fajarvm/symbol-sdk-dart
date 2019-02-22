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

library nem2_sdk_dart.sdk.model.mosaic.mosaic_info;

import 'package:nem2_sdk_dart/core.dart' show Uint64;

import '../account/public_account.dart';
import '../namespace/namespace_id.dart';

import 'mosaic_id.dart';
import 'mosaic_properties.dart';

/// Contains information about a mosaic.
class MosaicInfo {
  /// Determines if the mosaic is active or not.
  final bool active;

  /// The mosaic index.
  final int index;

  /// The meta ID.
  final String metaId;

  /// The namespace ID the mosaic is attached to.
  final NamespaceId namespaceId;

  /// The mosaic ID.
  final MosaicId mosaicId;

  /// The total supply of the mosaic.
  final Uint64 supply;

  /// The block height the mosaic was created.
  final Uint64 height;

  /// The account of the owner of this mosaic.
  final PublicAccount owner;

  /// The properties of the mosaic.
  final MosaicProperties properties;

  const MosaicInfo._(this.active, this.index, this.metaId, this.namespaceId, this.mosaicId,
      this.supply, this.height, this.owner, this.properties);

  factory MosaicInfo(
      final bool isActive,
      final int index,
      final String metaId,
      final NamespaceId namespaceId,
      final MosaicId mosaicId,
      final Uint64 supply,
      final Uint64 height,
      final PublicAccount owner,
      final MosaicProperties properties) {
    if (0 > index) {
      throw new ArgumentError('index must not be negative');
    }

    return new MosaicInfo._(
        isActive, index, metaId, namespaceId, mosaicId, supply, height, owner, properties);
  }

  /// Returns the mosaic divisibility
  int get divisibility => properties.divisibility;

  /// Returns the mosaic duration
  Uint64 get duration => properties.duration;

  /// Returns the mosaic supply mutability
  bool get isSupplyMutable => properties.supplyMutable;

  /// Returns the mosaic transferability
  bool get isTransferable => properties.transferable;

  /// Returns the mosaic levy mutability
  bool get isLevyMutable => properties.levyMutable;
}
