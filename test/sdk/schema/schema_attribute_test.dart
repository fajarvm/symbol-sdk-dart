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

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show SchemaAttribute;

void main() {
  group('SchemaAttribute', () {
    test('default serialize() implemententation throws an unsupported error', () {
      final schema = new MockSchemaAttribute();

      expect(schema.name, equals('MockSchemaAttribute'));

      expect(() => schema.serialize(null, 0),
          throwsA(predicate((e) => e is UnsupportedError && e.message == 'Unimplemented method')));
    });

    // TODO: complete unit test
  });
}

class MockSchemaAttribute extends SchemaAttribute {
  MockSchemaAttribute() : super('MockSchemaAttribute');
}
