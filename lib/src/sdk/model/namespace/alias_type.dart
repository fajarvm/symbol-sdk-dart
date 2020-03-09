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

library symbol_sdk_dart.sdk.model.namespace.alias_type;

/// The alias type.
class AliasType {
  static const String UNKNOWN_ALIAS_TYPE = 'unknown alias type';

  /// No alias.
  static const AliasType NONE = AliasType._(0);

  /// This type identifies an alias to a mosaic.
  static const AliasType MOSAIC = AliasType._(1);

  /// This type identifies an alias to an address.
  static const AliasType ADDRESS = AliasType._(2);

  /// Supported alias types.
  static final List<AliasType> values = <AliasType>[NONE, MOSAIC, ADDRESS];

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const AliasType._(this.value);

  /// Returns a [AliasType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static AliasType fromInt(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_ALIAS_TYPE);
  }

  @override
  String toString() {
    return 'AliasType{value: $value}';
  }
}
