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

library symbol_sdk_dart.test.sdk.model.namespace.alias_action_test;

import 'package:symbol_sdk_dart/sdk.dart' show AliasAction;
import 'package:test/test.dart';

void main() {
  group('AliasAction', () {
    test('valid alias action', () {
      expect(AliasAction.LINK.value, 0);
      expect(AliasAction.UNLINK.value, 1);
    });

    test('Can retrieve a valid action alias', () {
      expect(AliasAction.fromInt(0), AliasAction.LINK);
      expect(AliasAction.fromInt(1), AliasAction.UNLINK);
    });

    test('Trying to retrieve an invalid alias action will throw an error', () {
      String errorMessage = AliasAction.UNKNOWN_ALIAS_ACTION;
      expect(() => AliasAction.fromInt(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => AliasAction.fromInt(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => AliasAction.fromInt(2),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });
  });
}
