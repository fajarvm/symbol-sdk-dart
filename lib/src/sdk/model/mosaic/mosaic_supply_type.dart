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

library nem2_sdk_dart.sdk.model.mosaic.mosaic_supply_type;

/// The supply type of a mosaic.
///
/// Supported supply types are:
/// * 0: Increase in supply.
/// * 1: Decrease in supply.
class MosaicSupplyType {
  /// Mosaic with this type can decrease in supply.
  static const int DECREASE = 0;

  /// Mosaic with this type can increase in supply.
  static const int INCREASE = 1;

  static final MosaicSupplyType _singleton = new MosaicSupplyType._();

  MosaicSupplyType._();

  factory MosaicSupplyType() {
    return _singleton;
  }

  static int getMosaicSupplyType(final int mosaicSupplyType) {
    switch (mosaicSupplyType) {
      case DECREASE:
        return MosaicSupplyType.DECREASE;
      case INCREASE:
        return MosaicSupplyType.INCREASE;
      default:
        throw new ArgumentError('invalid mosaic supply type');
    }
  }
}
