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

library symbol_sdk_dart.sdk.model.mosaic.mosaic_info;

import '../account/public_account.dart';
import '../common/uint64.dart';

import 'mosaic_flags.dart';
import 'mosaic_id.dart';

/// Contains information about a mosaic.
class MosaicInfo {
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

  /// The mosaic flags.
  final MosaicFlags flags;

  /// The divisibility determines the decimal place the mosaic can be divided into.
  final int divisibility;

  /// The duration in blocks a mosaic will become available.
  final Uint64 duration;

  MosaicInfo._(this.mosaicId, this.supply, this.height, this.owner, this.revision, this.flags,
      this.divisibility, this.duration);

  factory MosaicInfo(
    final MosaicId mosaicId,
    final Uint64 supply,
    final Uint64 height,
    final PublicAccount owner,
    final int revision,
    final MosaicFlags flags,
    final int divisibility,
    final Uint64 duration,
  ) {
    if (0 > revision) {
      throw new ArgumentError('revision must not be negative');
    }
    if (0 > divisibility) {
      throw new ArgumentError('divisibility must not be negative');
    }

    return new MosaicInfo._(
        mosaicId, supply, height, owner, revision, flags, divisibility, duration);
  }

  /// Returns the mosaic supply mutability.
  bool get isSupplyMutable => flags.supplyMutable;

  /// Returns the mosaic transferability.
  bool get isTransferable => flags.transferable;

  /// Returns the mosaic restrictability.
  bool get isRestrictable => flags.restrictable;
}
