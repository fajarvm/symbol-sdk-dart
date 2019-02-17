library nem2_sdk_dart.sdk.model.account.public_account;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/src/core/utils.dart' show HexUtils;
import 'package:nem2_sdk_dart/src/core/crypto.dart' show KeyPair;

import 'address.dart';

/// The public account structure contains account's address and public key.
class PublicAccount {
  final Address _address;
  final String _publicKey;

  final int HASH512_LENGTH = 64;

  const PublicAccount._(this._address, this._publicKey);

  factory PublicAccount({final Address address = null, final String publicKey = null}) {
    if (address == null || publicKey == null) {
      throw new ArgumentError(
          "A address and/or a publicKey must not be null to create a new PublicAccount.");
    }

    return new PublicAccount._(address, publicKey);
  }

  /// Retrieves the address of this public account.
  Address get address => _address;

  /// Retrieves the plain text address of this public account.
  String get plainAddress => _address.plain;

  /// Retrieves the public key of this public account.
  String get publicKey => _publicKey;

  @override
  int get hashCode {
    return (publicKey.hashCode + address.hashCode);
  }

  @override
  bool operator ==(final other) {
    return (other is PublicAccount) &&
        publicKey == other.publicKey &&
        plainAddress == other.plainAddress;
  }

  /// Create a [PublicAccount] from a [publicKey] for the given [networkType].
  static PublicAccount fromPublicKey(final String publicKey, final int networkType) {
    if (publicKey == null || (64 != publicKey.length && 66 != publicKey.length)) {
      throw new ArgumentError('Not a valid public key');
    }

    final Address address = Address.fromPublicKey(publicKey, networkType);
    return new PublicAccount(address: address, publicKey: publicKey);
  }

  /// Verifies a signature.
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

    final Uint8List sigByte = HexUtils.getBytes(signature);
    final String utf8Hex = HexUtils.utf8ToHex(data);
    final Uint8List dataByte = HexUtils.getBytes(utf8Hex);
    final Uint8List pkByte = HexUtils.getBytes(_publicKey);

    return KeyPair.verify(pkByte, dataByte, sigByte);
  }
}
