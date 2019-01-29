library nem2_sdk_dart.core.crypto.sha3_hasher;

import 'dart:typed_data' show Uint8List;

import 'package:pointycastle/export.dart' show SHA3Digest;
import "package:nem2_sdk_dart/src/core/utils.dart" show ArrayUtils;

class Sha3Hasher {
  /// Calculate hash of the [data] and copied the result into [dest].
  /// The optional parameter [length] defines the hash length in bytes. It
  /// accepts an [int] value of 32 or 64. Default value is 64.
  static void hash(Uint8List dest, Uint8List data, {final int length = 64}) {
    final SHA3Digest digest = getHasher(length: length);
    digest.reset();
    final Uint8List source = digest.process(data);
    ArrayUtils.copy(dest, source);
  }

  // ------------------------------ private / protected functions ------------------------------ //

  static SHA3Digest getHasher({final int length = 64}) {
    if (length == 64) {
      return new SHA3Digest(512);
    }

    if (length == 32) {
      return new SHA3Digest(256);
    }

    throw new ArgumentError('The length must either be 32 or 64. Found: ${length}');
  }
}
