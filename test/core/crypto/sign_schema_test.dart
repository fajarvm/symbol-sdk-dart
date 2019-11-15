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

library nem2_sdk_dart.test.core.crypto.sign_schema_test;

import 'package:nem2_sdk_dart/core.dart' show SignSchema;
import 'package:test/test.dart';

void main() {
  group('SignSchema', () {
    test('valid sign schemas', () {
      expect(SignSchema.SHA3.value, 1);
      expect(SignSchema.KECCAK.value, 2);
    });

    test('Can retrieve valid sign schema', () {
      expect(SignSchema.fromInt(1), SignSchema.SHA3);
      expect(SignSchema.fromInt(2), SignSchema.KECCAK);
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
