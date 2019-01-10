library nem2_sdk_dart.sdk.model.account.public_account;

import 'address.dart';

/// The public account structure contains account's address and public key.
class PublicAccount {
  final Address _address;
  final String _publicKey;

  PublicAccount(this._address, this._publicKey);
}
