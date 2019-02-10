library nem2_sdk_dart.core.crypto.sha3_hasher;

import 'dart:typed_data' show Uint8List;

import 'sha3nist.dart';
import '../utils/hex_utils.dart';

// TODO: DELETE THIS CLASS.
// TODO: I don't think this class is needed. Just use the SHA3DigestNist directly?
class Sha3Hasher {
  final SHA3DigestNist _hasher;

  Sha3Hasher._(this._hasher);

//  factory Sha3Hasher({final int length = 64}) {
//    return createHasher(length: length);
//  }

  /// Calculate hash of the [data] and return the hash as result.
  /// The optional parameter [length] defines the hash length in bytes. It
  /// accepts an [int] value of 32 or 64. By default, the value is set to 64.
  static Uint8List hash(Uint8List data, {final int length = 64}) {
    final SHA3DigestNist digest = _getHasher(length: length);
    digest.reset();
    return digest.process(data);
  }

  static Sha3Hasher createHasher({final int length = 64}) {
    return Sha3Hasher._(_getHasher(length: length));
  }

  void reset() {
    this._hasher.reset();
  }

  void update(var data) {
    if (data is String) {
      final Uint8List byte = HexUtils.getBytes(data);
      this._hasher.update(byte, 0, 8);
    } else if (data is Uint8List) {
      this._hasher.update(data, 0, 8);
    } else {
      throw new ArgumentError('unsupported data type');
    }
  }

  void finalize(Uint8List result) {
    result = this._hasher.process(result);
  }

  // ------------------------------ private / protected functions ------------------------------ //

  static SHA3DigestNist _getHasher({final int length = 64}) {
    if (length == 64) {
      return new SHA3DigestNist(512);
    }

    if (length == 32) {
      return new SHA3DigestNist(256);
    }

    throw new ArgumentError('The length must either be 32 or 64. Found: ${length}');
  }
}
