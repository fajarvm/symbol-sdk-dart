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

import 'package:nem2_sdk_dart/core.dart' show Ed25519, HexUtils;

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
  static MosaicNonce createRandom() {
    return new MosaicNonce(Ed25519.getRandomBytes(4));
  }

  /// Creates a MosaicNonce from a [hex] string.
  static MosaicNonce fromHex(final String hex) {
    if (!HexUtils.isHex(hex)) {
      throw new ArgumentError('invalid hex string');
    }

    return new MosaicNonce(HexUtils.getBytes(hex));
  }

  /// Returns the hex string representative of the nonce bytes.
  String toHex() {
    return HexUtils.getString(nonce);
  }

  // for internal use
  Uint8List toDTO() {
    return this.nonce;
  }
}
