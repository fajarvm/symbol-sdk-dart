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

library symbol_sdk_dart.sdk.model.restriction.mosaic_restriction_type;

/// The mosaic restriction type.
class MosaicRestrictionType {
  static const String UNKNOWN_MOSAIC_RESTRICTION_TYPE = 'unknown mosaic restriction type';

  /// Uninitialized value indicates no restriction.
  static const MosaicRestrictionType NONE = MosaicRestrictionType._(0);

  /// Allow if equals.
  static const MosaicRestrictionType EQ = MosaicRestrictionType._(1);

  /// Allow if not equals.
  static const MosaicRestrictionType NE = MosaicRestrictionType._(2);

  /// Allow if less than.
  static const MosaicRestrictionType LT = MosaicRestrictionType._(3);

  /// Allow if less than or equal.
  static const MosaicRestrictionType LE = MosaicRestrictionType._(4);

  /// Allow if greater than.
  static const MosaicRestrictionType GT = MosaicRestrictionType._(5);

  /// Allow if greater than or equal.
  static const MosaicRestrictionType GE = MosaicRestrictionType._(6);

  /// Supported restriction types.
  static final List<MosaicRestrictionType> values = <MosaicRestrictionType>[
    NONE,
    EQ,
    NE,
    LT,
    LE,
    GT,
    GE
  ];

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const MosaicRestrictionType._(this.value);

  /// Returns a [MosaicRestrictionType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static MosaicRestrictionType fromInt(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_MOSAIC_RESTRICTION_TYPE);
  }

  @override
  String toString() {
    return 'MosaicRestrictionType{value: $value}';
  }
}
