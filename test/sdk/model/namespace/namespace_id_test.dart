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

library symbol_sdk_dart.test.sdk.model.namespace.namespace_id_test;

import 'package:test/test.dart';

import 'package:symbol_sdk_dart/sdk.dart' show NamespaceId, Uint64;

void main() {
  const NEM_HEX_STRING = '84B3552D375FFA4B'; // 9562080086528621131
  final NEM_ID = Uint64.fromHex(NEM_HEX_STRING);
  final NEM_INTS = [929036875, 2226345261];
  const SUBNEM_HEX_STRING = 'E42900AF163F33B2'; // 15358872602548358953
  final SUBNEM_ID = Uint64.fromHex(SUBNEM_HEX_STRING);
  final SUBNEM_INTS = [373240754, 3827892399];

  group('Create NamespaceId via constructor', () {
    test('Can create using Uint64 id', () {
      final NamespaceId namespaceId = NamespaceId(id: NEM_ID);

      expect(namespaceId.id, equals(NEM_ID));
      expect(namespaceId.id.toHex().toUpperCase(), equals(NEM_HEX_STRING));
      expect(namespaceId.fullName, isNull);
      expect(namespaceId.hashCode, isNotNull);
      expect(namespaceId.toString(),
          equals('NamespaceId(id:${namespaceId.id}, fullName:${namespaceId.fullName})'));
    });

    test('Can create using a full name string', () {
      final NamespaceId namespaceId = NamespaceId(fullName: 'nem.subnem');

      expect(namespaceId.id, equals(SUBNEM_ID));
      expect(namespaceId.id.toHex().toUpperCase(), equals(SUBNEM_HEX_STRING));
      expect(namespaceId.fullName, equals('nem.subnem'));
    });

    test('Should have equal Ids', () {
      final NamespaceId namespaceId1 = NamespaceId(id: NEM_ID);
      final NamespaceId namespaceId2 = NamespaceId(id: NEM_ID);
      final NamespaceId namespaceId3 = NamespaceId(fullName: 'nem');

      expect(namespaceId1, equals(namespaceId2));
      expect(namespaceId1.id, equals(namespaceId2.id));
      expect(namespaceId1.id, equals(namespaceId3.id));
      expect(namespaceId2.id, equals(namespaceId3.id));
    });
  });

  group('Create NamespaceId via static methods', () {
    test('Can create from Uint64 id', () {
      final NamespaceId namespaceId = NamespaceId.fromId(NEM_ID);

      expect(namespaceId.id, equals(NEM_ID));
      expect(namespaceId.id.toHex().toUpperCase(), equals(NEM_HEX_STRING));
      expect(namespaceId.fullName, isNull);
    });

    test('Can create from a big integer', () {
      final NamespaceId namespaceId = NamespaceId.fromBigInt(NEM_ID.value);

      expect(namespaceId.id, equals(NEM_ID));
      expect(namespaceId.id.toHex().toUpperCase(), equals(NEM_HEX_STRING));
      expect(namespaceId.fullName, isNull);
    });

    test('Can create from a full name string', () {
      final NamespaceId namespaceId = NamespaceId.fromFullName('nem.subnem');

      expect(namespaceId.id, equals(SUBNEM_ID));
      expect(namespaceId.id.toHex().toUpperCase(), equals(SUBNEM_HEX_STRING));
      expect(namespaceId.fullName, equals('nem.subnem'));
    });

    test('Can create from a hex string', () {
      final NamespaceId namespaceId = NamespaceId.fromHex(NEM_HEX_STRING);

      expect(namespaceId.id, equals(NEM_ID));
      expect(namespaceId.id.toHex().toUpperCase(), equals(NEM_HEX_STRING));
      expect(namespaceId.fullName, isNull);
    });

    test('Can create from an int array', () {
      final namespaceId = NamespaceId.fromInts(NEM_INTS[0], NEM_INTS[1]);

      expect(namespaceId.id, equals(NEM_ID));
      expect(namespaceId.id.toHex().toUpperCase(), equals(NEM_HEX_STRING));
      expect(namespaceId.fullName, isNull);

      final subNamespaceId = NamespaceId.fromInts(SUBNEM_INTS[0], SUBNEM_INTS[1]);

      expect(subNamespaceId.id, equals(SUBNEM_ID));
      expect(subNamespaceId.id.toHex().toUpperCase(), equals(SUBNEM_HEX_STRING));
      expect(subNamespaceId.fullName, isNull);
    });
  });

  group('Test vectors', () {
    const vectors = {
      [
        '84B3552D375FFA4B',
        [929036875, 2226345261]
      ], // new NamespaceId('nem')
      [
        'F8495AEE892FA108',
        [2301600008, 4165556974]
      ], // new NamespaceId('nem.owner.test1')
      [
        'ABAEF4E86505811F',
        [1694859551, 2880369896]
      ], // new NamespaceId('nem.owner.test2')
      [
        'AEB8C92B0A1C2D55',
        [169618773, 2931345707]
      ], // new NamespaceId('nem.owner.test3')
      [
        '90E09AD44014CABF',
        [1075104447, 2430638804]
      ], // new NamespaceId('nem.owner.test4')
      [
        'AB114281960BF1CC',
        [2517365196, 2870035073]
      ], // new NamespaceId('nem.owner.test5')
    };

    test('Should pass test using test vectors', () {
      for (var value in vectors) {
        final NamespaceId fromHex = NamespaceId.fromHex(value[0]);
        final List<int> intArray = value[1];
        final NamespaceId fromId = NamespaceId.fromInts(intArray[0], intArray[1]);
        expect(fromHex.id, equals(fromId.id));
      }
    });
  });

  group('Cannot create with invalid inputs', () {
    test('Invalid constructor parameter', () {
      expect(
          () => new NamespaceId(id: null, fullName: null),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'Missing argument. Either id or fullName is required.')));
      expect(
          () => NamespaceId.fromBigInt(null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));
      expect(
          () => NamespaceId.fromHex(null),
          throwsA(predicate((e) =>
              e is ArgumentError && e.message == 'The hexString must not be null or empty')));
      expect(
          () => NamespaceId.fromHex(''),
          throwsA(predicate((e) =>
              e is ArgumentError && e.message == 'The hexString must not be null or empty')));
      expect(() => NamespaceId.fromHex('12zz34'),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'invalid hex')));
    });
  });
}
