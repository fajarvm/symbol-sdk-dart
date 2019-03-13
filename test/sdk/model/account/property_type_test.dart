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

library nem2_sdk_dart.test.sdk.model.account.property_type_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show PropertyType;

void main() {
  group('PropertyType', () {
    test('creating a new instance returns a singleton', () {
      final type1 = new PropertyType();
      final type2 = new PropertyType();

      expect(identical(type1, type2), isTrue);
    });

    test('valid transaction types', () {
      // Allow
      expect(PropertyType.ALLOW_ADDRESS, 0x01);
      expect(PropertyType.ALLOW_MOSAIC, 0x02);
      expect(PropertyType.ALLOW_TRANSACTION, 0x04);

      // Sentinel
      expect(PropertyType.SENTINEL, 0x05);

      // Block
      expect(PropertyType.BLOCK_ADDRESS, (0x80 + 0x01));
      expect(PropertyType.BLOCK_MOSAIC, (0x80 + 0x02));
      expect(PropertyType.BLOCK_TRANSACTION, (0x80 + 0x04));
    });

    test('Can retrieve a valid transaction types', () {
      // Account filters
      expect(PropertyType.getType(0x01), PropertyType.ALLOW_ADDRESS);
      expect(PropertyType.getType(0x02), PropertyType.ALLOW_MOSAIC);
      expect(PropertyType.getType(0x04), PropertyType.ALLOW_TRANSACTION);
      expect(PropertyType.getType(0x05), PropertyType.SENTINEL);
      expect(PropertyType.getType(0x80 + 0x01), PropertyType.BLOCK_ADDRESS);
      expect(PropertyType.getType(0x80 + 0x02), PropertyType.BLOCK_MOSAIC);
      expect(PropertyType.getType(0x80 + 0x04), PropertyType.BLOCK_TRANSACTION);
    });

    test('Trying to retrieve an invalid property type will throw an error', () {
      expect(() => PropertyType.getType(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'invalid property type')));
      expect(() => PropertyType.getType(0x03),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'invalid property type')));
      expect(() => PropertyType.getType(0x80 + 0x03),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'invalid property type')));
    });
  });
}
