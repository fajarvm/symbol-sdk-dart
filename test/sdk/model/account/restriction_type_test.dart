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

library nem2_sdk_dart.test.sdk.model.account.restriction_type_test;

import 'package:nem2_sdk_dart/sdk.dart' show RestrictionType;
import 'package:test/test.dart';

void main() {
  group('RestrictionType', () {
    test('valid restriction types', () {
      // Allow
      expect(RestrictionType.ALLOW_ADDRESS.value, 0x01);
      expect(RestrictionType.ALLOW_MOSAIC.value, 0x02);
      expect(RestrictionType.ALLOW_TRANSACTION.value, 0x04);

      // Sentinel
      expect(RestrictionType.SENTINEL.value, 0x05);

      // Block
      expect(RestrictionType.BLOCK_ADDRESS.value, (0x80 + 0x01));
      expect(RestrictionType.BLOCK_MOSAIC.value, (0x80 + 0x02));
      expect(RestrictionType.BLOCK_TRANSACTION.value, (0x80 + 0x04));
    });

    test('Can retrieve a valid restriction types', () {
      // Account filters
      expect(RestrictionType.getType(0x01), RestrictionType.ALLOW_ADDRESS);
      expect(RestrictionType.getType(0x02), RestrictionType.ALLOW_MOSAIC);
      expect(RestrictionType.getType(0x04), RestrictionType.ALLOW_TRANSACTION);
      expect(RestrictionType.getType(0x05), RestrictionType.SENTINEL);
      expect(RestrictionType.getType(0x80 + 0x01), RestrictionType.BLOCK_ADDRESS);
      expect(RestrictionType.getType(0x80 + 0x02), RestrictionType.BLOCK_MOSAIC);
      expect(RestrictionType.getType(0x80 + 0x04), RestrictionType.BLOCK_TRANSACTION);
    });

    test('Trying to retrieve an unknown property type will throw an error', () {
      String errorMessage = RestrictionType.UNKNOWN_RESTRICTION_TYPE;
      expect(errorMessage, equals('unknown restriction type'));

      expect(() => RestrictionType.getType(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => RestrictionType.getType(0x03),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => RestrictionType.getType(0x80 + 0x03),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });
  });
}
