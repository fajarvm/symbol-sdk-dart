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

library nem2_sdk_dart.core.crypto.sign_schema;

import 'dart:typed_data' show ByteBuffer, Uint8List;

import 'package:pointycastle/api.dart' show Digest;

import 'package:nem2_sdk_dart/src/core/utils.dart' show HexUtils;

import 'crypto_exception.dart';
import 'ed25519.dart';

/// The sign schema enum defines the strategies that can be used when signing
/// and generating public addresses.
class SignSchema {
  static const String UNSUPPORTED_SIGN_SCHEMA = 'unsupported sign schema';

  /// Hash size: 32 bytes / 256 bits.
  static const int HASH_SIZE_32_BYTES = 32;

  /// Hash size: 64 bytes / 512 bits.
  static const int HASH_SIZE_64_BYTES = 64;

  /// SHA3 hash algorithm without key reversal.
  static const SignSchema SHA3 = SignSchema._(1);

  /// Keccak hash algorithm without key reversal.
  static const SignSchema KECCAK = SignSchema._(2);

  /// Supported restriction types.
  static final List<SignSchema> values = <SignSchema>[SHA3, KECCAK];

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const SignSchema._(this.value);

  /// Returns a [SignSchema] for the given int value.
  ///
  /// Throws an error when the sign schema is unsupported.
  static SignSchema fromInt(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNSUPPORTED_SIGN_SCHEMA);
  }

  static void _validate(SignSchema signSchema, int hashSize) {
    if (!values.contains(signSchema)) {
      throw new ArgumentError('Unsupported SignSchema: $signSchema');
    }
    if (HASH_SIZE_32_BYTES != hashSize && HASH_SIZE_64_BYTES != hashSize) {
      throw new ArgumentError('Unsupported hash size: $hashSize');
    }
  }

  /// Retrieves the correct SHA3 hasher for the given [signSchema] and [hashSize].
  ///
  /// Default value for [hashSize] is 64 bytes.
  /// Acceptable [hashSize] is either [HASH_SIZE_32_BYTES] or [HASH_SIZE_64_BYTES].
  static Digest getHasher(SignSchema signSchema, {final int hashSize = HASH_SIZE_64_BYTES}) {
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
  /// Default value for [hashSize] is 64 bytes.
  /// Acceptable [hashSize] is either [HASH_SIZE_32_BYTES] or [HASH_SIZE_64_BYTES].
  static Uint8List toHash(Uint8List input, SignSchema signSchema,
      [final int hashSize = HASH_SIZE_64_BYTES]) {
    _validate(signSchema, hashSize);

    final Digest hasher = getHasher(signSchema, hashSize: hashSize);

    // reverse the input here when necessary before processing it further

    // processes the input and then returns the result
    final Uint8List hash = hasher.process(input);
    final ByteBuffer buffer = hash.buffer;
    final Uint8List result = buffer.asUint8List(0, hashSize);
    return result;
  }

  /// Returns the reversed order of the given [input] bytes.
  static Uint8List reverseBytes(Uint8List input) {
    return Uint8List.fromList(input.reversed.toList());
  }

  /// Returns the reversed order of the given [input] hex string.
  static String reverseHexString(String input) {
    try {
      return HexUtils.getString(reverseBytes(HexUtils.getBytes(input)));
    } catch (e) {
      throw CryptoException('Failed reversing the input. Error: $e');
    }
  }
}
