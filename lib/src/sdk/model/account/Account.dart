part of nem2_sdk_dart.sdk.model.account;

/**
 * The account structure describes an account private key, public key, address and allows signing transactions.
 */
class Account {
  final KeyPair _keyPair;
  final PublicAccount _publicAccount;

  Account(this._keyPair, this._publicAccount){

  }
}