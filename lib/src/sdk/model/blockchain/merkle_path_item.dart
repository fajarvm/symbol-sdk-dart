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

library symbol_sdk_dart.sdk.model.blockchain.merkle_path_item;

/// The block merkle path item.
class MerklePathItem {
  /// The position.
  final int position;

  /// The hash.
  final String hash;

  MerklePathItem(this.position, this.hash);

  @override
  String toString() {
    return 'MerklePathItem{position: $position, hash: $hash}';
  }
}
