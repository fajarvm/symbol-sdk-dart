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

import '../account/public_account.dart';
import '../common/uint64.dart';

import 'mosaic_id.dart';
import 'mosaic_levy.dart';
import 'mosaic_properties.dart';

/// Contains information about a mosaic.
class MosaicInfo {
  /// The meta ID.
  final String metaId;

  /// The mosaic ID.
  final MosaicId mosaicId;

  /// The total supply of the mosaic.
  final Uint64 supply;

  /// The block height the mosaic was created.
  final Uint64 height;

  /// The account of the owner of this mosaic.
  final PublicAccount owner;

  /// The mosaic revision.
  final int revision;

  /// The properties of the mosaic.
  final MosaicProperties properties;

  /// The levy of the mosaic.
  final MosaicLevy mosaicLevy;

  const MosaicInfo._(this.metaId, this.mosaicId, this.supply, this.height, this.owner,
      this.revision, this.properties, [this.mosaicLevy]);

  factory MosaicInfo(
      final String metaId,
      final MosaicId mosaicId,
      final Uint64 supply,
      final Uint64 height,
      final PublicAccount owner,
      final int revision,
      final MosaicProperties properties, [final MosaicLevy mosaicLevy]) {
    if (0 > revision) {
      throw new ArgumentError('revision must not be negative');
    }

    return new MosaicInfo._(metaId, mosaicId, supply, height, owner, revision, properties, mosaicLevy);
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
