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

library nem2_sdk_dart.test.sdk.model.mosaic.xem_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show Uint64;
import 'package:nem2_sdk_dart/sdk.dart' show MosaicId, NamespaceId, XEM;

void main() {
  group('XEM', () {
    test('Can create a XEM object using createRelative()', () {
      final xem = XEM.createRelative(Uint64(1000));

      expect(xem.id.id.toHexString(), equals('d525ad41d95fcf29'));
      expect(xem.amount, equals(Uint64(1000 * 1000000)));
    });

    test('Can create a XEM object using createAbsolute', () {
      final xem = XEM.createAbsolute(Uint64(1000));

      expect(xem.id.id.toHexString(), equals('d525ad41d95fcf29'));
      expect(xem.amount, equals(Uint64(1000)));
    });

    test('Should have valid static ids', () {
      final NEM_ID = Uint64.fromHex('84B3552D375FFA4B');
      final namespaceId = new NamespaceId(id: NEM_ID);
      final XEM_ID = Uint64.fromHex('D525AD41D95FCF29');
      final mosaicId = new MosaicId(id: XEM_ID);

      expect(XEM.NAMESPACE_ID, namespaceId);
      expect(XEM.MOSAIC_ID, mosaicId);
    });
  });
}
