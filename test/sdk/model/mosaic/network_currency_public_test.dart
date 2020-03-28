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

library symbol_sdk_dart.test.sdk.model.mosaic.network_currency_public_test;

import 'package:test/test.dart';

import 'package:symbol_sdk_dart/sdk.dart' show NamespaceId, Uint64, NetworkCurrencyPublic;

void main() {
  group('NetworkCurrencyPublic', () {
    test('Can create a NetworkCurrencyPublic object using createRelative()', () {
      final currency = NetworkCurrencyPublic.createRelative(Uint64(1000));

      expect(currency.id.id.toHex(), equals('e74b99ba41f4afee'));
      expect(currency.amount, equals(Uint64(1000 * 1000000)));
    });

    test('Can create a NetworkCurrencyPublic object using createAbsolute', () {
      final currency = NetworkCurrencyPublic.createAbsolute(Uint64(1000));

      expect(currency.id.id.toHex(), equals('e74b99ba41f4afee'));
      expect(currency.amount, equals(Uint64(1000)));
    });

    test('Should have valid static ids', () {
      final namespaceU64 = Uint64.fromHex('e74b99ba41f4afee');
      final namespaceId = new NamespaceId(id: namespaceU64);

      expect(NetworkCurrencyPublic.NAMESPACE_ID, namespaceId);
      expect(NetworkCurrencyPublic.DIVISIBILITY, 6);
      expect(NetworkCurrencyPublic.TRANSFERABLE, isTrue);
      expect(NetworkCurrencyPublic.SUPPLY_MUTABLE, isFalse);
    });
  });
}
