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

import 'package:nem2_sdk_dart/core.dart' show Ed25519, HexUtils, KeyPair;

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
  /// The transaction type.
  final TransactionType type;

  /// The network type.
  final NetworkType networkType;

  /// The transaction version.
  final TransactionVersion version;

  /// The deadline for the transaction to be included in a block before it expires.
  final Deadline deadline;

  /// The transaction fee.
  ///
  /// The higher the fee, the higher the priority of the transaction. Transactions with high
  /// priority get included in a block before transactions with lower priority.
  final Uint64 fee;

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

  Transaction(this.type, this.networkType, this.version, this.deadline, this.fee,
      [this.signature, this.signer, this.transactionInfo])
      : assert(type != null &&
            networkType != null &&
            version != null &&
            deadline != null &&
            fee != null);

  /// An abstract method to generate the transaction bytes.
  Uint8List generateBytes();

  /// An abstract method to generate the embedded transaction bytes.
  Uint8List generateEmbeddedBytes();

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

  /// Generates the transaction hash for a serialized transaction payload.
  static String createHash(final String payload, final Uint8List generationHash) {
    final Uint8List payloadBytes = HexUtils.getBytes(payload);
    final List<int> signingPart = payloadBytes.skip(4).take(32).toList();
    final List<int> keyPart = payloadBytes.skip(4 + 64).take(32).toList();
    final Uint8List signingBytes = Uint8List.fromList(signingPart + keyPart + generationHash);

    final Uint8List hash = Ed25519.createSha3Digest(length: 32).process(signingBytes);
    final String hashHex = HexUtils.getString(hash);

    return hashHex;
  }

  /// Serialize and sign transaction with the given [account] and network [generationHash].
  SignedTransaction signWith(final Account account, final String generationHash) {
    final KeyPair keypair = KeyPair.fromPrivateKey(account.privateKey);
    final String txSigned = sign(keypair);
    final Uint8List generationHashBytes = HexUtils.getBytes(generationHash);
    final String txHash = createHash(txSigned, generationHashBytes);

    // TODO: complete and check
//    final Uint8List bytes = this.generateBytes();
//    final List<int> tx = bytes.skip(4).take(bytes.length - 4).toList();
//    final KeyPair kp = KeyPair.fromPrivateKey(HexUtils.getString(keypair.privateKey));
//    final Uint8List signing = Uint8List.fromList(bytes.take(4 + 64 + 32).toList());
//    final Uint8List signature = KeyPair.signData(kp, signing);
//    final Uint8List payload = Uint8List.fromList(tx + signature.toList() + kp.publicKey.toList());

    return new SignedTransaction(txSigned, txHash, account.publicKey, type, networkType);
  }

  /// Sign this transaction with the given [keypair].
  ///
  /// Returns the signed transaction payload as a hex string.
  String sign(final KeyPair keypair) {
    final Uint8List buffer = this.generateBytes();
    final List<int> tx = buffer.skip(4).take(buffer.length - 4).toList();
    final KeyPair kp = KeyPair.fromPrivateKey(HexUtils.getString(keypair.privateKey));
    final Uint8List signing = Uint8List.fromList(buffer.take(4 + 64 + 32).toList());
    final Uint8List signature = KeyPair.signData(kp, signing);
    final Uint8List payload = Uint8List.fromList(tx + signature.toList() + kp.publicKey.toList());

    // TODO: complete and check

    return HexUtils.getString(payload);
  }

  // ------------------------------ private / protected functions ------------------------------ //

  void _validateAggregatedTransaction() {
    if (TransactionType.isAggregateType(type)) {
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
