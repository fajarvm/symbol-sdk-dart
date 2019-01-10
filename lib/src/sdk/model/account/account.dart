library nem2_sdk_dart.sdk.model.account.account;

import 'public_account.dart';
import '../blockchain/network_type.dart';

/// The account structure describes an account private key, public key,
/// address and allows signing transactions.
class Account {
  final String _keyPair;
  final PublicAccount _publicAccount;

  Account._(this._keyPair, this._publicAccount);

  factory Account(
      {final String privateKey = null, final NetworkType networkType = null}) {
    if (networkType == null) {
      throw new ArgumentError("A networkType must not be null");
    }

    if (privateKey != null) {
      // const KeyPair keyPair = KeyPair.
    }

    throw new ArgumentError(
        "A privateKey and/or a networkType must not be null to create a new Account.");
  }
}
