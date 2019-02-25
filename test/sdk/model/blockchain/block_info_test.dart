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

library nem2_sdk_dart.test.sdk.model.blockchain.bloc_info_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show Uint64;
import 'package:nem2_sdk_dart/sdk.dart' show BlockInfo, PublicAccount, NetworkType;

void main() {
  group('BlockInfo', () {
    final testBlock = {
      'block': {
        'blockTransactionsHash': '702090BA31CEF9E90C62BBDECC0CCCC0F88192B6625839382850357F70DD68A0',
        'difficulty': Uint64(0x23283276447232),
        'height': Uint64(1),
        'previousBlockHash': '0000000000000000000000000000000000000000000000000000000000000000',
        'signature': '37351C8244AC166BE6664E3FA954E99A3239AC46E51E2B32CEA1C72DD0851100A7731868',
        'signer': 'B4F12E7C9F6946091E2CB8B6D3A12B50D17CCBBF646386EA27CE2946A7423DCF',
        'timestamp': Uint64(0),
        'type': 32768,
        'version': 36867
      },
      'meta': {
        'generationHash': '57F7DA205008026C776CB6AED843393F04CD458E0AA2D9F1D5F31A402072B2D6',
        'hash': '24E92B511B54EDB48A4850F9B42485FDD1A30589D92C775632DDDD71D7D1D691',
        'numTransactions': 25,
        'totalFee': Uint64(0)
      }
    };

    test('Can create a BlockInfo object', () {
      // Prepare
      final int blockVersion = testBlock['block']['version'];
      final String blockVersionHex = blockVersion.toRadixString(16);
      final String networkPart = blockVersionHex.substring(0, 2);
      final String versionPart = blockVersionHex.substring(2, 4);
      final int networkType = int.parse(networkPart, radix: 16);
      final int version = int.parse(versionPart, radix: 16);
      final signer = PublicAccount.fromPublicKey(testBlock['block']['signer'], networkType);

      // Create new Block info
      final blockInfo = new BlockInfo(
          testBlock['meta']['hash'],
          testBlock['meta']['generationHash'],
          testBlock['meta']['totalFee'],
          testBlock['meta']['numTransactions'],
          testBlock['block']['signature'],
          signer,
          networkType,
          version,
          testBlock['block']['type'],
          testBlock['block']['height'],
          testBlock['block']['timestamp'],
          testBlock['block']['difficulty'],
          testBlock['block']['previousBlockHash'],
          testBlock['block']['blockTransactionsHash']);

      // Assert
      expect(blockInfo.hash, equals(testBlock['meta']['hash']));
      expect(blockInfo.generationHash, equals(testBlock['meta']['generationHash']));
      expect(blockInfo.totalFee, equals(testBlock['meta']['totalFee']));
      expect(blockInfo.numTransactions, equals(testBlock['meta']['numTransactions']));
      expect(blockInfo.signature, equals(testBlock['block']['signature']));
      expect(blockInfo.signer.publicKey, equals(testBlock['block']['signer']));
      expect(blockInfo.networkType, equals(networkType));
      expect(blockInfo.networkType, equals(NetworkType.MIJIN_TEST));
      expect(blockInfo.version, equals(version));
      expect(blockInfo.type, equals(testBlock['block']['type']));
      expect(blockInfo.height, equals(testBlock['block']['height']));
      expect(blockInfo.timestamp, equals(testBlock['block']['timestamp']));
      expect(blockInfo.difficulty, equals(testBlock['block']['difficulty']));
      expect(blockInfo.previousBlockHash, equals(testBlock['block']['previousBlockHash']));
      expect(blockInfo.blockTransactionHash, equals(testBlock['block']['blockTransactionsHash']));
    });
  });
}
