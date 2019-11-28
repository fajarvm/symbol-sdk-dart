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

library nem2_sdk_dart.sdk.model.account.account;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/core.dart' show HexUtils, KeyPair, SignSchema;

import '../blockchain/network_type.dart';
import '../message/encrypted_message.dart';
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
  String get publicKey => HexUtils.getString(keyPair.publicKey);

  /// The private key string of this account.
  String get privateKey => HexUtils.getString(keyPair.privateKey);

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
    final String publicKey = HexUtils.getString(keyPair.publicKey);
    final PublicAccount publicAccount = PublicAccount.fromPublicKey(publicKey, networkType);

    return new Account._(keyPair, publicAccount);
  }

  /// Creates an [Account] from a given [privateKey] for a specific [networkType].
  static Account fromPrivateKey(final String privateKey, final NetworkType networkType) {
    ArgumentError.checkNotNull(privateKey);
    final SignSchema signSchema = NetworkType.resolveSignSchema(networkType);
    final KeyPair keyPair = KeyPair.fromPrivateKey(privateKey, signSchema);

    return fromKeyPair(keyPair, networkType);
  }

  /// Generates a new [Account] for the given [networkType].
  static Account generate(final NetworkType networkType) {
    final SignSchema signSchema = NetworkType.resolveSignSchema(networkType);
    final KeyPair random = KeyPair.random(signSchema);
    return fromPrivateKey(HexUtils.getString(random.privateKey), networkType);
  }

  /// Signs raw data.
  String signData(final String rawData) {
    final String hex = HexUtils.utf8ToHex(rawData);
    final Uint8List data = HexUtils.getBytes(hex);
    final SignSchema signSchema = NetworkType.resolveSignSchema(networkType);
    final Uint8List signedData = KeyPair.signData(keyPair, data, signSchema);
    return HexUtils.getString(signedData);
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

  /// Creates a new encrypted message with this account as a sender.
  EncryptedMessage encryptMessage(final String plainTextMessage,
      final PublicAccount recipientPublicAccount, final NetworkType networkType) {
    return EncryptedMessage.create(
        plainTextMessage, this.privateKey, recipientPublicAccount.publicKey, networkType);
  }

  /// Decrypts an encrypted message sent for this account.
  String decryptMessage(final EncryptedMessage encryptedMessage,
      final PublicAccount senderPublicAccount, final NetworkType networkType) {
    return encryptedMessage.decrypt(this.privateKey, senderPublicAccount.publicKey, networkType);
  }

  @override
  String toString() {
    return 'Account{address= $plainAddress, publicKey= $publicKey}';
  }
}
