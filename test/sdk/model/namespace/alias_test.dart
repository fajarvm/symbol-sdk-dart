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

library symbol_sdk_dart.test.sdk.model.namespace.alias_test;

import 'package:symbol_sdk_dart/src/sdk/model/account/address.dart';
import 'package:symbol_sdk_dart/src/sdk/model/mosaic/mosaic_id.dart';
import 'package:test/test.dart';

import 'package:symbol_sdk_dart/sdk.dart' show Alias, AliasType;

void main() {
  group('Alias', () {
    test('can create an implementation of an Alias', () {
      final alias = new MockAlias();

      expect(alias, isNotNull);
      expect(alias.address, isNull);
      expect(alias.mosaicId, isNull);
      expect(alias.type, equals(AliasType.NONE));
    });
  });
}

class MockAlias implements Alias {
  MockAlias();

  @override
  Address get address => null;

  @override
  MosaicId get mosaicId => null;

  @override
  AliasType get type => AliasType.NONE;
}
