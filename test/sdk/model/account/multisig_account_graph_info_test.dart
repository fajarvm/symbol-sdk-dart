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

library symbol_sdk_dart.test.sdk.model.account.multisig_account_graph_info_test;

import 'package:test/test.dart';

import 'package:symbol_sdk_dart/core.dart' show ArrayUtils;
import 'package:symbol_sdk_dart/sdk.dart'
    show MultisigAccountGraphInfo, MultisigAccountInfo, NetworkType, PublicAccount;

void main() {
  group('MultisigAccountGraphInfo', () {
    test('Can create a multi-signature account graph info', () {
      // Test accounts
      final account = PublicAccount.fromPublicKey(
          'B694186EE4AB0558CA4AFCFDD43B42114AE71094F5A1FC4A913FE9971CACD21D',
          NetworkType.MIJIN_TEST);
      final cosignatory1 = PublicAccount.fromPublicKey(
          'CF893FFCC47C33E7F68AB1DB56365C156B0736824A0C1E273F9E00B8DF8F01EB',
          NetworkType.MIJIN_TEST);
      final cosignatory2 = PublicAccount.fromPublicKey(
          '68B3FBB18729C1FDE225C57F8CE080FA828F0067E451A3FD81FA628842B0B763',
          NetworkType.MIJIN_TEST);
      final cosignatory3 = PublicAccount.fromPublicKey(
          'DAB1C38C3E1642494FCCB33138B95E81867B5FB59FC4277A1D53761C8B9F6D14',
          NetworkType.MIJIN_TEST);
      final cosignatories = <PublicAccount>[cosignatory1, cosignatory2, cosignatory3];
      final multisigs = <PublicAccount>[
        PublicAccount.fromPublicKey(
            '1674016C27FE2C2EB5DFA73996FA54A183B38AED0AA64F756A3918BAF08E061B',
            NetworkType.MIJIN_TEST)
      ];

      final multisigAccounts = <int, List<MultisigAccountInfo>>{};
      multisigAccounts.putIfAbsent(2, () {
        return <MultisigAccountInfo>[
          new MultisigAccountInfo(account, 3, 3, cosignatories, multisigs)
        ];
      });

      final multisigAccountInfoGraph = new MultisigAccountGraphInfo(multisigAccounts);

      expect(multisigAccountInfoGraph.levelNumber, isNotEmpty);
      expect(multisigAccountInfoGraph.levelNumber.length, 1);
      expect(multisigAccountInfoGraph.multisigAccounts.containsKey(2), isTrue);
      expect(multisigAccountInfoGraph.multisigAccounts.containsKey(3), isFalse);
      expect(multisigAccountInfoGraph.multisigAccounts[2][0].account, equals(account));
      expect(multisigAccountInfoGraph.multisigAccounts[2][0].minApproval, 3);
      expect(multisigAccountInfoGraph.multisigAccounts[2][0].minRemoval, 3);
      expect(
          ArrayUtils.deepEqual(
              multisigAccountInfoGraph.multisigAccounts[2][0].cosignatories, cosignatories),
          isTrue);
      expect(
          ArrayUtils.deepEqual(
              multisigAccountInfoGraph.multisigAccounts[2][0].multisigAccounts, multisigs),
          isTrue);

      expect(multisigAccountInfoGraph.toString(), equals(
        'MultisigAccountGraphInfo{multisigAccounts: $multisigAccounts}'
      ));
    });
  });
}
