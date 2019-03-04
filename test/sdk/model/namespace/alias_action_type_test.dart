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

library nem2_sdk_dart.test.sdk.model.namespace.alias_action_type_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show AliasActionType;

void main() {
  group('AliasActionType', () {
    test('creating a new instance returns a singleton', () {
      final type1 = new AliasActionType();
      final type2 = new AliasActionType();

      expect(identical(type1, type2), isTrue);
    });

    test('valid alias action types', () {
      expect(AliasActionType.LINK, 0);
      expect(AliasActionType.UNLINK, 1);
    });

    test('Can retrieve a valid action alias types', () {
      expect(AliasActionType.getAliasActionType(0), AliasActionType.LINK);
      expect(AliasActionType.getAliasActionType(1), AliasActionType.UNLINK);
    });

    test('Trying to retrieve an invalid alias action type will throw an error', () {
      expect(
          () => AliasActionType.getAliasActionType(null),
          throwsA(
              predicate((e) => e is ArgumentError && e.message == 'invalid alias action type')));
      expect(
          () => AliasActionType.getAliasActionType(-1),
          throwsA(
              predicate((e) => e is ArgumentError && e.message == 'invalid alias action type')));
      expect(
          () => AliasActionType.getAliasActionType(2),
          throwsA(
              predicate((e) => e is ArgumentError && e.message == 'invalid alias action type')));
    });
  });
}
