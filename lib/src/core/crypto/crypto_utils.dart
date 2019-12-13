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

library nem2_sdk_dart.core.crypto.ed25519;

import 'dart:typed_data' show Int64List, Uint8List;

import 'package:encrypt/encrypt.dart';
import 'package:nem2_sdk_dart/src/core/utils.dart';
import 'package:pointycastle/export.dart' show Digest, RIPEMD160Digest, SHA256Digest, SHA3Digest;

import 'catapultnacl.dart';
import 'crypto_exception.dart';
import 'sha3_hasher.dart';
import 'sign_schema.dart';

/// A utility class that provides various custom cryptographic operations.
class CryptoUtils {
  static const int BLOCK_SIZE = 16;
  static const int KEY_SIZE = 32;
  static const int SIGNATURE_SIZE = 64;
  static const int HALF_SIGNATURE_SIZE = 32;
  static const int HASH_SIZE = 64;
  static const int HALF_HASH_SIZE = 32;

  /// Encrypts a [message] with a shared key derived from [senderPrivateKey] and
  /// [recipientPublicKey]using the given [signSchema].
  ///
  /// By default, the [message] is considered a UTF-8 plain text.
  static String encryptMessage(final String message, final String senderPrivateKey,
      final String recipientPublicKey, final SignSchema signSchema,
      [final bool isHexMessage = false]) {
    ArgumentError.checkNotNull(message);
    ArgumentError.checkNotNull(senderPrivateKey);
    ArgumentError.checkNotNull(recipientPublicKey);
    ArgumentError.checkNotNull(signSchema);

    String payloadString = isHexMessage ? message : HexUtils.utf8ToHex(message);

    // AES encrypts
    final Uint8List salt = CryptoUtils.getRandomBytes(KEY_SIZE);
    final iv = IV(CryptoUtils.getRandomBytes(BLOCK_SIZE));
    final Uint8List senderByte = HexUtils.getBytes(senderPrivateKey);
    final Uint8List recipientByte = HexUtils.getBytes(recipientPublicKey);
    final Uint8List sharedKey =
        CryptoUtils.deriveSharedKey(salt, senderByte, recipientByte, signSchema);
    final Encrypter encrypter = Encrypter(AES(Key(sharedKey), mode: AESMode.cbc));
    final Uint8List payload = HexUtils.getBytes(payloadString);
    final encryptedMessage = encrypter.algo.encrypt(payload, iv: iv);

    // Creates a concatenated byte array as the encrypted payload
    // final Uint8List encryptedPayload = Uint8List.fromList(salt + iv.bytes + encryptedMessage.bytes);
    // final String result = HexUtils.bytesToHex(encryptedPayload);

    final result = HexUtils.bytesToHex(salt) +
        HexUtils.bytesToHex(iv.bytes) +
        HexUtils.bytesToHex(encryptedMessage.bytes);

    return result;
  }

  /// Decrypts an [encryptedMessage] with a shared key derived from [recipientPrivateKey] and
  /// [senderPublicKey] using the given [signSchema].
  ///
  /// Throws a [CryptoException] when decryption process fails.
  /// By default, the [message] is considered a UTF-8 plain text.
  static String decryptMessage(final String encryptedMessage, final String recipientPrivateKey,
      final String senderPublicKey, final SignSchema signSchema,
      [final bool isHexMessage = false]) {
    ArgumentError.checkNotNull(encryptedMessage);
    ArgumentError.checkNotNull(recipientPrivateKey);
    ArgumentError.checkNotNull(senderPublicKey);
    ArgumentError.checkNotNull(signSchema);

    if (encryptedMessage.length < (KEY_SIZE + BLOCK_SIZE)) {
      throw new ArgumentError('the encrypted payload has an incorrect size');
    }

    final Uint8List payloadBytes = HexUtils.getBytes(encryptedMessage);
    final Uint8List recipientByte = HexUtils.getBytes(recipientPrivateKey);
    final Uint8List senderByte = HexUtils.getBytes(senderPublicKey);
    final Uint8List salt = Uint8List.fromList(payloadBytes.take(KEY_SIZE).toList());
    final Uint8List iv = Uint8List.fromList(payloadBytes.skip(KEY_SIZE).take(BLOCK_SIZE).toList());

    final Uint8List encrypted = Uint8List.fromList(payloadBytes
        .skip(KEY_SIZE + BLOCK_SIZE)
        .take(payloadBytes.length - (KEY_SIZE + BLOCK_SIZE))
        .toList());

    try {
      final Uint8List sharedKey =
          CryptoUtils.deriveSharedKey(salt, recipientByte, senderByte, signSchema);

      final Encrypter encrypter = Encrypter(AES(Key(sharedKey), mode: AESMode.cbc));

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

  /// Extracts a public key from the given [privateKeySeed] using the given [signSchema].
  static Uint8List extractPublicKey(final Uint8List privateKeySeed, final SignSchema signSchema) {
    ArgumentError.checkNotNull(privateKeySeed);
    ArgumentError.checkNotNull(signSchema);

    if (privateKeySeed.lengthInBytes != 32 && privateKeySeed.lengthInBytes != 33) {
      throw new ArgumentError('Incorrect length of privateKeySeed');
    }

    final Uint8List d = prepareForScalarMult(privateKeySeed, signSchema);
    final List<Int64List> p = [_gf(), _gf(), _gf(), _gf()];
    final Uint8List pk = new Uint8List(KEY_SIZE);

    CatapultNacl.scalarBase(p, d, 0);
    CatapultNacl.pack(pk, p);

    return pk;
  }

  /// Signs a [message] with the given [publicKey] and [secretKey] according to [signSchema].
  static Uint8List signData(
      Uint8List message, Uint8List publicKey, Uint8List secretKey, SignSchema signSchema) {
    final Digest hasher = SHA3Hasher.create(signSchema, hashSize: HASH_SIZE);
    hasher.reset();

    final Uint8List d = new Uint8List(HASH_SIZE); // private hash
    hasher.update(secretKey, 0, KEY_SIZE);
    hasher.doFinal(d, 0);
    _clamp(d);

    final Uint8List r = new Uint8List(HASH_SIZE); // seeded hash
    hasher.reset();
    hasher.update(d.sublist(HALF_HASH_SIZE), 0, HALF_HASH_SIZE);
    hasher.update(message, 0, message.length);
    hasher.doFinal(r, 0);

    final List<Int64List> p = [_gf(), _gf(), _gf(), _gf()];
    final Uint8List signature = new Uint8List(SIGNATURE_SIZE);

    CatapultNacl.reduce(r);
    CatapultNacl.scalarBase(p, r, 0);
    CatapultNacl.pack(signature, p);

    final Uint8List h = new Uint8List(HASH_SIZE); // result
    hasher.reset();
    hasher.update(signature.sublist(0, HALF_SIGNATURE_SIZE), 0, HALF_SIGNATURE_SIZE);
    hasher.update(publicKey, 0, KEY_SIZE);
    hasher.update(message, 0, message.length);
    hasher.doFinal(h, 0);

    CatapultNacl.reduce(h);

    // muladd
    final Int64List x = new Int64List(HASH_SIZE);
    ArrayUtils.copy(x, r, numOfElements: HALF_HASH_SIZE);

    for (int i = 0; i < HALF_HASH_SIZE; i++) {
      for (int j = 0; j < HALF_HASH_SIZE; j++) {
        x[i + j] += h[i] * d[j];
      }
    }

    CatapultNacl.modL(signature, 32, x);

    // validate S part of Signature
    if (!_validateEncodedSPart(signature.sublist(HALF_SIGNATURE_SIZE))) {
      throw new CryptoException('The S part of the signature is invalid');
    }

    return signature;
  }

  /// Verifies that the [signature] is signed with the [publicKey], [data] and [signSchema].
  static bool verify(
      Uint8List publicKey, Uint8List data, Uint8List signature, SignSchema signSchema) {
    // reject non-canonical signature
    if (!_isCanonical(signature.sublist(HALF_SIGNATURE_SIZE))) {
      return false;
    }

    // reject weak (filled with zeros) public key
    if (ArrayUtils.isZero(publicKey)) {
      return false;
    }

    final List<Int64List> q = [_gf(), _gf(), _gf(), _gf()];

    if (0 != CatapultNacl.unpackNeg(q, publicKey)) {
      return false;
    }

    final Uint8List h = new Uint8List(HASH_SIZE);

    final Digest hasher = SHA3Hasher.create(signSchema, hashSize: SIGNATURE_SIZE);
    hasher.reset();
    hasher.update(signature.sublist(0, HALF_SIGNATURE_SIZE), 0, HALF_SIGNATURE_SIZE);
    hasher.update(publicKey, 0, KEY_SIZE);
    hasher.update(data, 0, data.length);
    hasher.doFinal(h, 0);

    final List<Int64List> p = [_gf(), _gf(), _gf(), _gf()];
    CatapultNacl.reduce(h);
    CatapultNacl.scalarMult(p, q, h, 0);

    final Uint8List t = new Uint8List(SIGNATURE_SIZE);
    CatapultNacl.scalarBase(q, signature.sublist(HALF_SIGNATURE_SIZE), 0);
    CatapultNacl.add(p, q);
    CatapultNacl.pack(t, p);

    final int result = CatapultNacl.cryptoVerify32(signature, t);
    return result == 0;
  }

  /// Derives a shared key using the [salt], [privateKey], [publicKey] and [signSchema].
  static Uint8List deriveSharedKey(final Uint8List salt, final Uint8List privateKey,
      final Uint8List publicKey, final SignSchema signSchema) {
    if (CryptoUtils.KEY_SIZE != salt.length) {
      throw ArgumentError('Salt has unexpected size: ${salt.length}');
    }

    if (CryptoUtils.KEY_SIZE != publicKey.length) {
      throw ArgumentError('Public key has unexpected size: ${publicKey.length}');
    }

    final Uint8List d = prepareForScalarMult(privateKey, signSchema);

    // sharedKey = pack(p = d (derived from sk) * q (derived from pk))
    final List<Int64List> q = [_gf(), _gf(), _gf(), _gf()];
    final List<Int64List> p = [_gf(), _gf(), _gf(), _gf()];
    final Uint8List sharedKey = new Uint8List(KEY_SIZE);
    CatapultNacl.unpackNeg(q, publicKey);
    CatapultNacl.scalarMult(p, q, d, 0);
    CatapultNacl.pack(sharedKey, p);

    // salt the shared key
    for (int i = 0; i < KEY_SIZE; i++) {
      sharedKey[i] ^= salt[i];
    }

    // return the hash of the result
    final Uint8List sharedKeyHash = SHA3Hasher.hash(sharedKey, signSchema, KEY_SIZE);
    return sharedKeyHash;
  }

  /// Creates random bytes with the given size.
  static Uint8List getRandomBytes(int size) => CatapultNacl.secureRandomBytes(size);

  /// Computes the hash of a [secretKey] using the given [signSchema].
  static Uint8List prepareForScalarMult(final Uint8List secretKey, final SignSchema signSchema) {
    final Uint8List d = SHA3Hasher.hash(secretKey, signSchema, HASH_SIZE);
    _clamp(d);
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

  // ------------------------------- private / protected functions ------------------------------ //

  static void _clamp(final Uint8List d) {
    d[0] &= 248;
    d[31] &= 127;
    d[31] |= 64;
  }

  static Int64List _gf({final Int64List init}) {
    final Int64List r = new Int64List(16);
    if (init != null) {
      for (int i = 0; i < init.length; i++) {
        r[i] = init[i];
      }
    }
    return r;
  }

  static bool _isCanonical(Uint8List input) {
    final Uint8List copy = new Uint8List(SIGNATURE_SIZE);
    ArrayUtils.copy(copy, input, numOfElements: HALF_SIGNATURE_SIZE);

    CatapultNacl.reduce(copy);
    return ArrayUtils.deepEqual(input, copy, numElementsToCompare: HALF_SIGNATURE_SIZE);
  }

  static bool _validateEncodedSPart(Uint8List s) => ArrayUtils.isZero(s) || _isCanonical(s);
}
