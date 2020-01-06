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

library nem2_sdk_dart.sdk.model.transaction.transaction;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/core.dart' show HexUtils, KeyPair, SHA3Hasher, SignSchema;

import '../account/account.dart';
import '../account/public_account.dart';
import '../blockchain/network_type.dart';
import '../common/uint64.dart';
import 'deadline.dart';
import 'signed_transaction.dart';
import 'transaction_info.dart';
import 'transaction_type.dart';
import 'transaction_version.dart';

/// An abstract transaction class that serves as the base class of all NEM transactions.
abstract class Transaction {
  /// Transaction header size.
  ///
  /// Consists of `size`, `verifiableEntityHeader_Reserved1`, `signature`, `signerPublicKey` and
  /// `entityBody_Reserved1`.
  static const int HEADER_SIZE = 4 + 4 + 64 + 32 + 4;

  /// Index of the transaction type.
  ///
  /// Consists of a transaction header, `version` and `network`.
  static const int TYPE_INDEX = HEADER_SIZE + 1 + 1;

  /// Index of the transaction body.
  ///
  /// Consists of a transaction header, transaction type, `type`, `maxFee` and `deadline`.
  static const int BODY_INDEX = TYPE_INDEX + 2 + 8 + 8;

  /// The transaction type.
  final TransactionType type;

  /// The network type.
  final NetworkType networkType;

  /// The transaction version.
  final TransactionVersion version;

  /// The deadline for the transaction to be included in a block before it expires.
  final Deadline deadline;

  /// The maximum fee allowed to be spent for this transaction.
  ///
  /// The higher the fee, the higher the priority of the transaction. Transactions with high
  /// priority get included in a block before transactions with lower priority.
  final Uint64 maxFee;

  /// The transaction signature.
  ///
  /// An aggregate transaction doesn't have a transaction signature.
  final String signature;

  /// The public account of the transaction creator.
  PublicAccount signer;

  /// The meta data object contains additional information about the transaction.
  final TransactionInfo transactionInfo;

  /// The transaction version to be sent to the server.
  int get versionDTO => (networkType.value << 8) + version.value;

  /// The hex string representation of the transaction version.
  String get versionHex => '0x${versionDTO.toRadixString(16)}';

  /// Get the byte size of a transaction
  int get size => BODY_INDEX;

  Transaction(this.type, this.networkType, this.version, this.deadline, this.maxFee,
      [this.signature, this.signer, this.transactionInfo])
      : assert(type != null &&
            networkType != null &&
            version != null &&
            deadline != null &&
            maxFee != null);

  /// An abstract method to generate the transaction bytes.
  Uint8List generateBytes();

  /// An abstract method to generate the embedded transaction bytes.
  Uint8List generateEmbeddedBytes();

  /// Serialize this transaction object.
  String serialize() {
    return HexUtils.bytesToHex(generateBytes());
  }

  /// Returns `true` if this transaction is included in a block.
  bool isConfirmed() {
    return !_hasZeroHeight() && BigInt.zero < transactionInfo.height.value;
  }

  /// Returns `true' if this transaction is pending to be included in a block.
  bool isUnconfirmed() {
    return _hasZeroHeight() && transactionInfo.hash == transactionInfo.merkleComponentHash;
  }

  /// Returns `true` if this transaction has missing signatures.
  bool hasMissingSignatures() {
    return _hasZeroHeight() && transactionInfo.hash != transactionInfo.merkleComponentHash;
  }

  /// Returns `true` if this transaction is not yet known to the network.
  bool isUnannounced() {
    return transactionInfo == null;
  }

  /// Converts an aggregate transaction to an inner transaction including transaction signer.
  Transaction toAggregate(final PublicAccount signer) {
    _validateAggregatedTransaction();

    this.signer = signer;

    return this;
  }

  /// Takes a transaction and formats the bytes to be included in an aggregate transaction.
  Uint8List toAggregateTransactionBytes() {
    return generateEmbeddedBytes();
  }

  /// Generates the transaction hash of the serialized transaction payload on a [networkType].
  ///
  /// @see https://github.com/nemtech/catapult-server/blob/master/src/catapult/model/EntityHasher.cpp#L32
  /// @see https://github.com/nemtech/catapult-server/blob/master/src/catapult/model/EntityHasher.cpp#L35
  /// @see https://github.com/nemtech/catapult-server/blob/master/sdk/src/extensions/TransactionExtensions.cpp#L46
  static String createTransactionHash(
      final String transactionPayload, final String generationHash, final NetworkType networkType) {
    ArgumentError.checkNotNull(transactionPayload);
    ArgumentError.checkNotNull(generationHash);
    ArgumentError.checkNotNull(networkType);

    // prepare
    final Uint8List transactionBytes = HexUtils.getBytes(transactionPayload);
    final Uint8List generationHashBytes = HexUtils.getBytes(generationHash);

    // read transaction bytes
    const int typeIdx = Transaction.TYPE_INDEX;
    final List<int> typeBytes = transactionBytes.sublist(typeIdx, typeIdx + 2).reversed.toList();
    final String typeHex = HexUtils.bytesToHex(typeBytes);
    final TransactionType entityType = TransactionType.fromInt(int.parse(typeHex, radix: 16));

    // 1) take "R" part of a signature (first 32 bytes)
    final List<int> signatureR = transactionBytes.skip(8).take(32).toList();

    // 2) add public key to match sign/verify behavior (32 bytes)
    final int pubKeyIdx = signatureR.length;
    final List<int> publicKey = transactionBytes.skip(8 + 64).take(32).toList();

    // 3) add generationHash (32 bytes)
    final int generationHashIdx = pubKeyIdx + publicKey.length;

    // 4) add transaction data without header (EntityDataBuffer)
    // @link https://github.com/nemtech/catapult-server/blob/master/src/catapult/model/EntityHasher.cpp#L30
    final int transactionBodyIdx = generationHashIdx + generationHashBytes.length;
    // in case of aggregate transactions, we hash only the merkle transaction hash.
    final List<int> transactionBody = TransactionType.isAggregate(entityType)
        ? transactionBytes.sublist(HEADER_SIZE, BODY_INDEX + 32)
        : transactionBytes.sublist(HEADER_SIZE);

    // 5) concatenate binary hash parts
    // layout: `signature_R || signerPublicKey || generationHash || EntityDataBuffer`
    final Uint8List entityHashBytes = Uint8List(
      signatureR.length + publicKey.length + generationHashBytes.length + transactionBody.length,
    );
    entityHashBytes.setAll(0, signatureR);
    entityHashBytes.setAll(pubKeyIdx, publicKey);
    entityHashBytes.setAll(generationHashIdx, generationHashBytes);
    entityHashBytes.setAll(transactionBodyIdx, transactionBody);

    // 6) create SHA3 hash of transaction data
    // Note: Transaction hashing *always* uses SHA3
    final SignSchema signSchema = NetworkType.resolveSignSchema(networkType);
    final Uint8List result = SHA3Hasher.create(signSchema, hashSize: 32).process(entityHashBytes);
    final String hashHex = HexUtils.bytesToHex(result);
    return hashHex;
  }

  /// Serialize and sign transaction with the given [account] and network [generationHash] and
  /// create a new [SignedTransaction].
  SignedTransaction signWith(final Account account, final String generationHash) {
    final SignSchema signSchema = NetworkType.resolveSignSchema(account.networkType);

    final KeyPair keyPairEncoded = KeyPair.fromPrivateKey(account.privateKey, signSchema);
    final String txSigned = sign(keyPairEncoded, generationHash, signSchema);
    final String txHash = createTransactionHash(txSigned, generationHash, account.networkType);

    return new SignedTransaction(txSigned, txHash, account.publicKey, type, networkType);
  }

  /// Sign this transaction with the given [keypair] and network [generationHash] and create
  /// a new signed transaction payload string.
  String sign(final KeyPair keypair, final String generationHash, final SignSchema signSchema) {
    final Uint8List bytes = this.generateBytes();
    final Uint8List generationHashBytes = HexUtils.getBytes(generationHash);

    // create signing byte
    final List<int> signingSuffix = bytes.take(4 + 64 + 32).toList();
    final Uint8List signing = Uint8List.fromList(generationHashBytes + signingSuffix);

    // create signature
    final List<int> signature = KeyPair.signData(keypair, signing, signSchema).toList();

    // create transaction payload
    final List<int> tx = bytes.skip(4).take(bytes.length - 4).toList();
    final List<int> publicKey = keypair.publicKey.toList();
    final List<int> suffix = bytes.skip(100).take(bytes.length - 100).toList();
    final Uint8List payload = Uint8List.fromList(tx + signature + publicKey + suffix);

    return HexUtils.bytesToHex(payload);
  }

  // ------------------------------ private / protected functions ------------------------------ //

  void _validateAggregatedTransaction() {
    if (TransactionType.isAggregate(type)) {
      throw new ArgumentError('Inner transaction cannot be an aggregated transaction.');
    }
  }

  bool _hasZeroHeight() {
    if (transactionInfo == null || transactionInfo.height == null) {
      return false;
    }

    return BigInt.zero == transactionInfo.height.value;
  }
}
