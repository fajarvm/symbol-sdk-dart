library nem2_sdk_dart.core.utils.crypto_utils;

import 'dart:typed_data' show Uint8List;

/// A utility class that provides various functions for converting
/// one type of data to another
class CryptoUtils {
  static const int KEY_SIZE = 32;
  static const int SIGNATURE_SIZE = 64;
  static const int HALF_SIGNATURE_SIZE = 32;
  static const int HASH_SIZE = 64;
  static const int HALF_HASH_SIZE = 32;

  static Uint8List extractPublicKey(final Uint8List privateKey) {
//    var c = _nacl_catapult2.default.catapult;
//    var d = prepareForScalarMult(sk, hashfunc);
//
//    var p = [c.gf(), c.gf(), c.gf(), c.gf()];
//    var pk = new Uint8List(KEY_SIZE);
//    c.scalarbase(p, d);
//    c.pack(pk, p);
//    return pk;
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
}