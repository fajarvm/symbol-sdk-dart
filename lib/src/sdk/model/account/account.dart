library nem2_sdk_dart.sdk.model.account.account;

import 'package:nem2_sdk_dart/src/core/crypto.dart' show KeyPair;

import 'address.dart';
import 'public_account.dart';
import '../blockchain/network_type.dart';

/// The account structure describes an account private key, public key,
/// address and allows signing transactions.
class Account {
  final KeyPair _keyPair;
  final Address _address;

  Account._(this._address, this._keyPair);

  factory Account(
      {final Address address = null, final KeyPair keyPair = null}) {
    if (address == null || keyPair == null) {
      throw new ArgumentError(
          "A address and/or a keyPair must not be null to create a new Account.");
    }

    return new Account._(address, keyPair);
  }

  /// Creates an Account from a the [privateKey] string for a specific [networkType]
  static Account createFromPrivateKey(
      final String privateKey, final NetworkType networkType) {
    final KeyPair keyPair = KeyPair.createFromPrivateKeyString(privateKey);
    final String rawAddress = Address.addressToString(
        Address.publicKeyToAddress(keyPair.publicKey, networkType));

    return new Account(
        address: Address.createFromRawAddress(rawAddress), keyPair: keyPair);
  }
}
