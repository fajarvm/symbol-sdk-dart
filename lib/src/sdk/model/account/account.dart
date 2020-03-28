//
// Copyright (c) 2020 Fajar van Megen
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

library symbol_sdk_dart.sdk.model.account.account;

import 'dart:typed_data' show Uint8List;

import 'package:symbol_sdk_dart/core.dart' show ByteUtils, HexUtils, KeyPair;

import '../message/encrypted_message.dart';
import '../message/plain_message.dart';
import '../network/network_type.dart';
import '../transaction/signed_transaction.dart';
import '../transaction/transaction.dart';
import 'public_account.dart';

/// The account structure describes an account private key, public key, address and allows
/// signing transactions.
class Account {
  /// The keyPair containing the public and private key of this account.
  final KeyPair keyPair;

  /// The public account of this account.
  final PublicAccount publicAccount;

  // private constructor
  Account._(this.keyPair, this.publicAccount);

  /// The public key string of this account.
  String get publicKey => ByteUtils.bytesToHex(keyPair.publicKey);

  /// The private key string of this account.
  String get privateKey => ByteUtils.bytesToHex(keyPair.privateKey);

  /// The encoded address of this account.
  String get encodedAddress => publicAccount.address.encoded;

  /// The plain text address of this account.
  String get plainAddress => publicAccount.address.plain;

  /// The network type of this account.
  NetworkType get networkType => publicAccount.address.networkType;

  @override
  int get hashCode => keyPair.hashCode ^ publicAccount.hashCode;

  @override
  bool operator ==(final other) =>
      identical(this, other) ||
      other is Account &&
          this.runtimeType == other.runtimeType &&
          this.publicKey == other.publicKey &&
          this.plainAddress == other.plainAddress;

  /// Creates an [Account] from a given [keyPair] for a specific [networkType].
  static Account fromKeyPair(final KeyPair keyPair, final NetworkType networkType) {
    final String publicKey = ByteUtils.bytesToHex(keyPair.publicKey);
    final PublicAccount publicAccount = PublicAccount.fromPublicKey(publicKey, networkType);

    return new Account._(keyPair, publicAccount);
  }

  /// Creates an [Account] from a given [privateKey] for a specific [networkType].
  static Account fromPrivateKey(final String privateKey, final NetworkType networkType) {
    ArgumentError.checkNotNull(privateKey);
    final KeyPair keyPair = KeyPair.fromPrivateKey(privateKey);

    return fromKeyPair(keyPair, networkType);
  }

  /// Generates a new [Account] for the given [networkType].
  static Account generate(final NetworkType networkType) {
    final KeyPair random = KeyPair.random();
    return fromPrivateKey(HexUtils.getString(random.privateKey), networkType);
  }

  /// Creates an encrypted message from this account to the [recipientPublicAccount].
  EncryptedMessage encryptMessage(
      final String plainTextMessage, final PublicAccount recipientPublicAccount) {
    return EncryptedMessage.create(
        plainTextMessage, this.privateKey, recipientPublicAccount.publicKey);
  }

  /// Decrypts an encrypted message received by this account from [senderPublicAccount].
  PlainMessage decryptMessage(
      final EncryptedMessage encryptedMessage, final PublicAccount senderPublicAccount) {
    return EncryptedMessage.decrypt(
        encryptedMessage, this.privateKey, senderPublicAccount.publicKey);
  }

  /// Signs raw data.
  String signData(final String rawData) {
    final String hex = HexUtils.utf8ToHex(rawData);
    final Uint8List data = ByteUtils.hexToBytes(hex);
    final Uint8List signedData = KeyPair.sign(keyPair, data);
    return ByteUtils.bytesToHex(signedData);
  }

  /// Signs a [transaction].
  SignedTransaction signTransaction(final Transaction transaction, final String generationHash) {
    ArgumentError.checkNotNull(transaction);
    ArgumentError.checkNotNull(generationHash);

    return transaction.signWith(this, generationHash);
  }

  // TODO: implement

  /// Sign transaction with cosignatories creating a new SignedTransaction.
  void signTransactionWithCosignatories() {}

  /// Sign aggregate signature transaction.
  void signCosignatureTransaction() {}

  @override
  String toString() {
    return 'Account{address= $plainAddress, publicKey= $publicKey}';
  }
}
