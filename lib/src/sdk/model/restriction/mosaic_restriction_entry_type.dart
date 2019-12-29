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

library nem2_sdk_dart.sdk.model.restriction.mosaic_restriction_entry_type;

/// Mosaic restriction entry type.
class MosaicRestrictionEntryType {
  static const String UNKNOWN_MOSAIC_RESTRICTION_ENTRY_TYPE =
      'unknown mosaic restriction entry type';

  /// Mosaic address restriction.
  static const MosaicRestrictionEntryType ADDRESS = MosaicRestrictionEntryType._(0);

  /// Mosaic global restriction.
  static const MosaicRestrictionEntryType GLOBAL = MosaicRestrictionEntryType._(1);

  static final List<MosaicRestrictionEntryType> values = <MosaicRestrictionEntryType>[
    ADDRESS,
    GLOBAL
  ];

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const MosaicRestrictionEntryType._(this.value);

  /// Returns a [MosaicRestrictionEntryType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static MosaicRestrictionEntryType fromInt(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_MOSAIC_RESTRICTION_ENTRY_TYPE);
  }

  @override
  String toString() {
    return 'MosaicRestrictionEntryType{value: $value}';
  }
}
