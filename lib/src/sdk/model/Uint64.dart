library nem2_sdk_dart.sdk.model.uint64;

import 'dart:typed_data' show Uint8List;

import 'package:fixnum/fixnum.dart' show Int32, Int64;

// TODO: use BigInt or Int64 class instead?
/// An exact uint64 representation composed of two 32bit values.
class Uint64 {
  /// The low 32 bit value.
  final int _lower;

  /// The high 32 bit value.
  final int _higher;

  const Uint64._(this._lower, this._higher);

  factory Uint64(final List<int> uintArray) {
    if (2 != uintArray.length || uintArray[0] < 0 || uintArray[1] < 0) {
      throw new ArgumentError('uintArray must be an array of two uint numbers');
    }

    return new Uint64._(uintArray[0], uintArray[1]);
  }

  int get lower => _lower;

  int get higher => _higher;

//  static Int compact (final Uint64 uint64) {
//    if (0x00200000 <= uint64.higher) {
//      return uint64;
//    }
//  }
//
//  static readUint32At(final Uint8List bytes, final int i) {
//    return Int32(bytes[i] + (bytes[i + 1] << 8) + (bytes[i + 2] << 16) + (bytes[i + 3] << 24)).shiftRightUnsigned(0);
//  }

}
