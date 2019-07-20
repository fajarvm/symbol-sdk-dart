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

library nem2_sdk_dart.sdk.model.blockchain.chain_info;

import '../common/uint64.dart';

/// Chain info.
class ChainInfo {
  /// The number of confirmed blocks.
  final Uint64 numberOfBlocks;

  /// The high score for the blockchain.
  final Uint64 scoreHigh;

  /// The low score for the blockchain.
  final Uint64 scoreLow;

  ChainInfo(this.numberOfBlocks, this.scoreHigh, this.scoreLow);
}
