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

library symbol_sdk_dart.test.sdk.model.namespace.empty_alias_test;

import 'package:test/test.dart';

import 'package:symbol_sdk_dart/sdk.dart' show EmptyAlias, AliasType;

void main() {
  group('EmptyAlias', () {
    test('Can create EmptyAlias object', () {
      final alias = new EmptyAlias();

      expect(alias.type, equals(AliasType.NONE));
      expect(alias.address, isNull);
      expect(alias.mosaicId, isNull);
      expect(alias.hashCode, isNotNull);
    });

    test('Can compare adresses in EmptyAlias', () {
      final alias1 = new EmptyAlias();
      final alias2 = new EmptyAlias();

      expect((alias1 == alias2), isTrue);
    });
  });
}
