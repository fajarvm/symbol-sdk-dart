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

library nem2_sdk_dart.test.sdk.model.node.role_type_test;

import 'package:nem2_sdk_dart/sdk.dart' show RoleType;
import 'package:test/test.dart';

void main() {
  group('RoleType', () {
    test('Valid role types', () {
      expect(RoleType.PEER_NODE.value, 1);
      expect(RoleType.API_NODE.value, 2);
    });

    test('Can retrieve a valid role type', () {
      expect(RoleType.fromInt(1), RoleType.PEER_NODE);
      expect(RoleType.fromInt(2), RoleType.API_NODE);
    });

    test('invalid or unknown type should throw an error', () {
      String errorMessage = RoleType.UNKNOWN_ROLE_TYPE;
      expect(() => RoleType.fromInt(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => RoleType.fromInt(0),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => RoleType.fromInt(3),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });
  });
}
