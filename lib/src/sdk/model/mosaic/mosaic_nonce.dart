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
}
