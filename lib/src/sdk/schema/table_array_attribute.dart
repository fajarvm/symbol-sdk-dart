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

library nem2_sdk_dart.sdk.model.schema.table_array_attribute;

import 'dart:typed_data' show Uint8List;

import 'schema_attribute.dart';

class TableArrayAttribute extends SchemaAttribute {
  final List<SchemaAttribute> schema;

  TableArrayAttribute(final String name, this.schema) : super(name);

  @override
  Uint8List serialize(final Uint8List buffer, final int position, [final int innerObjectPosition]) {
    List<int> result = [];
    int arrayLength = findArrayLength(innerObjectPosition, position, buffer);

    for (int i = 0; i < arrayLength; i++) {
      int startArrayPosition = findObjectStartPosition(innerObjectPosition, position, buffer);
      for (int j = 0; j < this.schema.length; j++) {
        Uint8List temp = schema[j].serialize(buffer, 4 + (j * 2), startArrayPosition);
        result.addAll(temp.toList());
      }
    }

    return Uint8List.fromList(result);
  }
}
