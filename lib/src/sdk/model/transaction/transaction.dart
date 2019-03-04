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

import 'package:nem2_sdk_dart/core.dart' show HexUtils, KeyPair, StringUtils;

import '../account/account.dart';
import '../account/public_account.dart';

import 'deadline.dart';
import 'signed_transaction.dart';
import 'transaction_helper.dart';
import 'transaction_info.dart';
import 'uint64.dart';
import 'verifiable_transaction.dart';

/// An abstract transaction class that serves as the base class of all NEM transactions.
abstract class Transaction {
  /// The transaction type.
  final int transactionType;

  /// The network type.
  final int networkType;

  /// The transaction format version.
  final int version;

  /// The deadline for the transaction to be included before it expires.
  final Deadline deadline;

  /// The transaction fee.
  ///
  /// The higher the fee, the higher the priority of the transaction. Transactions with high
  /// priority get included in a block before transactions with lower priority.
  final Uint64 fee;

  /// The transaction signature.
  ///
  /// Aggregate transactions don't have a transaction signature.
  final String signature;

  /// The public account of the transaction creator.
  final PublicAccount signer;

  /// The meta data object contains additional information about the transaction.
  final TransactionInfo transactionInfo;

  // private constructor
  Transaction._(this.transactionType, this.networkType, this.version, this.deadline, this.fee,
      this.signature, this.signer, this.transactionInfo);

  /// Returns `true` if this transaction is included in a block.
  bool isConfirmed() {
    return transactionInfo != null &&
        transactionInfo.height != null &&
        transactionInfo.height.value > BigInt.zero;
  }

  /// Returns `true' if this transaction is pending to be included in a block.
  bool isUnconfirmed() {
    if (transactionInfo == null) {
      return false;
    }

    return transactionInfo.height != null &&
        transactionInfo.height.value == BigInt.zero &&
        transactionInfo.hash == transactionInfo.merkleComponentHash;
  }

  /// Returns `true` if this transaction has missing signatures.
  bool hasMissingSignatures() {
    if (transactionInfo == null) {
      return false;
    }

    return transactionInfo.height != null &&
        transactionInfo.height.value == BigInt.zero &&
        transactionInfo.hash != transactionInfo.merkleComponentHash;
  }

  /// Returns `true` if this transaction is not yet known to the network.
  bool isNotPublished() {
    return transactionInfo == null;
  }

  /// Generates the hash for a serialized transaction payload.
  Uint8List createTransactionHash(final String transactionPayloadHex) {
    if (StringUtils.isEmpty(transactionPayloadHex)) {
      throw new ArgumentError('transaction payload must not be null or empty');
    }

    if (!HexUtils.isHexString(transactionPayloadHex)) {
      throw new ArgumentError('transaction payload is not a valid jext string');
    }

    return TransactionHelper.createTransactionHash(HexUtils.getBytes(transactionPayloadHex));
  }

  /// An abstract method to convert an aggregate transaction to an inner transaction including
  /// the given transaction signer.
  Transaction toAggregate(final PublicAccount signer);

  /// An abstract method to generate the transaction payload bytes.
  Uint8List generateBytes();

  /// Takes a transaction and formats the bytes to be included in an aggregate transaction.
  Uint8List toAggregateTransactionBytes() {
    final Uint8List bodyBytes = generateBytes();
    final Uint8List aggregateBytes = TransactionHelper.extractAggregatePart(bodyBytes);
    final Uint8List size = new Uint8List(aggregateBytes.length + 4);
    return new Uint8List.fromList(size.toList() + aggregateBytes.toList());
  }

  /// Serialize and sign transaction creating a new SignedTransaction.
  SignedTransaction signWith(final Account account) {
    final VerifiableTransaction tx = _buildTransaction();
    final String txSigned = tx.signTransaction(KeyPair.fromPrivateKey(account.privateKey));
    final String txHash = VerifiableTransaction.createTransactionHash(txSigned);

    return new SignedTransaction(txSigned, txHash, account.publicKey, transactionType, networkType);
  }

  // ------------------------------ private / protected functions ------------------------------ //

  VerifiableTransaction _buildTransaction();
}
