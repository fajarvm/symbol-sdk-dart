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

library symbol_sdk_dart.test.sdk.model.mosaic.mosaic_names_test;

import 'package:symbol_sdk_dart/sdk.dart'
    show MosaicId, MosaicNames, NamespaceId, NamespaceName, Uint64;

import 'package:test/test.dart';

void main() {
  group('MosaicNames', () {
    test('Can create a MosaicNames object', () {
      final mosaicId = MosaicId.fromId(Uint64.fromHex('D525AD41D95FCF29'));
      final name1 = new NamespaceName(NamespaceId.fromFullName('alias1'), 'alias1');
      final name2 = new NamespaceName(NamespaceId.fromFullName('alias2'), 'alias2');
      final names = [name1, name2];

      final mosaicNames = MosaicNames(mosaicId, names);

      expect(mosaicNames.mosaicId, equals(mosaicId));
      expect(mosaicNames.names[0].name, equals('alias1'));
      expect(mosaicNames.names[1].name, equals('alias2'));

      final toString = 'MosaicNames{mosaicId: $mosaicId, names: $names}';
      expect(mosaicNames.toString(), equals(toString));
    });
  });
}
