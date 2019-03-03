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

library nem2_sdk_dart.test.sdk.model.account.multisig_account_info_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show MultisigAccountInfo, NetworkType, PublicAccount;

void main() {
  // Test accounts
  final account = PublicAccount.fromPublicKey(
      'B694186EE4AB0558CA4AFCFDD43B42114AE71094F5A1FC4A913FE9971CACD21D', NetworkType.MIJIN_TEST);
  final cosignatory1 = PublicAccount.fromPublicKey(
      'CF893FFCC47C33E7F68AB1DB56365C156B0736824A0C1E273F9E00B8DF8F01EB', NetworkType.MIJIN_TEST);
  final cosignatory2 = PublicAccount.fromPublicKey(
      '68B3FBB18729C1FDE225C57F8CE080FA828F0067E451A3FD81FA628842B0B763', NetworkType.MIJIN_TEST);
  final cosignatory3 = PublicAccount.fromPublicKey(
      'DAB1C38C3E1642494FCCB33138B95E81867B5FB59FC4277A1D53761C8B9F6D14', NetworkType.MIJIN_TEST);
  final cosignatories = <PublicAccount>[cosignatory1, cosignatory2, cosignatory3];
  final multisigs = <PublicAccount>[
    PublicAccount.fromPublicKey(
        '1674016C27FE2C2EB5DFA73996FA54A183B38AED0AA64F756A3918BAF08E061B', NetworkType.MIJIN_TEST)
  ];

  group('MultisigAccountInfo creation via constructor', () {
    test('Can create via constructor', () {
      final actual = new MultisigAccountInfo(account, 3, 3, cosignatories, multisigs);

      expect(actual.account, equals(account));
      expect(actual.minApproval, 3);
      expect(actual.minRemoval, 3);
      expect(actual.cosignatories, equals(cosignatories));
      expect(actual.multisigAccounts, equals(multisigs));
    });

    test('Cannot crete with invalid parameter values', () {
      expect(
          () => new MultisigAccountInfo(account, -1, 1, cosignatories, multisigs),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message == 'minApproval must not be negative')));
      expect(
          () => new MultisigAccountInfo(account, 1, -1, cosignatories, multisigs),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message == 'minRemoval must not be negative')));
    });
  });

  group('isMultiSig()', () {
    test('Should returns true when minApproval is greater than 0', () {
      final actual = new MultisigAccountInfo(account, 1, 1, cosignatories, multisigs);

      expect(actual.isMultisig(), isTrue);
    });

    test('Should returns true when minRemoval is greater than 0', () {
      final actual = new MultisigAccountInfo(account, 2, 2, cosignatories, multisigs);

      expect(actual.isMultisig(), isTrue);
    });

    test('Should returns false when both minApproval and minRemoval are 0', () {
      final actual = new MultisigAccountInfo(account, 0, 0, cosignatories, multisigs);

      expect(actual.isMultisig(), isFalse);
    });
  });

  group('hasCosigner()', () {
    test('Should returns true when account is in the cosignatories list', () {
      final actual = new MultisigAccountInfo(account, 1, 1, cosignatories, multisigs);
      final cosigner = PublicAccount.fromPublicKey(
          'CF893FFCC47C33E7F68AB1DB56365C156B0736824A0C1E273F9E00B8DF8F01EB',
          NetworkType.MIJIN_TEST);

      expect(actual.hasCosigner(cosigner), isTrue);
    });

    test('Should returns false when account is not in the cosignatories list', () {
      final actual = new MultisigAccountInfo(account, 1, 1, cosignatories, multisigs);
      final notCosigner = PublicAccount.fromPublicKey(
          'B694186EE4AB0558CA4AFCFDD43B42114AE71094F5A1FC4A913FE9971CACD21D',
          NetworkType.MIJIN_TEST);

      expect(actual.hasCosigner(notCosigner), isFalse);
    });
  });

  group('isCosignerOf()', () {
    test('Should returns true when account is in the multisig account list', () {
      final actual = new MultisigAccountInfo(account, 1, 1, cosignatories, multisigs);
      final otherAccount = PublicAccount.fromPublicKey(
          '1674016C27FE2C2EB5DFA73996FA54A183B38AED0AA64F756A3918BAF08E061B',
          NetworkType.MIJIN_TEST);

      expect(actual.isCosignerOf(otherAccount), isTrue);
    });

    test('Should returns false when account is not in the multisig account list', () {
      final actual = new MultisigAccountInfo(account, 1, 1, cosignatories, multisigs);
      final otherAccount = PublicAccount.fromPublicKey(
          'B694186EE4AB0558CA4AFCFDD43B42114AE71094F5A1FC4A913FE9971CACD21D',
          NetworkType.MIJIN_TEST);

      expect(actual.isCosignerOf(otherAccount), isFalse);
    });
  });
}
