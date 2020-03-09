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

library symbol_sdk_dart.core.crypto.sign_schema;

/// The sign schema enum defines the strategies that can be used when signing
/// and generating public addresses.
class SignSchema {
  static const String UNSUPPORTED_SIGN_SCHEMA = 'unsupported sign schema';

  /// Hash size: 32 bytes / 256 bits.
  static const int HASH_SIZE_32_BYTES = 32;

  /// Hash size: 64 bytes / 512 bits.
  static const int HASH_SIZE_64_BYTES = 64;

  /// Keccak hash algorithm without key reversal.
  static const SignSchema KECCAK = SignSchema._(1);

  /// SHA3 hash algorithm without key reversal.
  static const SignSchema SHA3 = SignSchema._(2);

  /// Supported restriction types.
  static final List<SignSchema> values = <SignSchema>[KECCAK, SHA3];

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

  /// Validates the given [signSchema] and [hashSize] combination.
  ///
  /// Valid hash algorithm and hash size combinations:
  /// * SHA-3 32-bytes (256-bit)
  /// * SHA-3 64-bytes (512-bit)
  /// * KECCAK 32-bytes (256-bit)
  /// * KECCAK 64-bytes (512-bit)
  static bool isValid(SignSchema signSchema, int hashSize) {
    return values.contains(signSchema) &&
        (HASH_SIZE_32_BYTES == hashSize || HASH_SIZE_64_BYTES == hashSize);
  }

  @override
  String toString() {
    return 'SignSchema{value: $value}';
  }
}
