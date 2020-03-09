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

library symbol_sdk_dart.sdk.model.mosaic.mosaic_supply_type;

/// The supply type of a mosaic.
class MosaicSupplyType {
  static const String UNKNOWN_MOSAIC_SUPPLY_TYPE = 'unknown mosaic supply type';

  /// Mosaic with this type can decrease in supply.
  static const MosaicSupplyType DECREASE = MosaicSupplyType._(0);

  /// Mosaic with this type can increase in supply.
  static const MosaicSupplyType INCREASE = MosaicSupplyType._(1);

  /// Supported mosaic supply types.
  static final List<MosaicSupplyType> values = <MosaicSupplyType>[DECREASE, INCREASE];

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const MosaicSupplyType._(this.value);

  /// Returns a [MosaicSupplyType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static MosaicSupplyType fromInt(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_MOSAIC_SUPPLY_TYPE);
  }

  @override
  String toString() {
    return 'MosaicSupplyType{value: $value}';
  }
}
