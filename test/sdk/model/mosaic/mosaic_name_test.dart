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

library nem2_sdk_dart.test.sdk.model.mosaic.mosaic_name_test;

import 'package:nem2_sdk_dart/sdk.dart' show MosaicId, MosaicName, NamespaceId, Uint64;
import 'package:test/test.dart';

void main() {
  group('MosaicName', () {
    test('Can create a MosaicName object', () {
      final namespaceId = NamespaceId.fromId(Uint64.fromHex('84B3552D375FFA4B'));
      final mosaicId = MosaicId.fromId(Uint64.fromHex('D525AD41D95FCF29'));
      final mosaicName = new MosaicName(mosaicId, 'xem', namespaceId);

      expect(mosaicName.mosaicId, equals(mosaicId));
      expect(mosaicName.name, equals('xem'));
      expect(mosaicName.parentId, equals(namespaceId));
    });
  });
}
