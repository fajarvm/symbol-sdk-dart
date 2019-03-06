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

library nem2_sdk_dart.test.sdk.model.transaction.transaction_test;

import 'dart:typed_data';

import 'package:nem2_sdk_dart/src/sdk/model/account/public_account.dart';
import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart'
    show Deadline, NetworkType, Transaction, TransactionInfo, TransactionType, Uint64;

void main() {
  group('Transaction', () {
    group('isUnannounced', () {
      test('returns true when there is no TransactionInfo vailable', () {
        final tx = new MockTransaction(
            TransactionType.TRANSFER, NetworkType.MIJIN_TEST, 1, Deadline.create(), Uint64(0));

        expect(tx.isUnannounced(), isTrue);
      });
    });

    group('isUnconfirmed', () {
      test('returns true when height is 0', () {
        final txInfo = TransactionInfo.create(Uint64(0), 'hash', 'hash', index: 1, id: 'hash');
        final tx = new MockTransaction(
            TransactionType.TRANSFER, NetworkType.MIJIN_TEST, 1, Deadline.create(), Uint64(0),
            transactionInfo: txInfo);

        expect(tx.isUnconfirmed(), isTrue);
      });

      test('returns false when height is not 0', () {
        final txInfo = TransactionInfo.create(Uint64(100), 'hash', 'hash', index: 1, id: 'hash');
        final tx = new MockTransaction(
            TransactionType.TRANSFER, NetworkType.MIJIN_TEST, 1, Deadline.create(), Uint64(0),
            transactionInfo: txInfo);

        expect(tx.isUnconfirmed(), isFalse);
      });
    });

    group('isConfirmed', () {
      test('returns true when height is not 0', () {
        final txInfo = TransactionInfo.create(Uint64(100), 'hash', 'hash', index: 1, id: 'hash');
        final tx = new MockTransaction(
            TransactionType.TRANSFER, NetworkType.MIJIN_TEST, 1, Deadline.create(), Uint64(0),
            transactionInfo: txInfo);

        expect(tx.isConfirmed(), isTrue);
      });
    });

    group('hasMissingSignatures', () {
      test('returns true when height is 0 and the hash are different to the merkle hash', () {
        final txInfo = TransactionInfo.create(Uint64(0), 'hash', 'hash_2', index: 1, id: 'hash');
        final tx = new MockTransaction(
            TransactionType.TRANSFER, NetworkType.MIJIN_TEST, 1, Deadline.create(), Uint64(0),
            transactionInfo: txInfo);

        expect(tx.hasMissingSignatures(), isTrue);
      });
    });
  });
}

class MockTransaction extends Transaction {
  MockTransaction(final int transactionType, final int networkType, final int version,
      final Deadline deadline, final Uint64 fee,
      {final String signature, final PublicAccount signer, final TransactionInfo transactionInfo})
      : super(transactionType, networkType, version, deadline, fee, signature, signer,
            transactionInfo);

  @override
  Uint8List generateBytes() {
    return null;
  }

  @override
  Transaction toAggregate(PublicAccount signer) {
    return null;
  }
}
