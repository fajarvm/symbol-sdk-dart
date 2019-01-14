library nem2_sdk_dart.core.utils.crypto_utils;

import 'dart:typed_data' show Uint8List, Int64List;
import 'package:nem2_sdk_dart/src/core/crypto/nacl.dart';

/// A utility class that provides various functions for converting
/// one type of data to another
class CryptoUtils {
  static const int KEY_SIZE = 32;
  static const int SIGNATURE_SIZE = 64;
  static const int HALF_SIGNATURE_SIZE = 32;
  static const int HASH_SIZE = 64;
  static const int HALF_HASH_SIZE = 32;

  static Uint8List extractPublicKey(final Uint8List sk) {
    Uint8List d = prepareForScalarMult(sk);
    List<Int64List> p = [gf(), gf(), gf(), gf()];
    Uint8List pk = new Uint8List(KEY_SIZE);
    Nacl.scalarbase(p, d, 0);
    Nacl.pack(pk, p);
    return pk;
  }

  /// Decodes two hex characters into a byte.
  static int toByte(final String char1, final String char2) {
    final int byte = tryParseByte(char1, char2);

    return null;
  }

  /// Decodes two hex characters into a byte. Returns null.
  static int tryParseByte(final String char1, final String char2) {
    return null;
  }

  static prepareForScalarMult(final Uint8List sk) {
    final Uint8List d = new Uint8List(HASH_SIZE);
    Nacl.crypto_hash(d, sk);
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
}
