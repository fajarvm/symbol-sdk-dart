//
// Copyright (c) 2020 Fajar van Megen
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

library symbol_sdk_dart.core.crypto.sha3_hasher;

import 'dart:typed_data' show Uint8List;

import 'package:pointycastle/api.dart' show Digest;

import 'crypto_utils.dart';

/// This class creates a cryptographic SHA-3/Keccak hasher (32 byte or 256-bit, 64 byte or 512-bit).
class SHA3Hasher {
  /// Hash size: 32 bytes / 256 bits.
  static const int HASH_SIZE_32_BYTES = 32;

  /// Hash size: 64 bytes / 512 bits.
  static const int HASH_SIZE_64_BYTES = 64;

  // private constructor
  const SHA3Hasher._();

  /// Creates and validates the correct SHA-3 hasher for the given [hashSize] (optional).
  ///
  /// Default value for [hashSize] is 64 bytes. Acceptable [hashSize] is either 32 or 64 bytes.
  static Digest create([final int hashSize = HASH_SIZE_64_BYTES]) {
    _validate(hashSize);

    return CryptoUtils.createSha3Digest(length: hashSize);
  }

  /// Hashes the [input] bytes using the given [hashSize] (optional).
  ///
  /// Default value for [hashSize] is 64 bytes. Acceptable [hashSize] is either 32 or 64 bytes.
  static Uint8List hash(final Uint8List input, [final int hashSize = HASH_SIZE_64_BYTES]) {
    _validate(hashSize);

    final Digest hasher = create(hashSize);

    // reverse the input here when necessary before processing it further

    // process the input and then return the result
    final Uint8List hash = hasher.process(input);
    return hash.buffer.asUint8List(0, hashSize);
  }

  // ------------------------------- private / protected functions ------------------------------ //

  static void _validate(final int hashSize) {
    if (HASH_SIZE_32_BYTES != hashSize && HASH_SIZE_64_BYTES != hashSize) {
      throw new ArgumentError('Invalid hash size: $hashSize');
    }
  }
}
