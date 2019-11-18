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

library nem2_sdk_dart.sdk.model.mosaic.mosaic_nonce;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/core.dart' show CryptoUtils, HexUtils;

import '../common/uint64.dart';

/// The mosaic nonce structure.
class MosaicNonce {
  static const int NONCE_SIZE = 4;

  /// The nonce.
  final Uint8List nonce;

  MosaicNonce._(this.nonce);

  factory MosaicNonce(final Uint8List nonce) {
    if (nonce == null || NONCE_SIZE != nonce.length) {
      throw new ArgumentError('Invalid nonce size. The nonce should be $NONCE_SIZE bytes.');
    }

    return new MosaicNonce._(nonce);
  }

  /// Creates a random MosaicNonce.
  static MosaicNonce random() {
    return MosaicNonce(CryptoUtils.getRandomBytes(4));
  }

  /// Creates a MosaicNonce from a [hex] string.
  static MosaicNonce fromHex(final String hex) {
    if (!HexUtils.isHex(hex)) {
      throw new ArgumentError('invalid hex string');
    }

    return MosaicNonce(HexUtils.getBytes(hex));
  }

  /// Creates a [MosaicNonce] from a [Uint64] value.
  static MosaicNonce fromUint64(final Uint64 uint64) {
    List<int> intArray = uint64.toIntArray();
    int lower = intArray[0];
    Uint8List bytes = _intToBytes(lower);

    return MosaicNonce._(bytes);
  }

  /// Converts the nonce bytes to a hex string.
  String toHex() {
    return HexUtils.getString(nonce);
  }

  /// Converts the nonce bytes to a 32-bit [int] value.
  int toInt() {
    return _bytesToInt(nonce);
  }

  // for internal use
  Uint8List toDTO() {
    return this.nonce;
  }

  // ------------------------------- private / protected functions ------------------------------ //

  static Uint8List _intToBytes(int value) {
    List<int> result = List<int>(4);
    result[0] = value & 0xff;
    result[1] = (value >> 8) & 0xff;
    result[2] = (value >> 16) & 0xff;
    result[3] = (value >> 24) & 0xff;
    return Uint8List.fromList(result);
  }

  static int _bytesToInt(Uint8List bytes) {
    int lower = bytes[3] & 0xff;
    lower <<= 8;
    lower |= bytes[2] & 0xff;
    lower <<= 8;
    lower |= bytes[1] & 0xff;
    lower <<= 8;
    lower |= bytes[0] & 0xff;
    return lower;
  }
}
