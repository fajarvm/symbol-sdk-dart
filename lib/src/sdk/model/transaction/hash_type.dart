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
/// * 0: SHA3_512.
class HashType {
  static const int _SHA3_512_LENGTH = 128;

  /// SHA3 512 bit
  static const int SHA3_512 = 0;

  static final HashType singleton = new HashType._();

  HashType._();

  factory HashType() {
    return singleton;
  }

  static int getHashType(final int hashType) {
    switch (hashType) {
      case SHA3_512:
        return HashType.SHA3_512;
      default:
        throw new ArgumentError('invalid hash type');
    }
  }

  static bool validate(final String input, [final int hashType = HashType.SHA3_512]) {
    if (hashType == HashType.SHA3_512 && HexUtils.isHexString(input)) {
      return input.length == _SHA3_512_LENGTH;
    }

    return false;
  }
}
