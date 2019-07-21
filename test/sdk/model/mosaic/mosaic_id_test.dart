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

library nem2_sdk_dart.test.sdk.model.mosaic.mosaic_id_test;

import 'dart:typed_data' show Uint8List;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart'
    show MosaicId, MosaicNonce, NetworkType, PublicAccount, Uint64;

void main() {
  const testPublicKey = 'b4f12e7c9f6946091e2cb8b6d3a12b50d17ccbbf646386ea27ce2946a7423dcf';
  const testHex = '85BBEA6CC462B244'; // 15358872602548358953
  final testId = Uint64.fromHex(testHex);

  group('Create MosaicId via constructor', () {
    test('Can create using Uint64 id', () {
      final mosaicId = MosaicId(testId);

      expect(mosaicId.id, equals(testId));
      expect(mosaicId.id.toHex().toUpperCase(), equals(testHex));
      expect(mosaicId.hashCode, isNotNull);
      expect(mosaicId.toString(), equals('MosaicId(id:${mosaicId.id})'));
    });

    test('Should have equal Ids', () {
      final mosaicId1 = MosaicId(testId);
      final mosaicId2 = MosaicId(testId);

      expect(mosaicId1, equals(mosaicId2));
      expect(mosaicId1.id, equals(mosaicId2.id));
    });
  });

  group('Create MosaicId via helper methods', () {
    test('fromId()', () {
      final mosaicId = MosaicId.fromId(testId);

      expect(mosaicId.id, equals(testId));
      expect(mosaicId.id.toHex().toUpperCase(), equals(testHex));
    });

    test('fromBigInt()', () {
      final mosaicId = MosaicId.fromBigInt(testId.value);

      expect(mosaicId.id, equals(testId));
      expect(mosaicId.id.toHex().toUpperCase(), equals(testHex));
    });

    test('fromHex()', () {
      final mosaicId = MosaicId.fromHex(testHex);

      expect(mosaicId.id, equals(testId));
      expect(mosaicId.id.toHex().toUpperCase(), equals(testHex));
    });

    test('fromNonce()', () {
      final bytes = Uint8List.fromList([0x0, 0x0, 0x0, 0x0]);
      final nonce = new MosaicNonce(bytes);
      final owner = PublicAccount.fromPublicKey(testPublicKey, NetworkType.MIJIN_TEST);
      final mosaicId = MosaicId.fromNonce(nonce, owner);

      final expected = Uint64.fromHex('0dc67fbe1cad29e3');
      expect(mosaicId.id, equals(expected));
      expect(mosaicId.id.toHex(), equals(expected.toHex()));
    });
  });

  group('Cannot create with invalid inputs', () {
    test('Invalid constructor parameter', () {
      expect(
          () => new MosaicId(null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));
      expect(
          () => MosaicId.fromBigInt(null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));
      expect(
          () => MosaicId.fromHex(null),
          throwsA(predicate((e) =>
              e is ArgumentError && e.message.toString().contains('hex string must not be null'))));
      expect(
          () => MosaicId.fromHex(''),
          throwsA(predicate((e) =>
              e is ArgumentError && e.message.toString().contains('hex string must not be null'))));
      expect(
          () => MosaicId.fromHex('12zz34'),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Invalid hex'))));
    });
  });
}
