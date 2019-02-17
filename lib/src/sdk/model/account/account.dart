library nem2_sdk_dart.sdk.model.account.account;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/src/core/crypto.dart' show Ed25519, KeyPair, SHA3DigestNist;
import 'package:nem2_sdk_dart/src/core/utils.dart' show HexUtils;

import 'address.dart';
import 'public_account.dart';

/// The account structure describes an account private key, public key, address and allows
/// signing transactions.
class Account {
  final KeyPair _keyPair;
  final Address _address;

  const Account._(this._address, this._keyPair);

  factory Account({final Address address = null, final KeyPair keyPair = null}) {
    if (address == null || keyPair == null) {
      throw new ArgumentError(
          "A address and/or a keyPair must not be null to create a new Account.");
    }

    return new Account._(address, keyPair);
  }

  /// Retrieves the public key of this account.
  String get publicKey => HexUtils.getString(this._keyPair.publicKey);

  /// Retrieves the private key of this account.
  String get privateKey => HexUtils.getString(this._keyPair.privateKey);

  /// Retrieves the address of this account.
  Address get address => this._address;

  /// Retrieves the plain text address of this account.
  String get plainAddress => this._address.plain;

  /// Retrieves the public account of this account.
  PublicAccount get publicAccount =>
      PublicAccount.fromPublicKey(publicKey, address.networkType);

  @override
  int get hashCode {
    return this._keyPair.hashCode + this.address.hashCode;
  }

  @override
  bool operator ==(final other) {
    return other is Account &&
        this.plainAddress == other.plainAddress &&
        this.publicKey == other.publicKey;
  }

  /// Creates an [Account] from a given [privateKey] for a specific [networkType].
  static Account fromPrivateKey(final String privateKey, final int networkType) {
    final KeyPair keyPair = KeyPair.fromPrivateKey(privateKey);
    final Uint8List address = Address.publicKeyToAddress(keyPair.publicKey, networkType);
    final String rawAddress = Address.addressToString(address);

    return new Account(address: Address.fromRawAddress(rawAddress), keyPair: keyPair);
  }

  /// Creates a new [Account] for the given [networkType].
  static Account create(final int networkType) {
    final Uint8List randomBytes = Ed25519.getRandomBytes(Ed25519.KEY_SIZE);
    final Uint8List stepOne = new Uint8List(Ed25519.KEY_SIZE);
    final SHA3DigestNist sha3Digest = Ed25519.createSha3Hasher(length: 32);
    sha3Digest.update(randomBytes, 0, Ed25519.KEY_SIZE);
    sha3Digest.doFinal(stepOne, 0);

    final KeyPair keyPair = KeyPair.fromPrivateKey(HexUtils.getString(stepOne));
    final Address address =
        Address.fromPublicKey(HexUtils.getString(keyPair.publicKey), networkType);

    return new Account(address: address, keyPair: keyPair);
  }

  /// Signs raw data.
  String signData(final String rawData) {
    final String hexString = HexUtils.utf8ToHex(rawData);
    final Uint8List data = HexUtils.getBytes(hexString);
    final Uint8List signedData = KeyPair.signData(this._keyPair, data);
    return HexUtils.getString(signedData);
  }

  /// Signs a [transaction]
//  static SignedTransaction signTransaction(final Transaction transaction) {
//    return null;
//  }
}
