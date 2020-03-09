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

library symbol_sdk_dart.test.sdk.model.namespace.alias_action_type_test;

import 'package:symbol_sdk_dart/sdk.dart' show AliasActionType;
import 'package:test/test.dart';

void main() {
  group('AliasActionType', () {
    test('valid alias action types', () {
      expect(AliasActionType.LINK.value, 0);
      expect(AliasActionType.UNLINK.value, 1);
    });

    test('Can retrieve a valid action alias type', () {
      expect(AliasActionType.fromInt(0), AliasActionType.LINK);
      expect(AliasActionType.fromInt(1), AliasActionType.UNLINK);
    });

    test('Trying to retrieve an invalid alias action type will throw an error', () {
      String errorMessage = AliasActionType.UNKNOWN_ALIAS_ACTION_TYPE;
      expect(() => AliasActionType.fromInt(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => AliasActionType.fromInt(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => AliasActionType.fromInt(2),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });
  });
}
