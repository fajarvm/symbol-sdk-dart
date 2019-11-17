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

library nem2_sdk_dart.core.crypto.sha3_hasher;

import 'dart:typed_data' show ByteBuffer, Uint8List;

import 'package:pointycastle/api.dart' show Digest;

import 'ed25519.dart';
import 'sign_schema.dart';

/// This class creates a cryptographic SHA-3 / Keccak hasher based on the given [SignSchema]
/// and hash size (32 byte or 256-bit, 64 byte or 512-bit).
class SHA3Hasher {
  /// Creates the correct SHA-3 hasher for the given [signSchema] and [hashSize].
  ///
  /// Default value for [hashSize] is 64 bytes. Acceptable [hashSize] is either 32 or 64 bytes.
  static Digest create(final SignSchema signSchema,
      {final int hashSize = SignSchema.HASH_SIZE_64_BYTES}) {
    _validate(signSchema, hashSize);

    if (SignSchema.SHA3.value == signSchema.value) {
      return Ed25519.createSha3Digest(length: hashSize);
    }

    if (SignSchema.KECCAK.value == signSchema.value) {
      return Ed25519.createKeccakDigest(length: hashSize);
    }

    throw new StateError('should not reach here');
  }

  /// Hashes the [input] bytes using the given [signSchema] and [hashSize].
  ///
  /// Default value for [hashSize] is 64 bytes. Acceptable [hashSize] is either 32 or 64 bytes.
  static Uint8List toHash(final Uint8List input, final SignSchema signSchema,
      [final int hashSize = SignSchema.HASH_SIZE_64_BYTES]) {
    _validate(signSchema, hashSize);

    final Digest hasher = create(signSchema, hashSize: hashSize);

    // reverse the input here when necessary before processing it further

    // processes the input and then returns the result
    final Uint8List hash = hasher.process(input);
    final ByteBuffer buffer = hash.buffer;
    final Uint8List result = buffer.asUint8List(0, hashSize);
    return result;
  }

  // ------------------------------- private / protected functions ------------------------------ //

  static void _validate(final SignSchema signSchema, final int hashSize) {
    if (!SignSchema.isValid(signSchema, hashSize)) {
      throw new ArgumentError('Invalid sign schema and hash size combination. '
          'Sign schema: $signSchema, Hash size: $hashSize');
    }
  }
}
