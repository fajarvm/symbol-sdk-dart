//
// Copyright (c) 2020 Fajar van Megen
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

library symbol_sdk_dart.core.crypto.key_pair;

import 'dart:typed_data' show Uint8List;

import 'package:symbol_sdk_dart/src/core/utils.dart';

import 'crypto_exception.dart';
import 'crypto_utils.dart';
import 'sha3_hasher.dart';

/// Represents a key pair.
class KeyPair {
  /// The private key of this key pair.
  final Uint8List privateKey;

  /// The public key of this key pair.
  final Uint8List publicKey;

  // private constructor
  KeyPair._(this.privateKey, this.publicKey);

  // A private method that creates a new instance of [KeyPair].
  // Throws an error when [privateKey] has an unexpected length.
  static KeyPair _create(Uint8List privateKey, Uint8List publicKey) {
    ArgumentError.checkNotNull(privateKey);

    if (privateKey.lengthInBytes != 32 && privateKey.lengthInBytes != 33) {
      throw new ArgumentError('Invalid length for privateKey. Length: ${privateKey.lengthInBytes}');
    }

    return new KeyPair._(privateKey, publicKey);
  }

  @override
  int get hashCode => privateKey.hashCode ^ publicKey.hashCode;

  @override
  bool operator ==(final other) =>
      identical(this, other) ||
      other is KeyPair &&
          runtimeType == other.runtimeType &&
          ArrayUtils.deepEqual(privateKey, other.privateKey) &&
          ArrayUtils.deepEqual(publicKey, other.publicKey);

  /// Creates a key pair from a [hexEncodedPrivateKey].
  /// The public key is extracted from the private key.
  ///
  /// Throws a [CryptoException] when the private key has an invalid length.
  static KeyPair fromPrivateKey(final String hexEncodedPrivateKey) {
    final Uint8List privateKeySeed = HexUtils.getBytes(hexEncodedPrivateKey);
    if (CryptoUtils.KEY_SIZE != privateKeySeed.length) {
      throw new CryptoException('Private key has an unexpected size. '
          'Expected: ${CryptoUtils.KEY_SIZE}, Got: ${privateKeySeed.length}');
    }

    final Uint8List publicKey = CryptoUtils.extractPublicKey(privateKeySeed);

    return _create(privateKeySeed, publicKey);
  }

  /// Extract a public key byte from a [privateKeySeed].
  static Uint8List extractPublicKey(final Uint8List privateKeySeed) {
    return CryptoUtils.extractPublicKey(privateKeySeed);
  }

  /// Creates a random public key.
  static Uint8List randomPublicKey() {
    return CryptoUtils.getRandomBytes(CryptoUtils.KEY_SIZE);
  }

  /// Creates a random key pair based on the given [hashSize] (optional).
  /// By default, the [hashSize] is set to 32-bytes.
  static KeyPair random([final int hashSize = SHA3Hasher.HASH_SIZE_32_BYTES]) {
    final Uint8List randomBytes = CryptoUtils.getRandomBytes(hashSize);
    return KeyPair.fromPrivateKey(HexUtils.getString(randomBytes));
  }

  /// Signs the [data] with the given [keyPair].
  static Uint8List sign(final KeyPair keyPair, final Uint8List data) {
    final Uint8List secretKey = new Uint8List(64);
    secretKey.setAll(0, keyPair.privateKey);
    secretKey.setAll(32, keyPair.publicKey);
    return CryptoUtils.sign(data, keyPair.publicKey, secretKey);
  }

  /// Verifies that the [signature] is signed using the [publicKey] and the [data].
  static bool verify(final Uint8List publicKey, final Uint8List data, final Uint8List signature) {
    return CryptoUtils.verify(publicKey, data, signature);
  }
}
