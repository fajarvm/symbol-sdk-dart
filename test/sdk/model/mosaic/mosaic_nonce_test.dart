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

library nem2_sdk_dart.test.sdk.model.mosaic.mosaic_nonce_test;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/sdk.dart';
import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show MosaicNonce;

void main() {
  group('MosaicNonce', () {
    test('Valid constants', () {
      expect(MosaicNonce.NONCE_SIZE, 4);
    });

    test('Can create a MosaicNonce object', () {
      final mosaicNonce = new MosaicNonce(Uint8List(MosaicNonce.NONCE_SIZE));
      expect(mosaicNonce.nonce, isNotNull);
      expect(mosaicNonce.nonce.length, MosaicNonce.NONCE_SIZE);
    });

    test('Can create a random MosaicNonce object', () {
      final mosaicNonce = MosaicNonce.random();
      expect(mosaicNonce.nonce, isNotNull);
      expect(mosaicNonce.nonce.length, MosaicNonce.NONCE_SIZE);
    });

    test('Can create a MosaicNonce object from a hex string', () {
      // lower limit
      MosaicNonce mosaicNonce = MosaicNonce.fromHex('00000000');
      expect(mosaicNonce.nonce, isNotNull);
      expect(mosaicNonce.nonce.length, MosaicNonce.NONCE_SIZE);
      expect(mosaicNonce.toHex(), equals('00000000'));

      // upper limit
      mosaicNonce = MosaicNonce.fromHex('ffffffff');
      expect(mosaicNonce.nonce, isNotNull);
      expect(mosaicNonce.nonce.length, MosaicNonce.NONCE_SIZE);
      expect(mosaicNonce.toHex(), equals('ffffffff'));
    });

    test('Can create a MosaicNonce object from a Uint64 value', () {
      // lower limit
      Uint64 uint64 = Uint64.fromBigInt(BigInt.zero);
      MosaicNonce mosaicNonce = MosaicNonce.fromUint64(uint64);
      expect(mosaicNonce.nonce, isNotNull);
      expect(mosaicNonce.nonce.length, MosaicNonce.NONCE_SIZE);
      int actual = mosaicNonce.toInt();
      expect(actual, equals(uint64.value.toInt()));

      // upper limit
      uint64 = Uint64.fromBigInt(BigInt.from(4294967295));
      mosaicNonce = MosaicNonce.fromUint64(uint64);
      expect(mosaicNonce.nonce, isNotNull);
      expect(mosaicNonce.nonce.length, MosaicNonce.NONCE_SIZE);
      actual = mosaicNonce.toInt();
      expect(actual, equals(uint64.value.toInt()));
    });

    test('Cannot create MosaicNonce with invalid hex string', () {
      expect(() => MosaicNonce.fromHex('ABCDEFG'),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'invalid hex string')));
    });

    test('Cannot create MosaicNonce with invalid size', () {
      expect(
          () => new MosaicNonce(null),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message ==
                  'Invalid nonce size. The nonce should be ${MosaicNonce.NONCE_SIZE} bytes.')));
      expect(
          () => new MosaicNonce(Uint8List(0)),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message ==
                  'Invalid nonce size. The nonce should be ${MosaicNonce.NONCE_SIZE} bytes.')));
      expect(
          () => new MosaicNonce(Uint8List(3)),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message ==
                  'Invalid nonce size. The nonce should be ${MosaicNonce.NONCE_SIZE} bytes.')));
      expect(
          () => new MosaicNonce(Uint8List(5)),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message ==
                  'Invalid nonce size. The nonce should be ${MosaicNonce.NONCE_SIZE} bytes.')));
    });
  });
}
