library nem2_sdk_dart.core.crypto.ed25519;

import 'dart:typed_data' show ByteBuffer, Int64List, Uint8List;

import 'package:nem2_sdk_dart/src/core/utils.dart' show ArrayUtils;

import 'crypto_exception.dart';
import 'sha3nist.dart';
import 'tweetnacl.dart' as TweetNacl;

/// This class provides various custom cryptographic operations.
class Ed25519 {
  static const int KEY_SIZE = 32;
  static const int SIGNATURE_SIZE = 64;
  static const int HALF_SIGNATURE_SIZE = 32;
  static const int HASH_SIZE = 64;
  static const int HALF_HASH_SIZE = 32;

  /// Extracts a public key from the given [privateKeySeed].
  static Uint8List extractPublicKey(final Uint8List privateKeySeed) {
    if (privateKeySeed == null) {
      throw new ArgumentError('privateKeySeed may not be null');
    }
    if (privateKeySeed.lengthInBytes != 32 && privateKeySeed.lengthInBytes != 33) {
      throw new ArgumentError('Incorrect length of privateKeySeed');
    }

    final Uint8List d = prepareForScalarMult(privateKeySeed);
    final List<Int64List> p = [_gf(), _gf(), _gf(), _gf()];
    final Uint8List pk = new Uint8List(KEY_SIZE);
    TweetNacl.TweetNaclFast.scalarbase(p, d, 0);
    TweetNacl.TweetNaclFast.pack(pk, p);

    return pk;
  }

  /// Signs a [message] with the given [publicKey] and [secretKey].
  static Uint8List signData(Uint8List message, Uint8List publicKey, Uint8List secretKey) {
    final SHA3DigestNist hasher = createSha3Hasher();
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

    TweetNacl.TweetNaclFast.reduce(r);
    TweetNacl.TweetNaclFast.scalarbase(p, r, 0);
    TweetNacl.TweetNaclFast.pack(signature, p);

    final Uint8List h = new Uint8List(HASH_SIZE); // result
    hasher.reset();
    hasher.update(signature.sublist(0, HALF_SIGNATURE_SIZE), 0, HALF_SIGNATURE_SIZE);
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

    TweetNacl.TweetNaclFast.modL(signature, 32, x);

    // validate S part of Signature
    if (!_validateEncodedSPart(signature.sublist(HALF_SIGNATURE_SIZE))) {
      throw new CryptoException('The S part of the signature is invalid');
    }

    return signature;
  }

  /// Verifies that the [signature] is signed with the [publicKey] and [data].
  static bool verify(Uint8List publicKey, Uint8List data, Uint8List signature) {
    // reject non-canonical signature
    if (!_isCanonical(signature.sublist(HALF_SIGNATURE_SIZE))) {
      return false;
    }

    // reject weak (filled with zeros) public key
    if (ArrayUtils.isZero(publicKey)) {
      return false;
    }

    final List<Int64List> q = [_gf(), _gf(), _gf(), _gf()];

    if (0 != TweetNacl.TweetNaclFast.unpackneg(q, publicKey)) {
      return false;
    }

    final Uint8List h = new Uint8List(HASH_SIZE);

    final SHA3DigestNist hasher = createSha3Hasher();
    hasher.reset();
    hasher.update(signature.sublist(0, HALF_SIGNATURE_SIZE), 0, HALF_SIGNATURE_SIZE);
    hasher.update(publicKey, 0, KEY_SIZE);
    hasher.update(data, 0, data.length);
    hasher.doFinal(h, 0);

    final List<Int64List> p = [_gf(), _gf(), _gf(), _gf()];
    TweetNacl.TweetNaclFast.reduce(h);
    TweetNacl.TweetNaclFast.scalarmult(p, q, h, 0);

    final Uint8List t = new Uint8List(SIGNATURE_SIZE);
    TweetNacl.TweetNaclFast.scalarbase(q, signature.sublist(HALF_SIGNATURE_SIZE), 0);
    TweetNacl.TweetNaclFast.add(p, q);
    TweetNacl.TweetNaclFast.pack(t, p);

    int result = TweetNacl.TweetNaclFast.crypto_verify_32(signature, t);
    return result == 0;
  }

  /// Derives a shared key using the [salt], [privateKey] and [publicKey].
  static Uint8List deriveSharedKey(
      final Uint8List salt, final Uint8List privateKey, final Uint8List publicKey) {
    if (Ed25519.KEY_SIZE != salt.length) {
      throw ArgumentError('Salt has unexpected size: ${salt.length}');
    }

    final Uint8List d = prepareForScalarMult(privateKey);

    // sharedKey = pack(p = d (derived from sk) * q (derived from pk))
    final List<Int64List> q = [_gf(), _gf(), _gf(), _gf()];
    final List<Int64List> p = [_gf(), _gf(), _gf(), _gf()];
    final Uint8List sharedKey = new Uint8List(KEY_SIZE);
    TweetNacl.TweetNaclFast.unpackneg(q, publicKey);
    TweetNacl.TweetNaclFast.scalarmult(p, q, d, 0);
    TweetNacl.TweetNaclFast.pack(sharedKey, p);

    // salt the shared key
    for (int i = 0; i < KEY_SIZE; i++) {
      sharedKey[i] ^= salt[i];
    }

    // return the hash of the result
    final SHA3DigestNist hasher = createSha3Hasher(length: KEY_SIZE);
    Uint8List hash = hasher.process(sharedKey);
    final ByteBuffer buffer = hash.buffer;
    final Uint8List result = buffer.asUint8List(0, KEY_SIZE);
    return result;
  }

  /// Creates random bytes with the given size.
  static Uint8List getRandomBytes(int size) {
    return TweetNacl.TweetNaclFast.randombytes(size);
  }

  /// Computes the hash of a [secretKey] using SHA3-512 (NIST) algorithm.
  static prepareForScalarMult(final Uint8List secretKey) {
    final SHA3DigestNist sha3digest = createSha3Hasher();
    Uint8List hash = sha3digest.process(secretKey);
    final ByteBuffer buffer = hash.buffer;
    final Uint8List d = buffer.asUint8List(0, HASH_SIZE);
    _clamp(d);
    return d;
  }

  /// Wipes the value of given [byte].
  static void wipe(Uint8List byte) {
    for (int i = 0; i < byte.length; i++) {
      byte[i] = 0;
    }
  }

  static SHA3DigestNist createSha3Hasher({final int length = 64}) {
    if (length != 64 && length != 32) {
      throw ArgumentError('Cannot create SHA3 hasher. Unexpected length: ${length}');
    }

    return 64 == length ? new SHA3DigestNist(512) : new SHA3DigestNist(256);
  }

  // ------------------------------- private / protected functions ------------------------------ //

  static void _clamp(final Uint8List d) {
    d[0] &= 248;
    d[31] &= 127;
    d[31] |= 64;
  }

  static Int64List _gf({final Int64List init = null}) {
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
    ArrayUtils.copy(copy, input, numElementsToCopy: HALF_SIGNATURE_SIZE);

    TweetNacl.TweetNaclFast.reduce(copy);
    return ArrayUtils.deepEqual(input, copy, numElementsToCompare: HALF_SIGNATURE_SIZE);
  }

  static bool _validateEncodedSPart(Uint8List s) {
    return ArrayUtils.isZero(s) || _isCanonical(s);
  }
}
