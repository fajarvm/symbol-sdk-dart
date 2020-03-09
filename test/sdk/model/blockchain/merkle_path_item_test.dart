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

library symbol_sdk_dart.test.sdk.model.blockchain.merkle_path_item_test;

import 'package:symbol_sdk_dart/sdk.dart' show MerklePathItem;
import 'package:test/test.dart';

void main() {
  group('MerklePathItem', () {
    test('Can create MerklePathItem object', () {
      const position = 1337;
      const hash = '702090BA31CEF9E90C62BBDECC0CCCC0F88192B6625839382850357F70DD68A0';
      final merklePathItem = new MerklePathItem(position, hash);
      expect(merklePathItem.position, equals(position));
      expect(merklePathItem.hash, equals(hash));
      expect(merklePathItem.toString(), equals('MerklePathItem{position: $position, hash: $hash}'));
    });
  });
}
