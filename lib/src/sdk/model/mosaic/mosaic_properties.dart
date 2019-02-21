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

library nem2_sdk_dart.sdk.model.mosaic.mosaic_properties;

import 'package:nem2_sdk_dart/core.dart' show Uint64;

/// Describes the properties a mosaic can have.
class MosaicProperties {
  /// The mosaic supply mutability. When set to `true`, allows the supply to be changed at
  /// later point.
  ///
  /// Default value is `false`.
  final bool supplyMutable;

  /// The mosaic transferability. Defines if the mosaic is allowed for transfers among accounts
  /// other than the creator. When set to `false`, this mosaic can only be transferred to and from
  /// the creator of this mosaic. When set to `true` this mosaic can be transferred to and from
  /// arbitrary accounts.
  ///
  /// Default value is `true`.
  final bool transferable;

  /// The mutability of the levy of this mosaic.
  ///
  /// Default value is `false`.
  final bool levyMutable;

  /// The divisibility determines the decimal place the mosaic can be divided into. The value must
  /// be in the range of 0 and 6. A divisibility of 3 means that a mosaic can be divided into
  /// smallest parts of 0.001 mosaics.
  ///
  /// Default value is 0.
  final int divisibility;

  /// The duration in blocks a mosaic will become available. When the duration finishes, this mosaic
  /// becomes inactive and a subject for renewal.
  final Uint64 duration;

  const MosaicProperties._(
      this.supplyMutable, this.transferable, this.levyMutable, this.divisibility, this.duration);

  factory MosaicProperties(
      {final bool supplyMutable = false,
      final bool transferable = true,
      final bool levyMutable = false,
      final int divisibility = 0,
      final Uint64 duration}) {
    return new MosaicProperties._(
        supplyMutable, transferable, levyMutable, divisibility, duration);
  }

  /// Creates mosaic properties with the [duration]. Default values are set for other properties.
  static MosaicProperties create(Uint64 duration) {
    return MosaicProperties(duration: duration);
  }
}
