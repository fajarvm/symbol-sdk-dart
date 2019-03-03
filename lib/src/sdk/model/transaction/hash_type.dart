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
///
/// Supported hash types are:
/// * 0: SHA3_256 (default).
/// * 1: KECCAK_256 (Ethereum ETH compatibility).
/// * 2: RIPEMD_160 first with SHA-256 and then with RIPEMD-160 (Bitcoin BTC compatibility)).
/// * 3: SHA_256 input is hashed twice with SHA-256 (Bitcoin BTC compatibility).
class HashType {
  static const int _HASH_256_LENGTH = 64;
  static const int _RIPEMD_160_LENGTH = 40;

  /// SHA3-256 bit.
  ///
  /// This is the default hash type.
  static const int SHA3_256 = 0;

  /// Keccak 256
  ///
  /// For Ethereum (ETH) compatibility.
  static const int KECCAK_256 = 1;

  /// RIPEMD-160
  ///
  /// For Bitcoin (BTC) compatibility.
  static const int RIPEMD_160 = 2;

  /// SHA 256
  ///
  /// For Bitcoin (BTC) compatibility.
  static const int SHA_256 = 3;

  static final HashType _singleton = new HashType._();

  HashType._();

  factory HashType() {
    return _singleton;
  }

  static int getHashType(final int hashType) {
    switch (hashType) {
      case SHA3_256:
        return HashType.SHA3_256;
      case KECCAK_256:
        return HashType.KECCAK_256;
      case RIPEMD_160:
        return HashType.RIPEMD_160;
      case SHA_256:
        return HashType.SHA_256;
      default:
        throw new ArgumentError('invalid hash type');
    }
  }

  static bool validate(final String input, [final int hashType = HashType.SHA3_256]) {
    if (HexUtils.isHexString(input)) {
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
