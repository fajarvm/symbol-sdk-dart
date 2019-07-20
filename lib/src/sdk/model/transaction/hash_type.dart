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

library nem2_sdk_dart.sdk.model.transaction.hash_type;

import 'package:nem2_sdk_dart/core.dart' show HexUtils;

/// The hash type.
class HashType {
  static const int _HASH_256_LENGTH = 64;
  static const int _RIPEMD_160_LENGTH = 40;

  static const String UNSUPPORTED_HASH_TYPE = 'unsupported hash type';

  /// SHA3-256 bit hash type.
  ///
  /// This is the default hash type.
  static const HashType SHA3_256 = HashType._(0);

  /// Keccak 256 bit hash type.
  ///
  /// For Ethereum (ETH) compatibility.
  static const HashType KECCAK_256 = HashType._(1);

  /// RIPEMD-160 hash type.
  ///
  /// RIPEMD-160 first with SHA-256 and then with RIPEMD-160 (Bitcoin BTC compatibility)).
  static const HashType RIPEMD_160 = HashType._(2);

  /// SHA 256 hash type.
  ///
  /// SHA-256 input is hashed twice with SHA-256 (Bitcoin BTC compatibility).
  static const HashType SHA_256 = HashType._(3);

  static final List<HashType> values = <HashType>[SHA3_256, KECCAK_256, RIPEMD_160, SHA_256];

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const HashType._(this.value);

  /// Returns a [HashType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static HashType getType(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNSUPPORTED_HASH_TYPE);
  }

  static bool validate(final String input, [final HashType hashType = HashType.SHA3_256]) {
    if (HexUtils.isHex(input)) {
      switch (hashType) {
        case SHA3_256:
        case SHA_256:
        case KECCAK_256:
          return input.length == _HASH_256_LENGTH;
        case RIPEMD_160:
          return input.length == _RIPEMD_160_LENGTH;
        default:
          break;
      }
    }

    return false;
  }
}
