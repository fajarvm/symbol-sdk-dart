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

import 'package:nem2_sdk_dart/core.dart' show HexUtils, KeyPair;

import '../blockchain/network_type.dart';
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

  /// The plain text address of this account.
  String get plainAddress => publicAccount.address.plain;

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
    final KeyPair keyPair = KeyPair.fromPrivateKey(privateKey);

    return fromKeyPair(keyPair, networkType);
  }

  /// Generates a new [Account] for the given [networkType].
  static Account generate(final NetworkType networkType) {
    final KeyPair random = KeyPair.random();
    return fromPrivateKey(HexUtils.getString(random.privateKey), networkType);
  }

  /// Signs raw data.
  String signData(final String rawData) {
    final String hex = HexUtils.utf8ToHex(rawData);
    final Uint8List data = HexUtils.getBytes(hex);
    final Uint8List signedData = KeyPair.signData(keyPair, data);
    return HexUtils.getString(signedData);
  }

  /// Signs a [transaction].
  SignedTransaction signTransaction(final Transaction transaction, final String generationHash) {
    return transaction.signWith(this, generationHash);
  }

  /// Sign transaction with cosignatories creating a new SignedTransaction.
  void signTransactionWithCosignatories() {
    // TODO: implement
  }

  /// Sign aggregate signature transaction.
  void signCosignatureTransaction() {
    // TODO: implement
  }

  @override
  String toString() {
    return 'Account{address= $plainAddress, publicKey= $publicKey}';
  }
}
