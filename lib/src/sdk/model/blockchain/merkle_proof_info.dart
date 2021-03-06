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

library symbol_sdk_dart.sdk.model.blockchain.merkle_proof_info;

import 'merkle_path_item.dart';

/// The block merkle proof info.
class MerkleProofInfo {
  /// A list of [MerklePathItem].
  final List<MerklePathItem> merklePath;

  MerkleProofInfo(this.merklePath);

  @override
  String toString() {
    return 'MerkleProofInfo{merklePath: $merklePath}';
  }
}
