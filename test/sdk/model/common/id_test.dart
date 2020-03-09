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

library symbol_sdk_dart.test.sdk.model.common.id_test;

import 'package:test/test.dart';

import 'package:symbol_sdk_dart/sdk.dart' show Id, MosaicId, NamespaceId, Uint64;

void main() {
  group('Id', () {
    test('Can create an Id object', () {
      final Id id = new MockId(Uint64(9000));

      final expected = Uint64.fromBigInt(BigInt.from(9000));
      expect(id == MockId(expected), isTrue);
      expect(id.id, equals(expected));
      expect(id.id.value, equals(expected.value));
      expect(id.toHex(), equals(expected.toHex()));
    });

    test('Different implementation of Ids are not equals', () {
      final uint64 = Uint64(9000);
      final Id mockId = new MockId(uint64);
      final Id mosaicId = new MosaicId(uint64);
      final Id namespaceId = new NamespaceId(id: uint64);

      expect(mockId == mosaicId, isFalse);
      expect(mockId == namespaceId, isFalse);
      expect(mosaicId == namespaceId, isFalse);
    });

    test('Instances of the same implementation are only equal if the ids are the same', () {
      final uint64 = Uint64(9000);
      final Id mockId1 = new MockId(uint64);
      final Id mockId2 = new MockId(uint64);
      final Id mockId3 = new MockId(Uint64(1000)); // has a different uint64 value

      expect(mockId1 == mockId2, isTrue);
      expect(mockId1 == mockId3, isFalse);
      expect(mockId2 == mockId3, isFalse);
    });
  });
}

class MockId extends Id {
  MockId(Uint64 id) : super(id);
}
