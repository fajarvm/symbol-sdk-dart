library nem2_sdk_dart.core.utils.crypto_utils;

import 'dart:typed_data' show Uint8List, Int64List, ByteBuffer;

import 'package:nem2_sdk_dart/src/core/crypto/tweetnacl.dart' as TweetNacl;

import '../crypto/sha3nist.dart';

/// A utility class that provides various functions for converting
/// one type of data to another
class CryptoUtils {
  static const int KEY_SIZE = 32;
  static const int SIGNATURE_SIZE = 64;
  static const int HALF_SIGNATURE_SIZE = 32;
  static const int EXPANDED_KEY_SIZE = 32 * 2;
  static const int HASH_SIZE = 64;
  static const int HALF_HASH_SIZE = 32;

  static Uint8List extractPublicKey(final Uint8List privateKeySeed) {
    if (privateKeySeed == null) {
      throw new ArgumentError('privateKeySeed may not be null');
    }
    if (privateKeySeed.lengthInBytes != 32 && privateKeySeed.lengthInBytes != 33) {
      throw new ArgumentError('Incorrect length of privateKeySeed');
    }

    final Uint8List d = prepareForScalarMult(privateKeySeed);
    List<Int64List> p = [gf(), gf(), gf(), gf()];
    final Uint8List pk = new Uint8List(KEY_SIZE);
    TweetNacl.TweetNaclFast.scalarbase(p, d, 0);
    TweetNacl.TweetNaclFast.pack(pk, p);

    return pk;
  }

  /// Decodes two hex characters into a byte.
  /// TODO: implement
  static int toByte(final String char1, final String char2) {
    final int byte = tryParseByte(char1, char2);

    return null;
  }

  /// Decodes two hex characters into a byte. Returns null.
  /// TODO: implement
  static int tryParseByte(final String char1, final String char2) {
    return null;
  }

  static prepareForScalarMult(final Uint8List sk) {
    final SHA3DigestNist sha3digest = new SHA3DigestNist(512);
    Uint8List hash = sha3digest.process(sk);
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
