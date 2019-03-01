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

library nem2_sdk_dart.test.sdk.model.transaction.transaction_version_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show TransactionVersion;

void main() {
  group('TransactionVersion', () {
    test('valid transaction versions', () {
      // Account filters
      expect(TransactionVersion.ACCOUNT_FILTER_ADDRESS, 1);
      expect(TransactionVersion.ACCOUNT_FILTER_MOSAIC, 1);
      expect(TransactionVersion.ACCOUNT_FILTER_ENTITY_TYPE, 1);

      // Mosaic
      expect(TransactionVersion.MOSAIC_DEFINITION, 3);
      expect(TransactionVersion.MOSAIC_SUPPLY_CHANGE, 2);
      expect(TransactionVersion.MOSAIC_LEVY_CHANGE, 1);

      // Namespace
      expect(TransactionVersion.NAMESPACE_REGISTRATION, 2);
      expect(TransactionVersion.NAMESPACE_ATTACH_TO_ACCOUNT, 1);
      expect(TransactionVersion.NAMESPACE_ATTACH_TO_MOSAIC, 1);

      // Transfer
      expect(TransactionVersion.TRANSFER, 3);

      // Multi-signature
      expect(TransactionVersion.MULTISIG_MODIFY, 3);

      // Aggregate
      expect(TransactionVersion.AGGREGATE_COMPLETE, 2);
      expect(TransactionVersion.AGGREGATE_BONDED, 2);

      // Hash lock / Lock funds
      expect(TransactionVersion.HASH_LOCK, 1);

      // Cross-chain swaps
      expect(TransactionVersion.SECRET_LOCK, 1);
      expect(TransactionVersion.SECRET_PROOF, 1);

      // Account link / remote harvesting
      expect(TransactionVersion.ACCOUNT_LINK, 2);
    });
  });
}
