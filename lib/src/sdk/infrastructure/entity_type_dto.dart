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

library nem2_sdk_dart.sdk.infrastructure.entity_type_dto;

import 'dart:typed_data' show Uint8List;

import 'data_stream.dart';

class EntityTypeDTO {
  static const EntityTypeDTO RESERVED = EntityTypeDTO._internal(0);
  static const EntityTypeDTO TRANSFER_TRANSACTION_BUILDER = EntityTypeDTO._internal(16724);

  final int _value;

  const EntityTypeDTO._internal(this._value);

  EntityTypeDTO(this._value);

  int get value => this._value;

  static EntityTypeDTO fromStream(final DataInputStream stream) {
    int value = stream.readInt();
    switch (value) {
      case 0:
        return RESERVED;
      case 16724:
        return TRANSFER_TRANSACTION_BUILDER;
      default:
        throw Exception('Unknown enum value: $value');
    }
  }

  Uint8List serialize() {
    DataOutputStream dataOutputStream = new DataOutputStream();
    dataOutputStream.writeInt(_value);
    return dataOutputStream.bytes;
  }
}
