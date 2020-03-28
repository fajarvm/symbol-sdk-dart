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

library symbol_sdk_dart.test.sdk.model.mosaic.network_currency_local_test;

import 'package:test/test.dart';

import 'package:symbol_sdk_dart/sdk.dart' show NamespaceId, Uint64, NetworkCurrencyLocal;

void main() {
  group('NetworkCurrencyLocal', () {
    test('Can create a NetworkCurrencyLocal object using createRelative()', () {
      final currency = NetworkCurrencyLocal.createRelative(Uint64(1000));

      expect(currency.id.id.toHex(), equals('85bbea6cc462b244'));
      expect(currency.amount, equals(Uint64(1000 * 1000000)));
    });

    test('Can create a NetworkCurrencyLocal object using createAbsolute', () {
      final currency = NetworkCurrencyLocal.createAbsolute(Uint64(1000));

      expect(currency.id.id.toHex(), equals('85bbea6cc462b244'));
      expect(currency.amount, equals(Uint64(1000)));
    });

    test('Should have valid static ids', () {
      final namespaceU64 = Uint64.fromHex('85bbea6cc462b244');
      final namespaceId = new NamespaceId(id: namespaceU64);

      expect(NetworkCurrencyLocal.NAMESPACE_ID, namespaceId);
      expect(NetworkCurrencyLocal.DIVISIBILITY, 6);
      expect(NetworkCurrencyLocal.TRANSFERABLE, isTrue);
      expect(NetworkCurrencyLocal.SUPPLY_MUTABLE, isFalse);
    });
  });
}
