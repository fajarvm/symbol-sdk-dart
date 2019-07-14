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
import 'package:nem2_sdk_dart/sdk.dart';

import '../transaction/signed_transaction.dart';
import '../transaction/transaction.dart';
import 'public_account.dart';

/// The account structure describes an account private key, public key, address and allows
/// signing transactions.
class Account {
  final KeyPair _keyPair;
  final PublicAccount _publicAccount;

  // private constructor
  Account._(this._keyPair, this._publicAccount);

  /// The public key string of this account.
  String get publicKey => HexUtils.getString(_keyPair.publicKey);

  /// The private key string of this account.
  String get privateKey => HexUtils.getString(_keyPair.privateKey);

  /// The plain text address of this account.
  String get plainAddress => _publicAccount.address.plain;

  /// The public account of this account.
  PublicAccount get publicAccount => _publicAccount;

  /// The keyPair containing the public and private key of this account.
  KeyPair get keyPair => _keyPair;

  @override
  int get hashCode => _keyPair.hashCode ^ _publicAccount.hashCode;

  @override
  bool operator ==(final other) =>
      identical(this, other) ||
      other is Account &&
          runtimeType == other.runtimeType &&
          _keyPair.publicKey == other._keyPair.publicKey &&
          plainAddress == other.plainAddress;

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

  /// Creates a new [Account] for the given [networkType].
  static Account create(final NetworkType networkType) {
    final KeyPair random = KeyPair.random();
    return fromPrivateKey(HexUtils.getString(random.privateKey), networkType);
  }

  /// Signs raw data.
  String signData(final String rawData) {
    final String hex = HexUtils.utf8ToHex(rawData);
    final Uint8List data = HexUtils.getBytes(hex);
    final Uint8List signedData = KeyPair.signData(_keyPair, data);
    return HexUtils.getString(signedData);
  }

  /// Signs a [transaction].
  SignedTransaction signTransaction(final Transaction transaction) {
    return transaction.signWith(this);
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
