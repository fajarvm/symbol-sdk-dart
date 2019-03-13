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
///
/// Supported types are:
/// * 0x01: Add property value.
/// * 0x02: Delete property value.
class PropertyModificationType {
  static const String _INVALID_PROPERTY_MODIFICATION_TYPE = 'invalid property modification type';

  static final PropertyModificationType _singleton = new PropertyModificationType._();

  PropertyModificationType._();

  factory PropertyModificationType() {
    return _singleton;
  }

  static const int ADD = 0;

  static const int DEL = 1;

  static int getType(final int propertyModificationType) {
    switch (propertyModificationType) {
      case ADD:
        return PropertyModificationType.ADD;
      case DEL:
        return PropertyModificationType.DEL;
      default:
        throw new ArgumentError(_INVALID_PROPERTY_MODIFICATION_TYPE);
    }
  }
}
