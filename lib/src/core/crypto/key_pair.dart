library nem2_sdk_dart.core.crypto.key_pair;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/core.dart'
    show CryptoUtils, CryptoException, HexUtils;

/// Represents a key pair
class KeyPair {
  final Uint8List _privateKey;
  final Uint8List _publicKey;

  KeyPair._(this._privateKey, this._publicKey);

  /// Factory method to create a key pair
  factory KeyPair({Uint8List privateKey = null, Uint8List publicKey = null}) {
    // TODO: complete

    return new KeyPair._(privateKey, publicKey);

    /// unreachable code
    // throw new StateError("Illegal state");
  }

  /// Gets the public key
  Uint8List get publicKey => _publicKey;

  /// Gets the private key
  Uint8List get privateKey => _privateKey;

  /// Creates a key pair from a [hexEncodedPrivateKey] string.
  static KeyPair createFromPrivateKeyString(final String hexEncodedPrivateKey) {
    final Uint8List privateKeySeed = HexUtils.getBytes(hexEncodedPrivateKey);
    if (CryptoUtils.KEY_SIZE != privateKeySeed.length) {
      throw new CryptoException(
          "Private key has unexpected size: ${privateKeySeed.length}");
    }

    final Uint8List publicKey = CryptoUtils.extractPublicKey(privateKeySeed);

    return new KeyPair(privateKey: privateKeySeed, publicKey: publicKey);
  }

  /// Signs a data buffer with a key pair.
  static Uint8List sign(final KeyPair keyPair, final Uint8List data) {
    return null;
  }

  /// Verifies a signature.
  static bool verify(final Uint8List publicKey, final Uint8List data,
      final Uint8List signature) {
    return false;
  }

  static Uint8List deriveSharedKey(
      final KeyPair keyPair, final Uint8List publicKey, final Uint8List salt) {
    return null;
  }
}
