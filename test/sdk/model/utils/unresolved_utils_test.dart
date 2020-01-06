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

library nem2_sdk_dart.test.sdk.model.utils.unresolved_utils_test;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/core.dart' show HexUtils, RawAddress;
import 'package:nem2_sdk_dart/sdk.dart'
    show Address, MosaicId, NamespaceId, NetworkType, UnresolvedUtils;
import 'package:test/test.dart';

void main() {
  group('UnresolvedUtils', () {
    // setup
    const mosaicHex = '11F4B1B3AC033DB5';
    const namespaceHex = '9550CA3FC9B41FC5';
    final namespaceId = NamespaceId.fromHex(namespaceHex);
    const rawAddress = 'MCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPR72DYSX';
    final address = Address.fromRawAddress(rawAddress);
    final addressHex = HexUtils.bytesToHex(RawAddress.stringToAddress(address.plain));

    group('toUnresolvedMosaic()', () {
      test('can map hex string to MosaicId', () {
        final unresolved = UnresolvedUtils.toUnresolvedMosaic(mosaicHex);
        expect(unresolved is MosaicId, isTrue);
        expect(unresolved is NamespaceId, isFalse);
      });

      test('can map hex string to NamespaceId', () {
        final unresolved = UnresolvedUtils.toUnresolvedMosaic(namespaceHex);
        expect(unresolved is NamespaceId, isTrue);
        expect(unresolved is MosaicId, isFalse);
      });

      test('should throw an error when the input is not a valid hex', () {
        expect(() => (UnresolvedUtils.toUnresolvedMosaic('test')),
            throwsA(predicate((e) => e is ArgumentError && e.message.contains('is not a valid'))));
      });
    });

    group('toUnresolvedAddress()', () {
      test('can map hex string to Address', () {
        final unresolved = UnresolvedUtils.toUnresolvedAddress(addressHex);
        expect(unresolved is Address, isTrue);
        expect(unresolved is NamespaceId, isFalse);
      });

      test('can map hex string to NamespaceId', () {
        final unresolved = UnresolvedUtils.toUnresolvedAddress(namespaceHex);
        expect(unresolved is NamespaceId, isTrue);
        expect(unresolved is Address, isFalse);
      });

      test('should throw an error when the input is not a valid hex', () {
        expect(() => (UnresolvedUtils.toUnresolvedAddress('test')),
            throwsA(predicate((e) => e is ArgumentError && e.message.contains('is not a valid'))));
      });
    });

    group('toUnresolvedAddressBytes()', () {
      test('can map Address to buffer', () {
        final buffer = UnresolvedUtils.toUnresolvedAddressBytes(address, NetworkType.MIJIN_TEST);
        expect(buffer is Uint8List, isTrue);
        final actualHex = HexUtils.bytesToHex(buffer);
        expect(actualHex, equals(addressHex));
      });

      test('can map hex string to NamespaceId using MIJIN_TEST', () {
        final buffer =
            UnresolvedUtils.toUnresolvedAddressBytes(namespaceId, NetworkType.MIJIN_TEST);
        expect(buffer is Uint8List, isTrue);
        expect(buffer[0], equals(NetworkType.MIJIN_TEST.value | 1));
        final actualHex = HexUtils.bytesToHex(buffer);
        expect(actualHex, equals('91c51fb4c93fca509500000000000000000000000000000000'));
      });

      test('can map hex string to NamespaceId using MAIN_NET', () {
        final buffer = UnresolvedUtils.toUnresolvedAddressBytes(namespaceId, NetworkType.MAIN_NET);
        expect(buffer is Uint8List, isTrue);
        expect(buffer[0], equals(NetworkType.MAIN_NET.value | 1));
        final actualHex = HexUtils.bytesToHex(buffer);
        expect(actualHex, equals('69c51fb4c93fca509500000000000000000000000000000000'));
      });
    });
  });
}
