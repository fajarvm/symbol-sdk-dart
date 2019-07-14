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

library nem2_sdk_dart.core.crypto.key_pair;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/src/core/utils.dart' show ArrayUtils, HexUtils;

import 'crypto_exception.dart';
import 'ed25519.dart';
import 'sha3nist.dart';

/// Represents a key pair.
class KeyPair {
  final Uint8List _privateKey;
  final Uint8List _publicKey;

  // private constructor
  KeyPair._(this._privateKey, this._publicKey);

  // A private method that creates a new instance of [KeyPair].
  // Throws an error when [privateKey] has an unexpected length.
  static KeyPair _create(Uint8List privateKey, Uint8List publicKey) {
    ArgumentError.checkNotNull(privateKey);

    if (privateKey.lengthInBytes != 32 && privateKey.lengthInBytes != 33) {
      throw new ArgumentError('Invalid length for privateKey. Length: ${privateKey.lengthInBytes}');
    }

    return new KeyPair._(privateKey, publicKey);
  }

  /// The public key of this key pair.
  Uint8List get publicKey => _publicKey;

  /// The private key of this key pair.
  Uint8List get privateKey => _privateKey;

  @override
  int get hashCode => _privateKey.hashCode ^ _publicKey.hashCode;

  @override
  bool operator ==(final other) =>
      identical(this, other) ||
      other is KeyPair &&
          runtimeType == other.runtimeType &&
          ArrayUtils.deepEqual(_privateKey, other.privateKey) &&
          ArrayUtils.deepEqual(_publicKey, other.publicKey);

  /// Creates a key pair from a [hexEncodedPrivateKey] string. The public key is extracted from
  /// the private key.
  ///
  /// Throws a [CryptoException] when the private key has an invalid length.
  static KeyPair fromPrivateKey(final String hexEncodedPrivateKey) {
    final Uint8List privateKeySeed = HexUtils.getBytes(hexEncodedPrivateKey);
    if (Ed25519.KEY_SIZE != privateKeySeed.length) {
      throw new CryptoException(
          'Private key has an unexpected size. Expected: ${Ed25519.KEY_SIZE}, Got: ${privateKeySeed.length}');
    }

    final Uint8List publicKey = Ed25519.extractPublicKey(privateKeySeed);

    return _create(privateKeySeed, publicKey);
  }

  /// Creates a random public key.
  static Uint8List randomPublicKey() {
    return Ed25519.getRandomBytes(Ed25519.KEY_SIZE);
  }

  /// Creates a random key pair.
  static KeyPair random() {
    final Uint8List randomBytes = Ed25519.getRandomBytes(Ed25519.KEY_SIZE);
    final Uint8List stepOne = new Uint8List(Ed25519.KEY_SIZE);
    final SHA3DigestNist sha3Digest = Ed25519.createSha3Digest(length: 32);
    sha3Digest.update(randomBytes, 0, Ed25519.KEY_SIZE);
    sha3Digest.doFinal(stepOne, 0);
    return KeyPair.fromPrivateKey(HexUtils.getString(stepOne));
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
