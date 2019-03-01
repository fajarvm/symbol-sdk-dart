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

library nem2_sdk_dart.test.sdk.model.mosaic.network_currency_mosaic_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show MosaicId, NamespaceId, Uint64, NetworkCurrencyMosaic;

void main() {
  group('NetworkCurrencyMosaic', () {
    test('Can create a NetworkCurrencyMosaic object using createRelative()', () {
      final currency = NetworkCurrencyMosaic.createRelative(Uint64(1000));

      expect(currency.id.id.toHexString(), equals('0dc67fbe1cad29e3'));
      expect(currency.amount, equals(Uint64(1000 * 1000000)));
    });

    test('Can create a NetworkCurrencyMosaic object using createAbsolute', () {
      final currency = NetworkCurrencyMosaic.createAbsolute(Uint64(1000));

      expect(currency.id.id.toHexString(), equals('0dc67fbe1cad29e3'));
      expect(currency.amount, equals(Uint64(1000)));
    });

    test('Should have valid static ids', () {
      final namespaceU64 = Uint64.fromHex('85bbea6cc462b244');
      final namespaceId = new NamespaceId(id: namespaceU64);
      final mosaicU64 = Uint64.fromHex('0dc67fbe1cad29e3');
      final mosaicId = new MosaicId(id: mosaicU64);

      expect(NetworkCurrencyMosaic.NAMESPACE_ID, namespaceId);
      expect(NetworkCurrencyMosaic.MOSAIC_ID, mosaicId);
      expect(NetworkCurrencyMosaic.DIVISIBILITY, 6);
      expect(NetworkCurrencyMosaic.TRANSFERABLE, isTrue);
      expect(NetworkCurrencyMosaic.SUPPLY_MUTABLE, isFalse);
      expect(NetworkCurrencyMosaic.LEVY_MUTABLE, isFalse);
    });
  });
}
