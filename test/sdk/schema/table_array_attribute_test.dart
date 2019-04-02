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

library nem2_sdk_dart.test.sdk.schema.table_array_ttribute_test;

import 'dart:typed_data' show Uint8List;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show TableArrayAttribute;

import 'schema_test.dart' show MockSchemaAttribute;

void main() {
  group('TableArrayAttribute', () {
    final Uint8List buffer = Uint8List.fromList([
      32, 0, 0, 0, 28, 0, 44, 0, 40, 0, 36, 0, 32, 0, 30, 0, 28, 0, 24, 0, 20, 0, 16, 0, 12, 0, 15,
      0, 8, 0, 4, 0, 28, 0, 0, 0, 200, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 28, 0, 0, 0, 68, 0, 0, 0,
      52, 0, 0, 0, 1, 65, 3, 144, 68, 0, 0, 0, 100, 0, 0, 0, 166, 0, 0, 0, 25, 0, 0, 0, 144, 232,
      254, 189, 103, 29, 212, 27, 238, 148, 236, 59, 165, 131, 28, 182, 8, 163, 18, 194, 242, 3,
      186, 132, 172, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 69, 164, 14, 203, 10,
      0, 0, 0, 32, 0, 0, 0, 154, 73, 54, 100, 6, 172, 169, 82, 184, 139, 173, 245, 241, 233, 190,
      108, 228, 150, 129, 65, 3, 90, 96, 190, 80, 50, 115, 234, 101, 69, 107, 36, 64, 0, 0, 0, 38,
      167, 193, 210, 7, 30, 251, 149, 236, 15, 91, 233, 73, 174, 79, 86, 20, 133, 161, 167, 112,
      102, 42, 244, 246, 239, 78, 29, 104, 150, 190, 48, 230, 111, 129, 164, 66, 29, 244, 75, 46,
      150, 68, 242, 76, 26, 69, 205, 205, 122, 253, 219, 142, 171, 28, 217, 139, 28, 133, 247, 59,
      100, 161, 14, 1, 0, 0, 0, 12, 0, 0, 0, 8, 0, 12, 0, 8, 0, 4, 0, 8, 0, 0, 0, 8, 0, 0, 0, 16,
      0, 0, 0, 2, 0, 0, 0, 128, 150, 152, 0, 0, 0, 0, 0, 2, 0, 0, 0, 41, 207, 95, 217, 65, 173,
      37, 213, 8, 0, 8, 0, 0, 0, 4, 0, 8, 0, 0, 0, 4, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0]);

    test('serialize()', () {
      final attribute1 = new MockSchemaAttribute('attribute1');
      final attribute2 = new MockSchemaAttribute('attribute2');
      final tableArrayAttribute = new TableArrayAttribute('test', [attribute1, attribute2]);
      final actual = tableArrayAttribute.serialize(buffer, 18, 32);

      expect(tableArrayAttribute.name, equals('test'));
      expect(actual[0], equals(1));
    });
  });
}