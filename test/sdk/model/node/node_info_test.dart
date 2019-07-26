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

library nem2_sdk_dart.test.sdk.model.node.node_info_test;

import 'package:nem2_sdk_dart/sdk.dart' show Account, NetworkType, NodeInfo, RoleType;
import 'package:test/test.dart';

void main() {
  group('NodeInfo', () {
    test('Can create a new NodeInfo object', () {
      String privateKey = '787225aaff3d2c71f4ffa32d4f19ec4922f3cd869747f267378f81f8e3fcb12d';
      Account account = Account.fromPrivateKey(privateKey, NetworkType.MIJIN_TEST);

      NodeInfo nodeInfo = new NodeInfo(account.publicKey, 3000, NetworkType.MIJIN_TEST, 0,
          RoleType.API_NODE, 'localhost', 'testNode');
      expect(nodeInfo.host, equals('localhost'));
      expect(nodeInfo.version, equals(0));
      expect(nodeInfo.port, equals(3000));
      expect(nodeInfo.friendlyName, equals('testNode'));
      expect(nodeInfo.networkIdentifier, equals(NetworkType.MIJIN_TEST));
      expect(nodeInfo.role, equals(RoleType.API_NODE));
      expect(nodeInfo.publicKey, equals(account.publicKey));
    });
  });
}
