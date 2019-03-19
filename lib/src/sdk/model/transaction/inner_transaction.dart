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

library nem2_sdk_dart.sdk.model.transaction.inner_transaction;

import '../account/public_account.dart';
import 'transaction.dart';

/// A transaction with signer included.
///
/// This class is used when adding signer to transactions included in an aggregate transaction.
class InnerTransaction extends Transaction {
  final PublicAccount _signer;

  InnerTransaction(Transaction tx, this._signer)
      : super(tx.transactionType, tx.networkType, tx.version, tx.deadline, tx.fee, tx.signature,
            _signer, tx.transactionInfo);

  PublicAccount get innerSigner => _signer;
}
