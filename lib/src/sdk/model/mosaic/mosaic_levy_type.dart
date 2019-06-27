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

library nem2_sdk_dart.sdk.model.mosaic.mosaic_levy_type;

/// The levy type of a mosaic.
///
/// Supported levy types are:
/// * 1: Absolute levy.
/// * 2: Calculated levy.
class MosaicLevyType {
  static const String _INVALID_MOSAIC_LEVY_TYPE = 'invalid mosaic levy type';

  /// The levy is an absolute fee.
  ///
  /// The fee states how many sub-units of the specified mosaic will be
  /// transferred to the recipient.
  static const int ABSOLUTE = 1;

  /// The levy is calculated from the transferred amount.
  ///
  /// The fee states how many percentiles of the transferred quantity will
  /// be transferred to the recipient.
  static const int CALCULATED = 2;

  static const MosaicLevyType _singleton = MosaicLevyType._();

  const MosaicLevyType._();

  factory MosaicLevyType() {
    return _singleton;
  }

  static int getType(final int mosaicLevyType) {
    switch (mosaicLevyType) {
      case ABSOLUTE:
        return MosaicLevyType.ABSOLUTE;
      case CALCULATED:
        return MosaicLevyType.CALCULATED;
      default:
        throw new ArgumentError(_INVALID_MOSAIC_LEVY_TYPE);
    }
  }
}
