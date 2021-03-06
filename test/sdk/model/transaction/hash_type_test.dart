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

library symbol_sdk_dart.test.sdk.model.transaction.hash_type_test;

import 'dart:typed_data' show Uint8List;

import 'package:symbol_sdk_dart/core.dart' show CryptoUtils, HexUtils;
import 'package:symbol_sdk_dart/sdk.dart' show HashType;
import 'package:test/test.dart';

void main() {
  group('HashType', () {
    test('valid hash types', () {
      expect(HashType.SHA3_256.value, 0);
      expect(HashType.KECCAK_256.value, 1);
      expect(HashType.RIPEMD_160.value, 2);
      expect(HashType.SHA_256.value, 3);

      expect(HashType.SHA_256.toString(), equals('HashType{value: ${HashType.SHA_256.value}}'));
    });

    test('Can retrieve valid hash types', () {
      expect(HashType.fromInt(0), HashType.SHA3_256);
      expect(HashType.fromInt(1), HashType.KECCAK_256);
      expect(HashType.fromInt(2), HashType.RIPEMD_160);
      expect(HashType.fromInt(3), HashType.SHA_256);
    });

    test('Trying to retrieve an invalid hash type will throw an error', () {
      String errorMessage = HashType.UNSUPPORTED_HASH_TYPE;
      expect(() => HashType.fromInt(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => HashType.fromInt(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => HashType.fromInt(4),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });

    test('The hash of SHA3-256 should be valid', () {
      // SHA3-256 = valid
      final sha256digest = CryptoUtils.createSha3Digest(length: 32);
      final result256 = sha256digest.process(HexUtils.getBytes(HexUtils.utf8ToHex('abcxyz')));
      expect(HashType.validate(HexUtils.getString(result256), HashType.SHA3_256), isTrue);

      // SHA3-512 = invalid
      final sha512digest = CryptoUtils.createSha3Digest(length: 64);
      final result512 = sha512digest.process(HexUtils.getBytes(HexUtils.utf8ToHex('abcxyz')));
      expect(HashType.validate(HexUtils.getString(result512), HashType.SHA3_256), isFalse);

      // invalid hash string
      const invalid = 'zyz6053bb910a6027f138ac5ebe92d43a9a18b7239b3c4d5ea69f1632e50aeef28184e46cd2'
          '2ded096b766318580a569e74521a9d63885cc8d5e8644793be928';
      expect(HashType.validate(invalid, HashType.SHA3_256), isFalse);
    });

    test('The hash of Keccak-256 should be valid', () {
      // Keccak-256 = valid
      final keccak256 = CryptoUtils.createKeccakDigest(length: 32);
      final result256 = keccak256.process(HexUtils.getBytes(HexUtils.utf8ToHex('abcxyz')));
      expect(HashType.validate(HexUtils.getString(result256), HashType.KECCAK_256), isTrue);

      // Keccak-512 = invalid
      final keccak512 = CryptoUtils.createKeccakDigest(length: 64);
      final result512 = keccak512.process(HexUtils.getBytes(HexUtils.utf8ToHex('abcxyz')));
      expect(HashType.validate(HexUtils.getString(result512), HashType.KECCAK_256), isFalse);
    });

    test('The hash of SHA-256 should be valid', () {
      // Sha-256 = valid
      final sha256 = CryptoUtils.createSha256Digest();
      final result256 = sha256.process(HexUtils.getBytes(HexUtils.utf8ToHex('abcxyz')));
      expect(HashType.validate(HexUtils.getString(result256), HashType.SHA_256), isTrue);

      // Double Sha-256 = valid
      final doubleSha256 = sha256.process(result256);
      expect(HashType.validate(HexUtils.getString(doubleSha256), HashType.SHA_256), isTrue);
    });

    test('The hash of RIPEMD-160 should be valid', () {
      final Uint8List input = HexUtils.getBytes(HexUtils.utf8ToHex('abcxyz'));

      // Ripemd-160 = invalid
      final ripemd160 = CryptoUtils.createRipemd160Digest();
      final result160 = ripemd160.process(input);
      expect(HashType.validate(HexUtils.getString(result160), HashType.RIPEMD_160), isTrue);

      // Sha-256  and then Ripemd-160 = valid
      final sha256 = CryptoUtils.createSha256Digest();
      final resultSha = sha256.process(input);
      ripemd160.reset();
      final result = ripemd160.process(resultSha);
      expect(HashType.validate(HexUtils.getString(result), HashType.RIPEMD_160), isTrue);

      // invalid hash string
      const invalid = 'zyz6053bb910a6027f138ac5ebe92d43a9a18b7239b3c4d5ea69f1632e50aeef28184e46cd2'
          '2ded096b766318580a569e74521a9d63885cc8d5e8644793be928';
      expect(HashType.validate(invalid, HashType.RIPEMD_160), isFalse);
    });

    test('Cannot create digest with an invalid length', () {
      // SHA3 digest 32-bit
      expect(
          () => CryptoUtils.createSha3Digest(length: 31),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Unexpected length'))));

      // SHA3 digest 64-bit
      expect(
          () => CryptoUtils.createSha3Digest(length: 63),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Unexpected length'))));

      // Keccak digest 32-bit
      expect(
          () => CryptoUtils.createKeccakDigest(length: 31),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Unexpected length'))));

      // Keccak digest 64-bit
      expect(
          () => CryptoUtils.createKeccakDigest(length: 63),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Unexpected length'))));
    });
  });
}
