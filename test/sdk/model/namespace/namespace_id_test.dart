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

library nem2_sdk_dart.test.sdk.model.namespace.namespace_id_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show Uint64;
import 'package:nem2_sdk_dart/sdk.dart' show NamespaceId;

void main() {
  const NEM_HEX_STRING = '84B3552D375FFA4B'; // 9562080086528621131
  final NEM_ID = Uint64.fromHex(NEM_HEX_STRING);
  const XEM_HEX_STRING = 'D525AD41D95FCF29'; // 15358872602548358953
  final XEM_ID = Uint64.fromHex(XEM_HEX_STRING);

  group('Create NamespaceId via constructor', () {
    test('Can create using Uint64 id', () {
      final NamespaceId namespaceId = NamespaceId(id: NEM_ID);

      expect(namespaceId.id, equals(NEM_ID));
      expect(namespaceId.id.toHexString().toUpperCase(), equals(NEM_HEX_STRING));
      expect(namespaceId.fullName, isNull);
    });

    test('Can create using a full name string', () {
      final NamespaceId namespaceId = NamespaceId(fullName: 'nem.xem');

      expect(namespaceId.id, equals(XEM_ID));
      expect(namespaceId.id.toHexString().toUpperCase(), equals(XEM_HEX_STRING));
      expect(namespaceId.fullName, equals('nem.xem'));
    });

    test('Should have equal Ids', () {
      final NamespaceId namespaceId1 = NamespaceId(id: NEM_ID);
      final NamespaceId namespaceId2 = NamespaceId(id: NEM_ID);

      expect(namespaceId1, equals(namespaceId2));
      expect(namespaceId1.id, equals(namespaceId2.id));
    });
  });

  group('Create NamespaceId via helper methods', () {
    test('Can create from Uint64 id', () {
      final NamespaceId namespaceId = NamespaceId.fromId(NEM_ID);

      expect(namespaceId.id, equals(NEM_ID));
      expect(namespaceId.id.toHexString().toUpperCase(), equals(NEM_HEX_STRING));
      expect(namespaceId.fullName, isNull);
    });

    test('Can create from a big integer', () {
      final NamespaceId namespaceId = NamespaceId.fromBigInt(NEM_ID.value);

      expect(namespaceId.id, equals(NEM_ID));
      expect(namespaceId.id.toHexString().toUpperCase(), equals(NEM_HEX_STRING));
      expect(namespaceId.fullName, isNull);
    });

    test('Can create from a full name string', () {
      final NamespaceId namespaceId = NamespaceId.fromFullName('nem.xem');

      expect(namespaceId.id, equals(XEM_ID));
      expect(namespaceId.id.toHexString().toUpperCase(), equals(XEM_HEX_STRING));
      expect(namespaceId.fullName, equals('nem.xem'));
    });

    test('Can create from a hex string', () {
      final NamespaceId namespaceId = NamespaceId.fromHex(NEM_HEX_STRING);

      expect(namespaceId.id, equals(NEM_ID));
      expect(namespaceId.id.toHexString().toUpperCase(), equals(NEM_HEX_STRING));
      expect(namespaceId.fullName, isNull);
    });
  });
}
