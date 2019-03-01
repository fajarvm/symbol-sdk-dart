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

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show MosaicNonce;

void main() {
  group('MosaicNonce', () {
    test('Can create a MosaicNonce object', () {
      final mosaicNonce = new MosaicNonce(Uint8List(MosaicNonce.NONCE_SIZE));
      expect(mosaicNonce.nonce, isNotNull);
      expect(mosaicNonce.nonce.length, MosaicNonce.NONCE_SIZE);
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
