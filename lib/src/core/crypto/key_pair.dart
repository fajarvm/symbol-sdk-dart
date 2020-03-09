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

import 'package:pointycastle/api.dart' show Digest;

import 'crypto_exception.dart';
import 'crypto_utils.dart';
import 'sha3_hasher.dart';
import 'sign_schema.dart';

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

  /// Creates a key pair from a [hexEncodedPrivateKey] string using the given [signSchema].
  /// The public key is extracted from the private key.
  ///
  /// Throws a [CryptoException] when the private key has an invalid length.
  static KeyPair fromPrivateKey(final String hexEncodedPrivateKey, final SignSchema signSchema) {
    ArgumentError.checkNotNull(signSchema);

    final Uint8List privateKeySeed = HexUtils.getBytes(hexEncodedPrivateKey);
    if (CryptoUtils.KEY_SIZE != privateKeySeed.length) {
      throw new CryptoException('Private key has an unexpected size. '
          'Expected: ${CryptoUtils.KEY_SIZE}, Got: ${privateKeySeed.length}');
    }

    final Uint8List publicKey = CryptoUtils.extractPublicKey(privateKeySeed, signSchema);

    return _create(privateKeySeed, publicKey);
  }

  /// Extract a public key byte from a [privateKeySeed] using a given [signSchema].
  static Uint8List extractPublicKey(final Uint8List privateKeySeed, final SignSchema signSchema) {
    return CryptoUtils.extractPublicKey(privateKeySeed, signSchema);
  }

  /// Creates a random public key.
  static Uint8List randomPublicKey() {
    return CryptoUtils.getRandomBytes(CryptoUtils.KEY_SIZE);
  }

  /// Creates a random key pair based on the given [signSchema] and, optionally, [hashSize].
  /// By default, the [hashSize] is set to 32-bytes.
  static KeyPair random(final SignSchema signSchema,
      [final int hashSize = SignSchema.HASH_SIZE_32_BYTES]) {
    final Digest hasher = SHA3Hasher.create(signSchema, hashSize: hashSize);

    final Uint8List randomBytes = CryptoUtils.getRandomBytes(hashSize);
    final Uint8List stepOne = new Uint8List(hashSize);
    hasher.update(randomBytes, 0, hashSize);
    hasher.doFinal(stepOne, 0);
    return KeyPair.fromPrivateKey(HexUtils.getString(stepOne), signSchema);
  }

  /// Verifies that the [signature] is signed using the [publicKey] and the [data] according to
  /// the [signSchema].
  static bool verify(final Uint8List publicKey, final Uint8List data, final Uint8List signature,
      final SignSchema signSchema) {
    return CryptoUtils.verify(publicKey, data, signature, signSchema);
  }

  /// Creates a shared key given a [keyPair], an arbitrary [publicKey] and an agreed upon [salt]
  /// using the cryptography algorithm defined in [signSchema]
  /// This method returns a shared key. The shared key can be used for encrypted message passing
  /// between the two parties.
  static Uint8List deriveSharedKey(final KeyPair keyPair, final Uint8List publicKey,
      final Uint8List salt, final SignSchema signSchema) {
    return CryptoUtils.deriveSharedKey(salt, keyPair.privateKey, publicKey, signSchema);
  }

  /// Signs the [data] with the given [keyPair] according to the [signSchema].
  static Uint8List signData(
      final KeyPair keyPair, final Uint8List data, final SignSchema signSchema) {
    return CryptoUtils.signData(data, keyPair.publicKey, keyPair.privateKey, signSchema);
  }
}
