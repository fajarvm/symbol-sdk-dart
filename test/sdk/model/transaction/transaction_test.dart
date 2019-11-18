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

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/sdk.dart'
    show
        Deadline,
        NetworkType,
        PublicAccount,
        Transaction,
        TransactionInfo,
        TransactionType,
        TransactionVersion,
        Uint64;
import 'package:test/test.dart';

void main() {
  group('Transaction', () {
    const generationHash = '57F7DA205008026C776CB6AED843393F04CD458E0AA2D9F1D5F31A402072B2D6';

    group('createHash', () {
      test('from a transfer transaction payload', () {
        const payload =
            'C7000000D0B190DFEEAB0378F943F79CDB7BC44453491890FAA70F5AA95B909E67487408407956BDE32AC'
            '977D035FBBA575C11AA034B23402066C16FD6126893F3661B099A49366406ACA952B88BADF5F1E9BE6CE4'
            '968141035A60BE503273EA65456B24039054410000000000000000A76541BE0C00000090E8FEBD671DD41'
            'BEE94EC3BA5831CB608A312C2F203BA84AC03000300303064000000000000006400000000000000002F00'
            'FA0DEDD9086400000000000000443F6D806C05543A6400000000000000';

        final hash = Transaction.createHash(payload, generationHash, NetworkType.MIJIN_TEST);

        const expected = 'BADC739882F2EE3D7D54A0DC3B62C2ADA50259CB32E99E012452C516C7BE94C6';
        expect(hash, equals(expected.toLowerCase()));
      });

      test('from an aggregate transaction payload', () {
        const payload =
            'E9000000A37C8B0456474FB5E3E910E84B5929293C114E0AF97FEF0D940D3A2A2C337BAFA0C59538E5988'
            '229B65A3065B4E9BD57B1AFAEC64DFBE2211B8AF6E742801E08C2F93346E27CE6AD1A9F8F5E3066F83265'
            '93A406BDF357ACB041E2F9AB402EFE0390414100000000000000008EEAC2C80C0000006D0000006D00000'
            '0C2F93346E27CE6AD1A9F8F5E3066F8326593A406BDF357ACB041E2F9AB402EFE0390554101020200B0F9'
            '3CBEE49EEB9953C6F3985B15A4F238E205584D8F924C621CBE4D7AC6EC2400B1B5581FC81A6970DEE418D'
            '2C2978F2724228B7B36C5C6DF71B0162BB04778B4';

        final hash = Transaction.createHash(payload, generationHash, NetworkType.MIJIN_TEST);

        const expected = 'EA67D29F3E3EE1F5107AB68E0E8BD5F1CF85901F8778AAF6FAF74316D973B30D';
        expect(hash, equals(expected.toLowerCase()));
      });
    });

    group('isUnannounced', () {
      test('returns true when there is no TransactionInfo vailable', () {
        final tx = new MockTransaction(TransactionType.TRANSFER, NetworkType.MIJIN_TEST,
            TransactionVersion.TRANSFER, Deadline.create(), Uint64(0));

        expect(tx.isUnannounced(), isTrue);
      });
    });

    group('isUnconfirmed', () {
      test('returns true when height is 0', () {
        final txInfo = TransactionInfo.create(Uint64(0), 'hash', 'hash', index: 1, id: 'hash');
        final tx = new MockTransaction(TransactionType.TRANSFER, NetworkType.MIJIN_TEST,
            TransactionVersion.TRANSFER, Deadline.create(), Uint64(0),
            transactionInfo: txInfo);

        expect(tx.isUnconfirmed(), isTrue);
      });

      test('returns false when height is not 0', () {
        final txInfo = TransactionInfo.create(Uint64(100), 'hash', 'hash', index: 1, id: 'hash');
        final tx = new MockTransaction(TransactionType.TRANSFER, NetworkType.MIJIN_TEST,
            TransactionVersion.TRANSFER, Deadline.create(), Uint64(0),
            transactionInfo: txInfo);

        expect(tx.isUnconfirmed(), isFalse);
      });
    });

    group('isConfirmed', () {
      test('returns true when height is not 0', () {
        final txInfo = TransactionInfo.create(Uint64(100), 'hash', 'hash', index: 1, id: 'hash');
        final tx = new MockTransaction(TransactionType.TRANSFER, NetworkType.MIJIN_TEST,
            TransactionVersion.TRANSFER, Deadline.create(), Uint64(0),
            transactionInfo: txInfo);

        expect(tx.isConfirmed(), isTrue);
      });
    });

    group('hasMissingSignatures', () {
      test('returns true when height is 0 and the hash are different to the merkle hash', () {
        final txInfo = TransactionInfo.create(Uint64(0), 'hash', 'hash_2', index: 1, id: 'hash');
        final tx = new MockTransaction(TransactionType.TRANSFER, NetworkType.MIJIN_TEST,
            TransactionVersion.TRANSFER, Deadline.create(), Uint64(0),
            transactionInfo: txInfo);

        expect(tx.hasMissingSignatures(), isTrue);
      });
    });
  });
}

class MockTransaction extends Transaction {
  MockTransaction(final TransactionType transactionType, final NetworkType networkType,
      final TransactionVersion version, final Deadline deadline, final Uint64 fee,
      {final String signature, final PublicAccount signer, final TransactionInfo transactionInfo})
      : super(transactionType, networkType, version, deadline, fee, signature, signer,
            transactionInfo);

  @override
  Uint8List generateEmbeddedBytes() {
    return null;
  }

  @override
  Uint8List generateBytes() {
    return null;
  }
}
