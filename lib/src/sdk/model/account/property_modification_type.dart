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

library nem2_sdk_dart.sdk.model.account.property_modification_type;

/// The type of modification to a property type.
class PropertyModificationType {
  static const String UNKNOWN_PROPERTY_MODIFICATION_TYPE = 'unknown property modification type';

  /// Addition.
  static const PropertyModificationType ADD = PropertyModificationType._(0x00);

  /// Deletion.
  static const PropertyModificationType DEL = PropertyModificationType._(0x01);

  static final List<PropertyModificationType> values = <PropertyModificationType>[ADD, DEL];

  final int _value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const PropertyModificationType._(this._value);

  /// The int value of this type.
  int get value => _value;

  /// Returns a [PropertyModificationType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static PropertyModificationType getType(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_PROPERTY_MODIFICATION_TYPE);
  }
}
