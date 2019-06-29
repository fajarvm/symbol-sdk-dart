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

import '../transaction/signed_transaction.dart';
import '../transaction/transaction.dart';
import 'address.dart';
import 'public_account.dart';

/// The account structure describes an account private key, public key, address and allows
/// signing transactions.
class Account {
  /// The key pair of the account which contains a public key and a private key.
  final KeyPair _keyPair;

  /// The public account.
  final PublicAccount _publicAccount;

  // private constructor
  Account._(this._keyPair, this._publicAccount);

  /// Retrieves the public key of this account.
  String get publicKey => HexUtils.getString(_keyPair.publicKey);

  /// Retrieves the private key of this account.
  String get privateKey => HexUtils.getString(_keyPair.privateKey);

  /// Retrieves the plain text address of this account.
  String get plainAddress => _publicAccount.address.plain;

  /// Retrieves the public account of this account.
  PublicAccount get publicAccount => _publicAccount;

  @override
  int get hashCode => _keyPair.hashCode ^ address.hashCode;

  @override
  bool operator ==(final other) =>
      identical(this, other) ||
      other is Account &&
          runtimeType == other.runtimeType &&
          _keyPair.publicKey == other._keyPair.publicKey &&
          plainAddress == other.plainAddress;

  /// Creates an [Account] from a given [privateKey] for a specific [networkType].
  static Account fromPrivateKey(final String privateKey, final int networkType) {
    final KeyPair keyPair = KeyPair.fromPrivateKey(privateKey);
    final Uint8List addressByte = Address.publicKeyToAddress(keyPair.publicKey, networkType);
    final String rawAddress = Address.addressToString(addressByte);
    final Address address = Address.fromRawAddress(rawAddress);

    return new Account._(address, keyPair);
  }

  /// Creates a new [Account] for the given [networkType].
  static Account create(final int networkType) {
    final KeyPair keyPair = KeyPair.random();
    final Address address =
        Address.fromPublicKey(HexUtils.getString(keyPair.publicKey), networkType);

    return new Account._(address, keyPair);
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
    return 'Account{address= $address, publicKey= $publicKey}';
  }
}
