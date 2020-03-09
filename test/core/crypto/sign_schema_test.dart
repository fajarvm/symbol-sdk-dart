//
// Copyright (c) 2020 Fajar van Megen
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

library symbol_sdk_dart.test.core.crypto.sign_schema_test;

import 'package:symbol_sdk_dart/core.dart' show SignSchema;
import 'package:test/test.dart';

void main() {
  group('SignSchema', () {
    test('valid sign schemas', () {
      expect(SignSchema.KECCAK.value, 1);
      expect(SignSchema.SHA3.value, 2);
    });

    test('Can retrieve valid sign schema', () {
      expect(SignSchema.fromInt(1), SignSchema.KECCAK);
      expect(SignSchema.fromInt(2), SignSchema.SHA3);
    });

    test('Can validate sign schema and hash size combination', () {
      // valid combinations
      expect(SignSchema.isValid(SignSchema.SHA3, SignSchema.HASH_SIZE_32_BYTES), true);
      expect(SignSchema.isValid(SignSchema.SHA3, SignSchema.HASH_SIZE_64_BYTES), true);
      expect(SignSchema.isValid(SignSchema.KECCAK, SignSchema.HASH_SIZE_32_BYTES), true);
      expect(SignSchema.isValid(SignSchema.KECCAK, SignSchema.HASH_SIZE_64_BYTES), true);

      // invalid combinations
      expect(SignSchema.isValid(SignSchema.SHA3, 31), false);
      expect(SignSchema.isValid(SignSchema.SHA3, 61), false);
      expect(SignSchema.isValid(SignSchema.KECCAK, 31), false);
      expect(SignSchema.isValid(SignSchema.KECCAK, 61), false);
    });

    test('Trying to retrieve an invalid sign schema will throw an error', () {
      String errorMessage = SignSchema.UNSUPPORTED_SIGN_SCHEMA;
      expect(() => SignSchema.fromInt(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => SignSchema.fromInt(0),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => SignSchema.fromInt(3),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });
  });
}
