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

library nem2_sdk_dart.sdk.model.account.multisig_account_graph_info;

import 'multisig_account_info.dart';

/// The multi-signature account graph info structure describes the information of all the
/// multi-signature levels an account is involved in.
class MultisigAccountGraphInfo {
  final Map<int, List<MultisigAccountInfo>> multisigAccounts;

  const MultisigAccountGraphInfo._(this.multisigAccounts);

  factory MultisigAccountGraphInfo(final Map<int, List<MultisigAccountInfo>> multisigAccounts) {
    if (multisigAccounts.isNotEmpty) {
      multisigAccounts.forEach((key, value) {
        if (0 > key) {
          throw new ArgumentError('the key must not be negative');
        }
      });
    }

    return new MultisigAccountGraphInfo._(multisigAccounts);
  }
}
