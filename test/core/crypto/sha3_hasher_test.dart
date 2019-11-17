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

library nem2_sdk_dart.test.core.crypto.sha3_hasher_test;

import 'dart:typed_data';

import 'package:pointycastle/export.dart' show Digest;

import 'package:nem2_sdk_dart/core.dart' show HexUtils, SHA3Hasher, SignSchema;
import 'package:test/test.dart';

void main() {
  group('SHA3Hasher', () {
    group('create()', () {
      test('SHA3 (NIST) - 256', () {
        final Digest hasher =
            SHA3Hasher.create(SignSchema.SHA3, hashSize: SignSchema.HASH_SIZE_32_BYTES);
        expect(hasher.algorithmName, equals('SHA-3-NIST/256'));
      });

      test('SHA3 (NIST) - 512', () {
        final Digest hasher =
            SHA3Hasher.create(SignSchema.SHA3, hashSize: SignSchema.HASH_SIZE_64_BYTES);
        expect(hasher.algorithmName, equals('SHA-3-NIST/512'));
      });

      test('SHA3 (KECCAK) - 256', () {
        final Digest hasher =
            SHA3Hasher.create(SignSchema.KECCAK, hashSize: SignSchema.HASH_SIZE_32_BYTES);
        expect(hasher.algorithmName, equals('SHA-3/256'));
      });

      test('SHA3 (KECCAK) - 512', () {
        final Digest hasher =
            SHA3Hasher.create(SignSchema.KECCAK, hashSize: SignSchema.HASH_SIZE_64_BYTES);
        expect(hasher.algorithmName, equals('SHA-3/512'));
      });
    });

    group('toHash()', () {
      test('SHA3 (NIST) - 256', () {
        // test #1
        Uint8List input = HexUtils.getBytes('227F');
        Uint8List output = SHA3Hasher.toHash(input, SignSchema.SHA3, SignSchema.HASH_SIZE_32_BYTES);
        String expected = '7f735e6b0665ceb120bff1bc1478ef2684bace93e82d5ff6d6e5066381bb365e';
        expect(HexUtils.getString(output), equals(expected));

        // test #2
        input = HexUtils.getBytes('AAAA');
        output = SHA3Hasher.toHash(input, SignSchema.SHA3, SignSchema.HASH_SIZE_32_BYTES);
        expected = '4ee18b807b7dfa443a9d87dd51bc03d868b1cde26581c092ca57a366b8b408ca';
        expect(HexUtils.getString(output), equals(expected));

        // test #2
        input = HexUtils.getBytes('BBADABA123');
        output = SHA3Hasher.toHash(input, SignSchema.SHA3, SignSchema.HASH_SIZE_32_BYTES);
        expected = 'faff241e629dfc621077481a4fec760a86675f74fba39a3c90587f0cefe177f4';
        expect(HexUtils.getString(output), equals(expected));
      });

      test('SHA3 (NIST) - 512', () {
        // test #1
        Uint8List input = HexUtils.getBytes('227F');
        Uint8List output = SHA3Hasher.toHash(input, SignSchema.SHA3, SignSchema.HASH_SIZE_64_BYTES);
        String expected = 'dc229a6d2bb1ee8ce10e5b283254c68b4ee8ab8a28fa078f6c47ddd3d2bb25ee1cdb45f'
            '58b6fb2bb164cd5652ba482e6b44beeca293a2b24b70cdf9fe8d4051c';
        expect(HexUtils.getString(output), equals(expected));

        // test #2
        input = HexUtils.getBytes('AAAA');
        output = SHA3Hasher.toHash(input, SignSchema.SHA3, SignSchema.HASH_SIZE_64_BYTES);
        expected = 'e192911d630f8fcad20b896b9d42f7a79c9fe2146bc8543ab4dcf7263e119215a741a9e774d97c'
            '3ccd5a63c484787903f9cb694e22c3f865f866a4f93537eb23';
        expect(HexUtils.getString(output), equals(expected));

        // test #2
        input = HexUtils.getBytes('BBADABA123');
        output = SHA3Hasher.toHash(input, SignSchema.SHA3, SignSchema.HASH_SIZE_64_BYTES);
        expected = '800df91a0217b997945f94dbd62c2b278925a56f040ebbc677671e396e7e38996992ee52708780'
            '0b2bb5cdb1cc29658afd8ba49f734e2e17c11b6dffacdd2de6';
        expect(HexUtils.getString(output), equals(expected));
      });

      test('SHA3 (KECCAK) - 256', () {
        // test #1
        Uint8List input = HexUtils.getBytes('227F');
        Uint8List output =
            SHA3Hasher.toHash(input, SignSchema.KECCAK, SignSchema.HASH_SIZE_32_BYTES);
        String expected = '8b768bd38b5ff80edb8a9aeb460606a682580616d512ff566d0176b1c8fc1034';
        expect(HexUtils.getString(output), equals(expected));

        // test #2
        input = HexUtils.getBytes('AAAA');
        output = SHA3Hasher.toHash(input, SignSchema.KECCAK, SignSchema.HASH_SIZE_32_BYTES);
        expected = '6330b989705733cc5c1f7285b8a5b892e08be86ed6fbe9d254713a4277bc5bd2';
        expect(HexUtils.getString(output), equals(expected));

        // test #2
        input = HexUtils.getBytes('BBADABA123');
        output = SHA3Hasher.toHash(input, SignSchema.KECCAK, SignSchema.HASH_SIZE_32_BYTES);
        expected = '9aad08fdd5ee6599b94c0440b81d5fddc8d03882f1856d72b38d72f743123304';
        expect(HexUtils.getString(output), equals(expected));
      });

      test('KECCAK - 512', () {
        // test #1
        Uint8List input = HexUtils.getBytes('227F');
        Uint8List output =
            SHA3Hasher.toHash(input, SignSchema.KECCAK, SignSchema.HASH_SIZE_64_BYTES);
        String expected = '764011e5b78404847b0a0a55f3a19c3db5401889ff438fc950537797baf42d7724ed681'
            '857bfe632cf5a132fa43dd881dbf15e4d11f518acb7fd03cacb81177a';
        expect(HexUtils.getString(output), equals(expected));

        // test #2
        input = HexUtils.getBytes('AAAA');
        output = SHA3Hasher.toHash(input, SignSchema.KECCAK, SignSchema.HASH_SIZE_64_BYTES);
        expected = 'e9cc94aeeab674586e0d62ad5f7dab2678dbdf43b73f13debdd014ed5a0c68ca18a35c6a68c9b8'
            'c7a6bd3d62a2d94f492b9f61837e985d80217f4b12ce0bd4c9';
        expect(HexUtils.getString(output), equals(expected));

        // test #2
        input = HexUtils.getBytes('BBADABA123');
        output = SHA3Hasher.toHash(input, SignSchema.KECCAK, SignSchema.HASH_SIZE_64_BYTES);
        expected = '72f35d7c791981554bae85677606e61e1f29e70e0d8d7f288af795933f03a6c2b5fccdae53b437'
            '238df35cd531cfaac5fb9d4a5590d764adb8c5dec315ab80bd';
        expect(HexUtils.getString(output), equals(expected));
      });
    });

    test('should throw an exception when trying to retrieve an invalid hasher', () {
      expect(() => SHA3Hasher.create(null),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Invalid'))));

      // SHA3
      expect(() => SHA3Hasher.create(SignSchema.SHA3, hashSize: null),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Invalid'))));
      expect(() => SHA3Hasher.create(SignSchema.SHA3, hashSize: -1),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Invalid'))));
      expect(() => SHA3Hasher.create(SignSchema.SHA3, hashSize: 0),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Invalid'))));
      expect(() => SHA3Hasher.create(SignSchema.SHA3, hashSize: 33),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Invalid'))));
      expect(() => SHA3Hasher.create(SignSchema.SHA3, hashSize: 65),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Invalid'))));

      // KECCAK
      expect(() => SHA3Hasher.create(SignSchema.KECCAK, hashSize: null),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Invalid'))));
      expect(() => SHA3Hasher.create(SignSchema.KECCAK, hashSize: -1),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Invalid'))));
      expect(() => SHA3Hasher.create(SignSchema.KECCAK, hashSize: 0),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Invalid'))));
      expect(() => SHA3Hasher.create(SignSchema.KECCAK, hashSize: 33),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Invalid'))));
      expect(() => SHA3Hasher.create(SignSchema.KECCAK, hashSize: 65),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Invalid'))));
    });
  });
}
