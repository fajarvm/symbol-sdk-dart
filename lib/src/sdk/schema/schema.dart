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

library nem2_sdk_dart.sdk.model.schema.schema;

import 'dart:typed_data' show Uint8List;

import 'schema_attribute.dart';

/// Defines a Schema object.
class Schema {
  /// A list of schema attributes.
  final List<SchemaAttribute> schemaDefinition;

  Schema(this.schemaDefinition);

  /// Creates a catapult bytes buffer of the given catbuffers [bytes].
  Uint8List serialize(final Uint8List bytes) {
    List<int> result = <int>[];
    for (int i = 0; i < schemaDefinition.length; i++) {
      Uint8List temp = schemaDefinition[i].serialize(bytes, 4 + (i * 2));
      result = concat(Uint8List.fromList(result), temp);
    }
    return Uint8List.fromList(result);
  }

  /// Concatenates two bytes together into a new bytes.
  static Uint8List concat(final Uint8List first, final Uint8List second) {
    final List<int> result = <int>[];
    result.addAll(first.toList());
    result.addAll(second.toList());
    return Uint8List.fromList(result);
  }
}
