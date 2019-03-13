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

library nem2_sdk_dart.sdk.model.account.property_type;

/// The property type of an account.
///
/// Supported types are:
/// * 0x01: The property type is an address.
/// * 0x02: The property type is mosaic id.
/// * 0x04: The property type is a transaction type.
/// * 0x05: Property type sentinel.
/// * 0x80 + type:	The property is interpreted as a blocking operation.
class PropertyType {
  static const String _INVALID_PROPERTY_TYPE = 'invalid property type';

  static final PropertyType _singleton = new PropertyType._();

  PropertyType._();

  factory PropertyType() {
    return _singleton;
  }

  static const int ALLOW_ADDRESS = 0x01;

  static const int ALLOW_MOSAIC = 0x02;

  static const int ALLOW_TRANSACTION = 0x04;

  static const int SENTINEL = 0x05;

  static const int BLOCK_ADDRESS = (0x80 + ALLOW_ADDRESS);

  static const int BLOCK_MOSAIC = (0x80 + ALLOW_MOSAIC);

  static const int BLOCK_TRANSACTION = (0x80 + ALLOW_TRANSACTION);

  static int getType(final int propertyType) {
    switch (propertyType) {
      case ALLOW_ADDRESS:
        return PropertyType.ALLOW_ADDRESS;
      case ALLOW_MOSAIC:
        return PropertyType.ALLOW_MOSAIC;
      case ALLOW_TRANSACTION:
        return PropertyType.ALLOW_TRANSACTION;
      case SENTINEL:
        return PropertyType.SENTINEL;
      case BLOCK_ADDRESS:
        return PropertyType.BLOCK_ADDRESS;
      case BLOCK_MOSAIC:
        return PropertyType.BLOCK_MOSAIC;
      case BLOCK_TRANSACTION:
        return PropertyType.BLOCK_TRANSACTION;
      default:
        throw new ArgumentError(_INVALID_PROPERTY_TYPE);
    }
  }
}
