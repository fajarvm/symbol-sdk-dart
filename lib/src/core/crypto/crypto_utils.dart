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

library symbol_sdk_dart.core.crypto.ed25519;

import 'dart:typed_data' show Int64List, Uint8List;

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/export.dart'
    show HKDFKeyDerivator, HkdfParameters, RIPEMD160Digest, SHA256Digest, SHA3Digest, SHA512Digest;
import 'package:symbol_sdk_dart/src/core/utils.dart' show ByteUtils, HexUtils;
import 'package:tweetnacl/tweetnacl.dart' as tweetnacl;

import 'catapult_nacl.dart';
import 'crypto_exception.dart';

/// A utility class that provides various custom cryptographic operations.
class CryptoUtils {
  static const int IV_SIZE = 16;
  static const int KEY_SIZE = 32;
  static const int SIGNATURE_SIZE = 64;
  static const int HALF_SIGNATURE_SIZE = 32;
  static const int HASH_SIZE = 64;
  static const int HALF_HASH_SIZE = 32;

  /// Encrypts a [message] with a shared key derived from [senderPrivateKey] and
  /// [recipientPublicKey].
  ///
  /// By default, the [message] is considered a UTF-8 plain text.
  static String encryptMessage(
      final String message, final String senderPrivateKey, final String recipientPublicKey,
      [final bool isHexMessage = false]) {
    ArgumentError.checkNotNull(message);
    ArgumentError.checkNotNull(senderPrivateKey);
    ArgumentError.checkNotNull(recipientPublicKey);

    String msg = isHexMessage ? message : HexUtils.utf8ToHex(message);

    // Derive shared key
    final Uint8List senderByte = ByteUtils.hexToBytes(senderPrivateKey);
    final Uint8List recipientByte = ByteUtils.hexToBytes(recipientPublicKey);
    final Uint8List sharedKey = CryptoUtils.deriveSharedKey(senderByte, recipientByte);

    // Setup IV
    final IV iv = IV(CryptoUtils.getRandomBytes(IV_SIZE));

    // Setup AES cipher in CBC mode with PKCS7 padding
    final Encrypter encrypter = Encrypter(AES(Key(sharedKey), mode: AESMode.cbc, padding: 'PKCS7'));
    final Uint8List payload = ByteUtils.hexToBytes(msg);
    final encryptedMessage = encrypter.algo.encrypt(payload, iv: iv);

    // Creates a concatenated byte array as the encrypted payload
    final result = ByteUtils.bytesToHex(iv.bytes) + ByteUtils.bytesToHex(encryptedMessage.bytes);

    return result;
  }

  /// Decrypts an [encryptedMessage] with a shared key derived from [recipientPrivateKey] and
  /// [senderPublicKey].
  ///
  /// Throws a [CryptoException] when decryption process fails.
  /// By default, the [message] is considered a UTF-8 plain text.
  static String decryptMessage(
      final String encryptedMessage, final String recipientPrivateKey, final String senderPublicKey,
      [final bool isHexMessage = false]) {
    ArgumentError.checkNotNull(encryptedMessage);
    ArgumentError.checkNotNull(recipientPrivateKey);
    ArgumentError.checkNotNull(senderPublicKey);

    if (encryptedMessage.length < KEY_SIZE) {
      throw new ArgumentError('the encrypted payload has an incorrect size');
    }

    final Uint8List payloadBytes = HexUtils.getBytes(encryptedMessage);
    final Uint8List iv = Uint8List.fromList(payloadBytes.take(IV_SIZE).toList());
    final Uint8List encrypted = Uint8List.fromList(payloadBytes.skip(IV_SIZE).toList());

    try {
      // Derive shared key
      final Uint8List recipientByte = ByteUtils.hexToBytes(recipientPrivateKey);
      final Uint8List senderByte = ByteUtils.hexToBytes(senderPublicKey);
      final Uint8List sharedKey = CryptoUtils.deriveSharedKey(recipientByte, senderByte);

      final Encrypter encrypter =
          Encrypter(AES(Key(sharedKey), mode: AESMode.cbc, padding: 'PKCS7'));

      final encryptedValue = Encrypted(encrypted);
      final ivValue = IV(iv);
      final decryptBytes = encrypter.decryptBytes(encryptedValue, iv: ivValue);
      final String decrypted = HexUtils.getString(decryptBytes);

      // dev note: Use HexUtils for converting hex instead of using the hex converter from
      // encrypt lib or any third party converter libs.
      final String result = isHexMessage ? decrypted : HexUtils.tryHexToUtf8(decrypted);

      return result;
    } catch (e) {
      throw new CryptoException('Failed to decrypt message');
    }
  }

  /// Extracts a public key from the given [privateKeySeed].
  static Uint8List extractPublicKey(final Uint8List privateKeySeed) {
    ArgumentError.checkNotNull(privateKeySeed);

    if (privateKeySeed.lengthInBytes != 32 && privateKeySeed.lengthInBytes != 33) {
      throw new ArgumentError('Incorrect length of privateKeySeed');
    }

    return tweetnacl.Signature.keyPair_fromSeed(privateKeySeed).publicKey;
  }

  /// Signs a [message] with the given [publicKey] and [secretKey].
  static Uint8List sign(Uint8List message, Uint8List publicKey, Uint8List secretKey) {
    return tweetnacl.Signature(publicKey, secretKey).detached(message);
  }

  /// Verifies that the [signature] is signed with the [publicKey], and [data].
  static bool verify(Uint8List publicKey, Uint8List data, Uint8List signature) {
    final tweetnacl.Signature sign = tweetnacl.Signature(publicKey, null);
    return sign.detached_verify(data, signature);
  }

  /// Derives a shared key using the [privateKey] and [publicKey].
  static Uint8List deriveSharedKey(final Uint8List privateKey, final Uint8List publicKey) {
    final Uint8List sharedSecret = deriveSharedSecret(privateKey, publicKey);
    final Uint8List sharedKey = sha256ForSharedKey(sharedSecret);

    return sharedKey;
  }

  /// Derives a shared secret using the [privateKey] and [publicKey].
  static Uint8List deriveSharedSecret(final Uint8List privateKey, final Uint8List publicKey) {
    if (CryptoUtils.KEY_SIZE != publicKey.length) {
      throw ArgumentError('Public key has unexpected size: ${publicKey.length}');
    }

    Uint8List d = prepareForScalarMult(privateKey);

    // sharedKey = pack(p = d (derived from privateKey) * q (derived from publicKey))
    List<Int64List> q = [gf(), gf(), gf(), gf()];
    List<Int64List> p = [gf(), gf(), gf(), gf()];
    Uint8List sharedSecret = new Uint8List(KEY_SIZE);

    CatapultNacl.unpack(q, publicKey);
    CatapultNacl.scalarmult(p, q, d, 0);
    CatapultNacl.pack(sharedSecret, p);

    return sharedSecret;
  }

  /// Returns the shared key from a [sharedSecret] for Catapult using SHA-256 HKDF function.
  static Uint8List sha256ForSharedKey(Uint8List sharedSecret) {
    // return the key resulted from the HKDF (SHA-256)
    final Uint8List info = HexUtils.utf8ToByte('catapult');
    final Uint8List sharedKey = new Uint8List(KEY_SIZE);

    final HKDFKeyDerivator hkdf = new HKDFKeyDerivator(new SHA256Digest());
    final HkdfParameters params = new HkdfParameters(sharedSecret, KEY_SIZE, null, info);
    hkdf.init(params);
    hkdf.deriveKey(null, 0, sharedKey, 0);

    return sharedKey;
  }

  /// Creates random bytes with the given size.
  static Uint8List getRandomBytes(int size) => CatapultNacl.secureRandomBytes(size);

  /// Computes the hash of a [secretKey] for scalar multiplication.
  static Uint8List prepareForScalarMult(final Uint8List secretKey) {
    final Uint8List hash = SHA512Digest().process(secretKey);
    final List<int> d = Uint8List.fromList(hash.buffer.asUint8List(0, 32));

    clamp(d);

    return d;
  }

  /// Wipes the value of given [byte].
  static void wipe(Uint8List byte) {
    for (int i = 0; i < byte.length; i++) {
      byte[i] = 0;
    }
  }

  /// Creates a non-Keccak SHA3 256/512 digest based on the given bit [length].
  ///
  /// Providing bit length 32 returns the non-Keccak SHA3-256.
  /// Providing bit length 64 returns the non-Keccak SHA3-512. (Default return value)
  static SHA3Digest createSha3Digest({final int length = 64}) {
    if (length != 64 && length != 32) {
      throw ArgumentError('Cannot create SHA3 hasher. Unexpected length: $length');
    }

    return 64 == length ? new SHA3Digest(512, false) : new SHA3Digest(256, false);
  }

  /// Creates a Keccak 256/512 digest based on the given bit [length].
  ///
  /// Providing bit length 32 returns the Keccak-256.
  /// Providing bit length 64 returns the Keccak-512. (Default return value)
  static SHA3Digest createKeccakDigest({final int length = 64}) {
    if (length != 64 && length != 32) {
      throw ArgumentError('Cannot create Keccak hasher. Unexpected length: $length');
    }

    return 64 == length ? new SHA3Digest(512) : new SHA3Digest(256);
  }

  /// Creates a SHA-256 digest.
  static SHA256Digest createSha256Digest() {
    return new SHA256Digest();
  }

  /// Creates a RIPEMD-160 digest.
  static RIPEMD160Digest createRipemd160Digest() {
    return new RIPEMD160Digest();
  }

  static void clamp(final Uint8List d) {
    d[0] &= 248;
    d[31] &= 127;
    d[31] |= 64;
  }

  static Int64List gf([final Int64List init]) {
    return CatapultNacl.gf(init);
  }
}
