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

library nem2_sdk_dart.test.sdk.schema.schema_attribute_test;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/core.dart' show ArrayUtils;
import 'package:test/test.dart';

import 'schema_test.dart' show MockSchemaAttribute;

void main() {
  group('SchemaAttribute', () {
    test('serialize()', () {
      final schemaAttribute = new MockSchemaAttribute('test');
      final result = schemaAttribute.serialize(null, 0);
      final expected = Uint8List.fromList([1, 2, 3]);

      expect(ArrayUtils.deepEqual(result, expected), isTrue);
    });

    test('readInt32()', () {
      // TODO: complete unit test
    });
  });
}
