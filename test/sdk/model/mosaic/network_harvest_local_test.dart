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

library symbol_sdk_dart.test.sdk.model.mosaic.network_harvest_local_test;

import 'package:test/test.dart';

import 'package:symbol_sdk_dart/sdk.dart' show NamespaceId, Uint64, NetworkHarvestLocal;

void main() {
  group('NetworkHarvestLocal', () {
    test('Can create a NetworkHarvestLocal object using createRelative()', () {
      final currency = NetworkHarvestLocal.createRelative(Uint64(1000));

      expect(currency.id.id.toHex(), equals('941299b2b7e1291c'));
      expect(currency.amount, equals(Uint64(1000 * 1000)));
    });

    test('Can create a NetworkHarvestLocal object using createAbsolute', () {
      final currency = NetworkHarvestLocal.createAbsolute(Uint64(1000));

      expect(currency.id.id.toHex(), equals('941299b2b7e1291c'));
      expect(currency.amount, equals(Uint64(1000)));
    });

    test('Should have valid static ids', () {
      final namespaceU64 = Uint64.fromHex('941299b2b7e1291c');
      final namespaceId = new NamespaceId(id: namespaceU64);

      expect(NetworkHarvestLocal.NAMESPACE_ID, namespaceId);
      expect(NetworkHarvestLocal.DIVISIBILITY, 3);
      expect(NetworkHarvestLocal.TRANSFERABLE, isTrue);
      expect(NetworkHarvestLocal.SUPPLY_MUTABLE, isTrue);
    });
  });
}
