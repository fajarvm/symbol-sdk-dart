library nem2_sdk_dart.core.crypto.key_pair;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/src/core/utils.dart' show HexUtils;

import 'crypto_exception.dart';
import 'ed25519.dart';

/// Represents a key pair.
class KeyPair {
  final Uint8List _privateKey;
  final Uint8List _publicKey;

  KeyPair._(this._privateKey, this._publicKey);

  factory KeyPair({Uint8List privateKey = null, Uint8List publicKey = null}) {
    if (privateKey == null) {
      throw new ArgumentError("privateKey byte cannot be null");
    }

    if (privateKey.lengthInBytes != 32 && privateKey.lengthInBytes != 33) {
      throw new ArgumentError("Invalid length for privateKey. Length: ${privateKey.lengthInBytes}");
    }

    return new KeyPair._(privateKey, publicKey);
  }

  /// Retrieves the public key of this key pair.
  Uint8List get publicKey => _publicKey;

  /// Retrieves the private key of this key pair.
  Uint8List get privateKey => _privateKey;

  @override
  int get hashCode {
    return privateKey.hashCode + publicKey.hashCode;
  }

  @override
  bool operator ==(other) {
    return other is KeyPair && publicKey == other.publicKey && privateKey == other.privateKey;
  }

  /// Creates a key pair from a [hexEncodedPrivateKey] string. The public key is extracted from
  /// the private key.
  ///
  /// Throws a [CryptoException] when the private key has an invalid length.
  static KeyPair fromPrivateKey(final String hexEncodedPrivateKey) {
    final Uint8List privateKeySeed = HexUtils.getBytes(hexEncodedPrivateKey);
    if (Ed25519.KEY_SIZE != privateKeySeed.length) {
      throw new CryptoException(
          "Private key has an unexpected size. Expected: ${Ed25519.KEY_SIZE}, Got: ${privateKeySeed.length}");
    }

    final Uint8List publicKey = Ed25519.extractPublicKey(privateKeySeed);

    return new KeyPair(privateKey: privateKeySeed, publicKey: publicKey);
  }

  /// Creates a random public key.
  static Uint8List randomPublicKey() {
    return Ed25519.getRandomBytes(Ed25519.KEY_SIZE);
  }

  /// Creates a random key pair.
  static KeyPair random() {
    return KeyPair.fromPrivateKey(
        HexUtils.getString(Ed25519.getRandomBytes(Ed25519.KEY_SIZE)));
  }

  /// Verifies that the [signature] is signed using the [publicKey] and the [data].
  static bool verify(final Uint8List publicKey, final Uint8List data, final Uint8List signature) {
    return Ed25519.verify(publicKey, data, signature);
  }

  /// Creates a shared key given a [keyPair], an arbitrary [publicKey] and an agreed upon [salt].
  /// This method returns a shared key. The shared key can be used for encrypted message passing
  /// between the two parties.
  static Uint8List deriveSharedKey(
      final KeyPair keyPair, final Uint8List publicKey, final Uint8List salt) {
    return Ed25519.deriveSharedKey(salt, keyPair.privateKey, publicKey);
  }

  /// Signs the [data] with the given [keyPair].
  static Uint8List signData(final KeyPair keyPair, final Uint8List data) {
    return Ed25519.signData(data, keyPair.publicKey, keyPair.privateKey);
  }
}
