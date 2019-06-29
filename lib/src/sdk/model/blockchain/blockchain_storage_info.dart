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

library nem2_sdk_dart.sdk.model.blockchain.blockchain_storage_info;

/// The blockchain storage info structure describes stored data.
class BlockchainStorageInfo {
  final int _numAccounts;
  final int _numBlocks;
  final int _numTransactions;

  BlockchainStorageInfo(this._numAccounts, this._numBlocks, this._numTransactions);

  /// The number of accounts published in the blockchain.
  int get numTransactions => _numTransactions;

  /// The number of confirmed blocks.
  int get numBlocks => _numBlocks;

  /// The number of confirmed transactions.
  int get numAccounts => _numAccounts;

}
