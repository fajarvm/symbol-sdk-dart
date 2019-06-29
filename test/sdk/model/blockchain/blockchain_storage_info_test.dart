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

library nem2_sdk_dart.test.sdk.model.blockchain.blockchain_storage_info_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show BlockchainStorageInfo;

void main() {
  group('BlockchainStorageInfo', () {
    test('Can create a BlockchainStorageInfo object', () {
      final blockchainStorageInfo = BlockchainStorageInfo(1, 2, 3);

      expect(blockchainStorageInfo.numAccounts, 1);
      expect(blockchainStorageInfo.numBlocks, 2);
      expect(blockchainStorageInfo.numTransactions, 3);
    });
  });
}
