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

library symbol_sdk_dart.test.sdk.model.namespace.address_alias_test;

import 'package:test/test.dart';

import 'package:symbol_sdk_dart/sdk.dart' show Address, AddressAlias, AliasType;

void main() {
  final Address address = Address.fromRawAddress('SCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPRLIKCF2');
  final Address address2 = Address.fromRawAddress('SARNASAS2BIAB6LMFA3FPMGBPGIJGK6IJETM3ZSP');

  group('AddressAlias', () {
    test('Can create AddressAlias object', () {
      final alias = new AddressAlias(address);

      expect(alias.type, equals(AliasType.ADDRESS));
      expect(alias.address, equals(address));
      expect(alias.mosaicId, isNull);
      expect(alias.hashCode, isNotNull);
    });

    test('Can compare AddressAliases', () {
      final alias1 = new AddressAlias(address);
      final alias2 = new AddressAlias(address);
      final alias3 = new AddressAlias(address2);

      expect((alias1 == alias2), isTrue);
      expect((alias1 == alias3), isFalse);
    });
  });
}
