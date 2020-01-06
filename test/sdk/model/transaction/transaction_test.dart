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
    group('isUnannounced', () {
      test('should return true when there is no TransactionInfo vailable', () {
        final tx = new MockTransaction(TransactionType.TRANSFER, NetworkType.MIJIN_TEST,
            TransactionVersion.TRANSFER, Deadline.create(), Uint64(0));

        expect(tx.isUnannounced(), isTrue);
      });
    });

    group('isUnconfirmed', () {
      test('should return true when height is 0', () {
        final txInfo = TransactionInfo.create(Uint64(0), 'hash', 'hash', index: 1, id: 'hash');
        final tx = new MockTransaction(TransactionType.TRANSFER, NetworkType.MIJIN_TEST,
            TransactionVersion.TRANSFER, Deadline.create(), Uint64(0),
            transactionInfo: txInfo);

        expect(tx.isUnconfirmed(), isTrue);
      });

      test('should return false when height is not 0', () {
        final txInfo = TransactionInfo.create(Uint64(100), 'hash', 'hash', index: 1, id: 'hash');
        final tx = new MockTransaction(TransactionType.TRANSFER, NetworkType.MIJIN_TEST,
            TransactionVersion.TRANSFER, Deadline.create(), Uint64(0),
            transactionInfo: txInfo);

        expect(tx.isUnconfirmed(), isFalse);
      });
    });

    group('isConfirmed', () {
      test('should return true when height is not 0', () {
        final txInfo = TransactionInfo.create(Uint64(100), 'hash', 'hash', index: 1, id: 'hash');
        final tx = new MockTransaction(TransactionType.TRANSFER, NetworkType.MIJIN_TEST,
            TransactionVersion.TRANSFER, Deadline.create(), Uint64(0),
            transactionInfo: txInfo);

        expect(tx.isConfirmed(), isTrue);
      });
    });

    group('hasMissingSignatures', () {
      test('should return true when height is 0 and hash is different to the merkle hash', () {
        final txInfo = TransactionInfo.create(Uint64(0), 'hash', 'hash_2', index: 1, id: 'hash');
        final tx = new MockTransaction(TransactionType.TRANSFER, NetworkType.MIJIN_TEST,
            TransactionVersion.TRANSFER, Deadline.create(), Uint64(0),
            transactionInfo: txInfo);

        expect(tx.hasMissingSignatures(), isTrue);
      });
    });

    group('size', () {
      test('should return 128 for base transaction size', () {
        final transaction = new MockTransaction(TransactionType.TRANSFER, NetworkType.MIJIN_TEST,
            TransactionVersion.TRANSFER, Deadline.create(), Uint64(0),
            transactionInfo:
                TransactionInfo.create(Uint64(100), 'hash', 'hash', id: 'id_hash', index: 1));

        expect(transaction.size, equals(128));
      });
    });

    group('version', () {
      test('should return version in hex format', () {
        final transaction = new MockTransaction(TransactionType.TRANSFER, NetworkType.MIJIN_TEST,
            TransactionVersion.TRANSFER, Deadline.create(), Uint64(0),
            transactionInfo:
                TransactionInfo.create(Uint64(100), 'hash', 'hash', id: 'id_hash', index: 1));

        expect(transaction.versionHex, equals('0x9001'));
      });
    });

    group('createTransactionHash', () {
      const payload = '970000000000000075DAC796D500CEFDFBD582BC6E0580401FE6DB02FBEA9367'
          '3DF47844246CDEA93715EB700F295A459E59D96A2BC6B7E36C79016A96B9FA38'
          '7E8B8937342FE30C6BE37B726EEE24C4B0E3C943E09A44691553759A89E92C4A'
          '84BBC4AD9AF5D49C0000000001984E4140420F0000000000E4B580B11A000000'
          'A0860100000000002AD8FC018D9A49E100056576696173';

      const payloadAggregate = '0801000000000000AC1F3E0EE2C16F465CDC2E091DC44D6EB55F7FE3988A5F21'
          '309DF479BE6D3F0033E155695FB1133EA0EA64A67C1EDC2B430CFAF9722AF36B'
          'AE84DBDB1C8F1509C2F93346E27CE6AD1A9F8F5E3066F8326593A406BDF357AC'
          'B041E2F9AB402EFE000000000190414200000000000000006BA50FB91A000000'
          'EA8F8301E7EDFD701F62E1DC1601ABDE22E5FCD11C9C7E7A01B87F8DFB6B62B0'
          '60000000000000005D00000000000000C2F93346E27CE6AD1A9F8F5E3066F832'
          '6593A406BDF357ACB041E2F9AB402EFE00000000019054419050B9837EFAB4BB'
          'E8A4B9BB32D812F9885C00D8FC1650E142000D000000000000746573742D6D65'
          '7373616765000000';

      // expected values
      const knownHash_sha3 = '709373248659274C5933BEA2920942D6C7B48B9C2DA4BAEE233510E71495931F';
      const generationHash = '988C4CDCE4D188013C13DE7914C7FD4D626169EF256722F61C52EFBE06BD5A2C';
      const generationHash_mt = '17FA4747F5014B50413CCF968749604D728D7065DC504291EEE556899A534CBB';

      test('create different hash given different signatures', () {
        final networkType = NetworkType.MIJIN_TEST;
        final hash1 = Transaction.createTransactionHash(payload, generationHash, networkType);

        // modify the signature part of the payload
        final modified = '${payload.substring(0, 16)}'
            '12'
            '${payload.substring(18)}';
        final hash2 = Transaction.createTransactionHash(modified, generationHash, networkType);

        // expect different hash
        expect(hash1 != hash2, isTrue);
      });

      test('create different hash given different signer public key', () {
        final networkType = NetworkType.MIJIN_TEST;
        final hash1 = Transaction.createTransactionHash(payload, generationHash, networkType);

        // modify the signer public key part of the payload
        final modified = '${payload.substring(0, 16 + 128)}'
            '12'
            '${payload.substring(16 + 128 + 2)}';
        final hash2 = Transaction.createTransactionHash(modified, generationHash, networkType);

        // expect different hash
        expect(hash1 != hash2, isTrue);
      });

      test('create different hash given different generation hash', () {
        final networkType = NetworkType.MIJIN_TEST;
        final hash1 = Transaction.createTransactionHash(payload, generationHash, networkType);
        final hash2 = Transaction.createTransactionHash(payload, generationHash_mt, networkType);

        // expect different hash
        expect(hash1 != hash2, isTrue);
      });

      test('create different hash given different transaction body', () {
        final networkType = NetworkType.MIJIN_TEST;
        final hash1 = Transaction.createTransactionHash(payload, generationHash, networkType);

        // modify the transaction body part of the payload
        final modified = '${payloadAggregate.substring(0, Transaction.BODY_INDEX * 2)}'
            '12'
            '${payloadAggregate.substring(Transaction.BODY_INDEX * 2 + 2)}';
        final hash2 = Transaction.createTransactionHash(modified, generationHash, networkType);

        // expect different hash
        expect(hash1 != hash2, isTrue);
      });

      test('create same hash given same payloads', () {
        final networkType = NetworkType.MIJIN_TEST;
        final hash1 = Transaction.createTransactionHash(payload, generationHash, networkType);
        final hash2 = Transaction.createTransactionHash(payload, generationHash, networkType);

        // expect same hash
        expect(hash1, equals(hash2));
      });

      test('create correct SHA3 transaction hash given network type MIJIN or MIJIN_TEST', () {
        final networkType = NetworkType.MIJIN_TEST;
        final hash1 = Transaction.createTransactionHash(payload, generationHash, networkType);
        final hash2 = Transaction.createTransactionHash(payload, generationHash, networkType);

        expect(hash1.toUpperCase(), equals(knownHash_sha3));
        expect(hash2.toUpperCase(), equals(knownHash_sha3));
      });

      test('hash only merkle transaction hash for aggregate transactions', () {
        final networkType = NetworkType.MIJIN_TEST;
        final hash1 =
            Transaction.createTransactionHash(payloadAggregate, generationHash, networkType);

        // modify the end of payload
        // this MUST NOT affect produced transaction hash
        // this test is valid only for Aggregate Transactions
        final modifiedSize = '12${payloadAggregate.substring(2)}';
        final hashModifiedBody =
            Transaction.createTransactionHash(modifiedSize, generationHash, networkType);

        // modify the merkle hash part of the payload
        // this MUST affect produced transaction hash
        final modifiedMerkle = '${payloadAggregate.substring(0, Transaction.BODY_INDEX * 2)}'
            '12'
            '${payloadAggregate.substring(Transaction.BODY_INDEX * 2 + 2)}';
        final hashModifiedMerkle =
            Transaction.createTransactionHash(modifiedMerkle, generationHash, networkType);

        expect(hash1, equals(hashModifiedBody));
        expect(hash1 != hashModifiedMerkle, isTrue);
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
