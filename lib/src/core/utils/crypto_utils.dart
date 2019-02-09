library nem2_sdk_dart.core.utils.crypto_utils;

import 'dart:typed_data' show ByteBuffer, Int64List, Uint8List;

import '../crypto/crypto_exception.dart';
import '../crypto/key_pair.dart';
import '../crypto/sha3nist.dart';
import '../crypto/tweetnacl.dart' as TweetNacl;

import '../utils/hex_utils.dart';
import '../utils/array_utils.dart';

/// A utility class that provides various custom cryptographic operations
class CryptoUtils {
  static const int KEY_SIZE = 32;
  static const int SIGNATURE_SIZE = 64;
  static const int HALF_SIGNATURE_SIZE = 32;
  static const int HASH_SIZE = 64;
  static const int HALF_HASH_SIZE = 32;

  /// Extracts a public key bytes from the given [privateKeySeed] bytes
  static Uint8List extractPublicKey(final Uint8List privateKeySeed) {
    if (privateKeySeed == null) {
      throw new ArgumentError('privateKeySeed may not be null');
    }
    if (privateKeySeed.lengthInBytes != 32 && privateKeySeed.lengthInBytes != 33) {
      throw new ArgumentError('Incorrect length of privateKeySeed');
    }

    final Uint8List d = prepareForScalarMult(privateKeySeed);
    final List<Int64List> p = [gf(), gf(), gf(), gf()];
    final Uint8List pk = new Uint8List(KEY_SIZE);
    TweetNacl.TweetNaclFast.scalarbase(p, d, 0);
    TweetNacl.TweetNaclFast.pack(pk, p);

    return pk;
  }

  static Uint8List sign(Uint8List message, Uint8List publicKey, Uint8List secretKey) {
    final SHA3DigestNist hasher = new SHA3DigestNist(512);
    hasher.reset();

    final Uint8List d = new Uint8List(HASH_SIZE); // private hash
    hasher.update(secretKey, 0, KEY_SIZE);
    hasher.doFinal(d, 0);
    clamp(d);

    final Uint8List r = new Uint8List(HASH_SIZE); // seeded hash
    hasher.reset();
    hasher.update(d, 32, HALF_HASH_SIZE);
    hasher.update(message, 0, message.length);
    hasher.doFinal(r, 0);

    final List<Int64List> p = [gf(), gf(), gf(), gf()];
    final Uint8List signature = new Uint8List(SIGNATURE_SIZE);

    TweetNacl.TweetNaclFast.reduce(r);
    TweetNacl.TweetNaclFast.scalarbase(p, r, 0);
    TweetNacl.TweetNaclFast.pack(signature, p);

    final Uint8List h = new Uint8List(HASH_SIZE); // result
    hasher.reset();
    hasher.update(signature, 0, HALF_SIGNATURE_SIZE);
    hasher.update(publicKey, 0, KEY_SIZE);
    hasher.update(message, 0, message.length);
    hasher.doFinal(h, 0);

    TweetNacl.TweetNaclFast.reduce(h);

    // muladd
    final Int64List x = new Int64List(HASH_SIZE);
    ArrayUtils.copy(x, r, numElementsToCopy: HALF_HASH_SIZE);

    for (int i = 0; i < HALF_HASH_SIZE; i++) {
      for (int j = 0; j < HALF_HASH_SIZE; j++) {
        x[i + j] += h[i] * d[j];
      }
    }

    TweetNacl.TweetNaclFast.modL(signature.sublist(HALF_SIGNATURE_SIZE), 0, x);

    // validate S part of Signature
    validateEncodedSPart(signature.sublist(HALF_SIGNATURE_SIZE));

    return signature;
  }

  static void validateEncodedSPart(Uint8List s) {
    if (ArrayUtils.isZero(s)) {
      return;
    }

    final Uint8List copy = new Uint8List(SIGNATURE_SIZE);
    ArrayUtils.copy(copy, s, numElementsToCopy: HALF_SIGNATURE_SIZE);

    TweetNacl.TweetNaclFast.reduce(copy);
    if (ArrayUtils.deepEqual(s, copy, numElementsToCompare: HALF_SIGNATURE_SIZE)) {
      return;
    }

    throw new CryptoException('The S part of the signature is invalid');
  }

  /// Creates random bytes with the given size
  static Uint8List getRandomBytes(int size) {
    return TweetNacl.TweetNaclFast.randombytes(size);
  }

  /// Creates a random public key
  static Uint8List createRandomPublicKey() {
    return getRandomBytes(KEY_SIZE);
  }

  /// Creates a random ley pair
  static KeyPair createRandomKeyPair() {
    return KeyPair.createFromPrivateKeyString(HexUtils.getString(getRandomBytes(32)));
  }

  /// Decodes two hex characters into a byte.
  /// TODO: implement
  static int toByte(final String char1, final String char2) {
    // final int byte = tryParseByte(char1, char2);
    return null;
  }

  /// Decodes two hex characters into a byte. Returns null.
  /// TODO: implement
  static int tryParseByte(final String char1, final String char2) {
    return null;
  }

  /// Computes the hash of a [secretKey] using SHA3-512 (NIST) algorithm
  static prepareForScalarMult(final Uint8List secretKey) {
    final SHA3DigestNist sha3digest = new SHA3DigestNist(512);
    Uint8List hash = sha3digest.process(secretKey);
    final ByteBuffer buffer = hash.buffer;
    final Uint8List d = buffer.asUint8List(0, HASH_SIZE);
    clamp(d);
    return d;
  }

  static void clamp(final Uint8List d) {
    d[0] &= 248;
    d[31] &= 127;
    d[31] |= 64;
  }

  static Int64List gf({final Int64List init = null}) {
    final Int64List r = new Int64List(16);
    if (init != null) {
      for (int i = 0; i < init.length; i++) {
        r[i] = init[i];
      }
    }
    return r;
  }

  static void wipe(Uint8List byte) {
    for (int i = 0; i < byte.length; i++) {
      byte[i] = 0;
    }
  }
}
