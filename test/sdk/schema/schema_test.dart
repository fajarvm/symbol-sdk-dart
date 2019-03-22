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

library nem2_sdk_dart.test.sdk.schema.schema_test;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/core.dart' show ArrayUtils;
import 'package:nem2_sdk_dart/sdk.dart' show Schema, SchemaAttribute;
import 'package:test/test.dart';

void main() {
  group('Schema', () {
    test('should copy the serialized object into the result', () {
      final schema = new Schema([new MockSchemaAttribute('attribute1')]);
      final result = schema.serialize(Uint8List.fromList([4, 5, 6]));

      final expected = Uint8List.fromList([1, 2, 3]);
      expect(ArrayUtils.deepEqual(result, expected), isTrue);
    });

    test('should concat the different serialized objects into the result', () {
      final schema = new Schema(
          [new MockSchemaAttribute('attribute1'), new MockSchemaAttribute('attribute2')]);

      final result = schema.serialize(Uint8List.fromList([4, 5, 6]));

      final expected = Uint8List.fromList([1, 2, 3, 1, 2, 3]);
      expect(ArrayUtils.deepEqual(result, expected), isTrue);
    });
  });
}

class MockSchemaAttribute extends SchemaAttribute {
  MockSchemaAttribute(final String name) : super(name);

  @override
  Uint8List serialize(final Uint8List buffer, final int position, [final int innerObjectPosition]) {
    return Uint8List.fromList([1, 2, 3]);
  }
}
