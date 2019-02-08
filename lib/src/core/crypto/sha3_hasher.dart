library nem2_sdk_dart.core.crypto.sha3_hasher;

import 'dart:typed_data' show Uint8List;

import 'sha3nist.dart';

class Sha3Hasher {
  /// Calculate hash of the [data] and return the hash as result.
  /// The optional parameter [length] defines the hash length in bytes. It
  /// accepts an [int] value of 32 or 64. By default, the value is set to 64.
  static Uint8List hash(Uint8List data, {final int length = 64}) {
    final SHA3DigestNist digest = getHasher(length: length);
    digest.reset();
    return digest.process(data);
  }

  // ------------------------------ private / protected functions ------------------------------ //

  static SHA3DigestNist getHasher({final int length = 64}) {
    if (length == 64) {
      return new SHA3DigestNist(512);
    }

    if (length == 32) {
      return new SHA3DigestNist(256);
    }

    throw new ArgumentError('The length must either be 32 or 64. Found: ${length}');
  }
}
