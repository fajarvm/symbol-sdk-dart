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

library symbol_sdk_dart.test.sdk.model.blockchain.merkle_proof_info_test;

import 'package:symbol_sdk_dart/sdk.dart' show MerklePathItem, MerkleProofInfo;
import 'package:test/test.dart';

void main() {
  group('MerkleProofInfo', () {
    test('Can create MerkleProofInfo object', () {
      const hash1 = '702090BA31CEF9E90C62BBDECC0CCCC0F88192B6625839382850357F70DD68A0';
      const hash2 = 'B4F12E7C9F6946091E2CB8B6D3A12B50D17CCBBF646386EA27CE2946A7423DCF';
      const hash3 = '57F7DA205008026C776CB6AED843393F04CD458E0AA2D9F1D5F31A402072B2D6';
      final merklePathItem1 = new MerklePathItem(1, hash1);
      final merklePathItem2 = new MerklePathItem(2, hash2);
      final merklePathItem3 = new MerklePathItem(3, hash3);
      final merklePaths = [merklePathItem1, merklePathItem2, merklePathItem3];
      final merkleProofInfo = new MerkleProofInfo(merklePaths);
      expect(merkleProofInfo.merklePath.length, equals(3));
      expect(merkleProofInfo.toString(), equals('MerkleProofInfo{merklePath: $merklePaths}'));
    });
  });
}
