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

library nem2_sdk_dart.sdk.model.account.multisig_account_info;

/// This class describes the information of all the multi-signature levels of an account.
import 'public_account.dart';

class MultisigAccountInfo {
  /// The public account of this account.
  final PublicAccount account;

  /// The number of signatures needed to approve a transaction for this account.
  final int minApproval;

  /// The number of signatures needed to remove a cosignatory of this account.
  final int minRemoval;

  /// The list of cosignatories of this account.
  final List<PublicAccount> cosignatories;

  /// The list of multi-signature accounts that this account is a cosigner of.
  final List<PublicAccount> multisigAccounts;

  MultisigAccountInfo._(
      this.account, this.minApproval, this.minRemoval, this.cosignatories, this.multisigAccounts);

  factory MultisigAccountInfo(
      final PublicAccount account,
      final int minApproval,
      final int minRemoval,
      final List<PublicAccount> cosignatories,
      final List<PublicAccount> multisigAccounts) {
    if (0 > minApproval) {
      throw new ArgumentError('minApproval must not be negative');
    }
    if (0 > minRemoval) {
      throw new ArgumentError('minRemoval must not be negative');
    }
    return new MultisigAccountInfo._(
        account, minApproval, minRemoval, cosignatories, multisigAccounts);
  }

  /// Checks if this account is a multi-signature account.
  bool isMultisig() => minApproval != 0 && minRemoval != 0;

  /// Checks if the given [account] is a cosignatory of this account.
  bool hasCosigner(final PublicAccount account) => cosignatories.contains(account);

  /// Checks if this account is a cosignatory of the given [multisigAccount].
  bool isCosignerOf(final PublicAccount multisigAccount) =>
      multisigAccounts.contains(multisigAccount);
}
