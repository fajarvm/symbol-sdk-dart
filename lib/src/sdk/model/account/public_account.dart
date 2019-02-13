library nem2_sdk_dart.sdk.model.account.public_account;


import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/src/core/utils.dart' show HexUtils;

import 'address.dart';

/// The public account structure contains account's address and public key.
class PublicAccount {
  final Address _address;
  final String _publicKey;

  final int HASH512_LENGTH = 64;

  PublicAccount._(this._address, this._publicKey);

  factory PublicAccount({final Address address = null, final String publicKey = null}) {
    if (address == null || publicKey == null) {
      throw new ArgumentError(
          "A address and/or a publicKey must not be null to create a new PublicAccount.");
    }

    return new PublicAccount._(address, publicKey);
  }

  /// Create a [PublicAccount] from a [publicKey] for the given [networkType].
  static PublicAccount createFromPublicKey(final String publicKey, final int networkType) {
    if (publicKey == null || (64 != publicKey.length && 66 != publicKey.length)) {
      throw new ArgumentError('Not a valid public key');
    }

    final Address address = Address.createFromPublicKey(publicKey, networkType);
    return new PublicAccount(address: address, publicKey: publicKey);
  }

  /// Verifies a signature
  bool verifySignature(final String data, final String signature) {
    if (signature == null) {
      throw new ArgumentError('Missing signature argument');
    }
    if (HASH512_LENGTH != (signature.length / 2)) {
      throw new ArgumentError('Signature length is incorrect');
    }
    if (!HexUtils.isHexString(signature)) {
      throw new ArgumentError('Signature must be hexadecimal');
    }

    // TODO: COMPLETE
    final Uint8List signatureByte = HexUtils.getBytes(signature);

    return false;
  }
}
