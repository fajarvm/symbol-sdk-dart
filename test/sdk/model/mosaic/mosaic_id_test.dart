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

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show Uint64;
import 'package:nem2_sdk_dart/sdk.dart' show MosaicId;

main() {
  final String XEM_HEX_STRING = 'D525AD41D95FCF29'; // 15358872602548358953
  final Uint64 XEM_ID = Uint64.fromHex(XEM_HEX_STRING);

  group('Create MosaicId via constructor', () {
    test('Can create using Uint64 id', () {
      final MosaicId mosaicId = new MosaicId(id: XEM_ID);

      expect(mosaicId.id, equals(XEM_ID));
      expect(mosaicId.id.toHexString().toUpperCase(), equals(XEM_HEX_STRING));
      expect(mosaicId.fullName, isNull);
    });

    test('Can create using a full name string', () {
      final MosaicId mosaicId = new MosaicId(fullName: 'nem:xem');

      expect(mosaicId.id, equals(XEM_ID));
      expect(mosaicId.id.toHexString().toUpperCase(), equals(XEM_HEX_STRING));
      expect(mosaicId.fullName, equals('nem:xem'));
    });

    test('Should have equal Ids', () {
      final MosaicId mosaicId1 = new MosaicId(id: XEM_ID);
      final MosaicId mosaicId2 = new MosaicId(id: XEM_ID);

      expect(mosaicId1, equals(mosaicId2));
      expect(mosaicId1.id, equals(mosaicId2.id));
    });
  });

  group('Create MosaicId via helper methods', () {
    test('Can create from Uint64 id', () {
      final MosaicId mosaicId = MosaicId.fromId(XEM_ID);

      expect(mosaicId.id, equals(XEM_ID));
      expect(mosaicId.id.toHexString().toUpperCase(), equals(XEM_HEX_STRING));
      expect(mosaicId.fullName, isNull);
    });

    test('Can create from a big integer', () {
      final MosaicId mosaicId = MosaicId.fromBigInt(XEM_ID.value);

      expect(mosaicId.id, equals(XEM_ID));
      expect(mosaicId.id.toHexString().toUpperCase(), equals(XEM_HEX_STRING));
      expect(mosaicId.fullName, isNull);
    });

    test('Can create from a full name string', () {
      final MosaicId mosaicId = MosaicId.fromFullName('nem:xem');

      expect(mosaicId.id, equals(XEM_ID));
      expect(mosaicId.id.toHexString().toUpperCase(), equals(XEM_HEX_STRING));
      expect(mosaicId.fullName, equals('nem:xem'));
    });

    test('Can create from a hex string', () {
      final MosaicId mosaicId = MosaicId.fromHex(XEM_HEX_STRING);

      expect(mosaicId.id, equals(XEM_ID));
      expect(mosaicId.id.toHexString().toUpperCase(), equals(XEM_HEX_STRING));
      expect(mosaicId.fullName, isNull);
    });
  });
}
