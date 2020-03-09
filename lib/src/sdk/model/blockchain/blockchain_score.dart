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

library symbol_sdk_dart.sdk.model.blockchain.blockchain_score;

import '../common/uint64.dart';

/// The blockchain score structure describes blockchain difficulty.
class BlockchainScore {
  /// The low part of the blockchain score.
  final Uint64 scoreLow;

  /// The high part of the blockchain score.
  final Uint64 scoreHigh;

  BlockchainScore(this.scoreLow, this.scoreHigh);

  @override
  String toString() {
    return 'BlockchainScore{scoreLow: $scoreLow, scoreHigh: $scoreHigh}';
  }
}
