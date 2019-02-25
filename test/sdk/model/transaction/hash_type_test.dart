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

library nem2_sdk_dart.test.sdk.model.transaction.hash_type_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show Ed25519, HexUtils;
import 'package:nem2_sdk_dart/sdk.dart' show HashType;

void main() {
  group('HashType', () {
    test('valid hash types', () {
      expect(HashType.SHA3_512, 0);
    });

    test('Can retrieve valid hash types', () {
      expect(HashType.getHashType(0), HashType.SHA3_512);
    });

    test('Trying to retrieve an invalid namespace type will throw an error', () {
      expect(() => HashType.getHashType(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'invalid hash type')));
      expect(() => HashType.getHashType(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'invalid hash type')));
      expect(() => HashType.getHashType(2),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'invalid hash type')));
    });

    test('The hash of SHA3_512 should be exactly  128 chars long', () {
      // SHA3-512 = valid
      final sha512digest = Ed25519.createSha3Hasher(length: 64);
      final result512 = sha512digest.process(HexUtils.getBytes(HexUtils.utf8ToHex('abcxyz')));
      expect(HashType.validate(HexUtils.getString(result512)), isTrue);

      // SHA3-256 = invalid
      final sha256digest = Ed25519.createSha3Hasher(length: 32);
      final result256 = sha256digest.process(HexUtils.getBytes(HexUtils.utf8ToHex('abcxyz')));
      expect(HashType.validate(HexUtils.getString(result256)), isFalse);

      // invalid hash string
      const invalid = 'zyz6053bb910a6027f138ac5ebe92d43a9a18b7239b3c4d5ea69f1632e50aeef28184e46cd2'
          '2ded096b766318580a569e74521a9d63885cc8d5e8644793be928';
      expect(HashType.validate(invalid), isFalse);
    });
  });
}
