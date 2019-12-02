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

import 'package:nem2_sdk_dart/sdk.dart' show TransactionVersion;
import 'package:test/test.dart';

void main() {
  group('TransactionVersion', () {
    test('valid transaction versions', () {
      // Mosaic
      expect(TransactionVersion.MOSAIC_DEFINITION.value, 1);
      expect(TransactionVersion.MOSAIC_SUPPLY_CHANGE.value, 1);

      // Namespace
      expect(TransactionVersion.NAMESPACE_REGISTRATION.value, 1);
      expect(TransactionVersion.ADDRESS_ALIAS.value, 1);
      expect(TransactionVersion.MOSAIC_ALIAS.value, 1);

      // Transfer
      expect(TransactionVersion.TRANSFER.value, 1);

      // Multi-signature
      expect(TransactionVersion.MODIFY_MULTISIG_ACCOUNT.value, 1);

      // Aggregate
      expect(TransactionVersion.AGGREGATE_COMPLETE.value, 1);
      expect(TransactionVersion.AGGREGATE_BONDED.value, 1);

      // Hash lock / Lock funds
      expect(TransactionVersion.LOCK.value, 1);

      // Cross-chain swaps
      expect(TransactionVersion.SECRET_LOCK.value, 1);
      expect(TransactionVersion.SECRET_PROOF.value, 1);

      // Account restriction
      expect(TransactionVersion.ACCOUNT_RESTRICTION_ADDRESS.value, 1);
      expect(TransactionVersion.ACCOUNT_RESTRICTION_MOSAIC.value, 1);
      expect(TransactionVersion.ACCOUNT_RESTRICTION_OPERATION.value, 1);

      // Account link / remote harvesting
      expect(TransactionVersion.ACCOUNT_LINK.value, 1);

      // Mosaic restriction
      expect(TransactionVersion.MOSAIC_RESTRICTION_ADDRESS.value, 1);
      expect(TransactionVersion.MOSAIC_RESTRICTION_GLOBAL.value, 1);

      // Metadata
      expect(TransactionVersion.METADATA_ACCOUNT.value, 1);
      expect(TransactionVersion.METADATA_MOSAIC.value, 1);
      expect(TransactionVersion.METADATA_NAMESPACE.value, 1);

      expect(TransactionVersion.TRANSFER.toString(),
          equals('TransactionVersion{value: ${TransactionVersion.TRANSFER.value}}'));
    });
  });
}
