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

library symbol_sdk_dart.test.sdk.model.blockchain.blockchain_score_test;

import 'package:symbol_sdk_dart/sdk.dart' show BlockchainScore, Uint64;
import 'package:test/test.dart';

void main() {
  group('BlockchainScore', () {
    test('Can create a BlockchainScore object', () {
      final blockchainScore = new BlockchainScore(Uint64(1000), Uint64(9999));

      expect(blockchainScore.scoreLow.value, BigInt.from(1000));
      expect(blockchainScore.scoreHigh.value, BigInt.from(9999));

      expect(
          blockchainScore.toString(),
          equals('BlockchainScore{scoreLow: ${blockchainScore.scoreLow.value}, '
              'scoreHigh: ${blockchainScore.scoreHigh.value}}'));
    });
  });
}
