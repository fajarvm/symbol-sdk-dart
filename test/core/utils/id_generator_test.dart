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

library nem2_sdk_dart.test.core.utils.id_generator_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show CryptoException, IdGenerator, Uint64;

void main() {
  final Uint64 NEM_ID = Uint64.fromHex('84B3552D375FFA4B'); // 9562080086528621131
  final Uint64 XEM_ID = Uint64.fromHex('D525AD41D95FCF29'); // 15358872602548358953

  group('generateId', () {
    test('Can generate correct namespace', () {
      final Uint64 namespaceId = IdGenerator.generateId(IdGenerator.NAMESPACE_BASE_ID, 'nem');

      expect(namespaceId, equals(NEM_ID));
    });

    test('Can generate correct mosaic', () {
      final Uint64 namespaceId = IdGenerator.generateId(IdGenerator.NAMESPACE_BASE_ID, 'nem');
      final Uint64 mosaicId = IdGenerator.generateId(namespaceId, 'xem');

      expect(namespaceId, equals(NEM_ID));
      expect(mosaicId, equals(XEM_ID));
    });

    test('Can generate correct namespace and mosaic by chaining', () {
      final Uint64 namespaceId = IdGenerator.generateId(IdGenerator.NAMESPACE_BASE_ID, 'nem');
      final Uint64 mosaicId = IdGenerator.generateId(namespaceId, 'xem');

      final Uint64 generated = IdGenerator.generateMosaicId('nem:xem');
      final Uint64 chained = IdGenerator.generateId(
          IdGenerator.generateId(IdGenerator.NAMESPACE_BASE_ID, 'nem'), 'xem');

      expect(namespaceId, equals(NEM_ID));
      expect(mosaicId, equals(XEM_ID));
      expect(generated, equals(XEM_ID));
      expect(chained, equals(XEM_ID));
    });

    test('Can generate multilevel namespaces', () {
      final List<Uint64> ids = <Uint64>[];
      ids.add(IdGenerator.generateId(IdGenerator.NAMESPACE_BASE_ID, 'foo'));
      ids.add(IdGenerator.generateId(ids[0], 'bar'));
      ids.add(IdGenerator.generateId(ids[1], 'baz'));

      final List<Uint64> namespaces = IdGenerator.generateNamespacePath('foo.bar.baz');

      expect(ids.length, equals(namespaces.length));
      expect(ids[0].toHexString(), equals(namespaces[0].toHexString()));
      expect(ids[1].toHexString(), equals(namespaces[1].toHexString()));
      expect(ids[2].toHexString(), equals(namespaces[2].toHexString()));
    });

    test('Can generate multilevel namespaces with mosaic', () {
      final List<Uint64> namespaceIds = <Uint64>[];
      namespaceIds.add(IdGenerator.generateId(IdGenerator.NAMESPACE_BASE_ID, 'foo'));
      namespaceIds.add(IdGenerator.generateId(namespaceIds[0], 'bar'));
      namespaceIds.add(IdGenerator.generateId(namespaceIds[1], 'baz'));
      final Uint64 mosaicId = IdGenerator.generateId(namespaceIds[2], 'xem');

      final List<Uint64> namespaceIdsGen = IdGenerator.generateNamespacePath('foo.bar.baz');
      final Uint64 mosaicIdGen = IdGenerator.generateMosaicId('foo.bar.baz:xem');

      expect(namespaceIds, equals(namespaceIdsGen));
      expect(mosaicId, equals(mosaicIdGen));
    });
  });

  group('generateNameSpacePath', () {
    test('Can generate a correct well known namespace root path', () {
      final List<Uint64> ids = IdGenerator.generateNamespacePath('nem');

      expect(ids.length, equals(1));
      expect(ids[0], equals(NEM_ID));
    });

    test('Can generate correct well known namespace path with child', () {
      final List<Uint64> ids = IdGenerator.generateNamespacePath('nem.xem');

      expect(ids.length, equals(2));
      expect(ids[0], equals(NEM_ID));
      expect(ids[1], equals(XEM_ID));
    });

    test('Can generate namespace path with enough parts', () {
      final List<Uint64> ids = IdGenerator.generateNamespacePath('a.b.c');

      expect(ids.length, equals(3));
    });

    test('Cannot generate namespace path with too many parts', () {
      expect(
          () => IdGenerator.generateNamespacePath('a.b.c.d'),
          throwsA(predicate((e) =>
              e is CryptoException &&
              e.message ==
                  'Fully qualified id is invalid due to too many namespace parts (a.b.c.d)')));

      expect(
          () => IdGenerator.generateNamespacePath('a.b.c.d.e'),
          throwsA(predicate((e) =>
              e is CryptoException &&
              e.message ==
                  'Fully qualified id is invalid due to too many namespace parts (a.b.c.d.e)')));
    });

    test('Cannot generate invalid namespaces', () {
      final List<String> invalidNames = [
        '',
        'alpha.bet@.zeta',
        'a!pha.beta.zeta',
        'alpha.beta.ze^a',
        '.',
        '.a',
        'a..a',
        'A'
      ];

      for (var name in invalidNames) {
        expect(
            () => IdGenerator.generateNamespacePath(name),
            throwsA(predicate((e) =>
                e is CryptoException && e.message.contains('Fully qualified id is invalid'))));
      }
    });
  });

  group('generateMosaicId', () {
    test('Can generate a correct well known mosaic', () {
      final Uint64 id1 = IdGenerator.generateMosaicId('nem:xem');

      expect(id1, equals(XEM_ID));
    });

    test('Mosaics with the same name from different namespaces are different', () {
      final Uint64 id1 = IdGenerator.generateMosaicId('nem:xem');
      // different namespaces
      final Uint64 id2 = IdGenerator.generateMosaicId('foo.bar:xem');
      final Uint64 id3 = IdGenerator.generateMosaicId('a.b.c:xem');

      expect(id1, equals(XEM_ID));
      expect(id2, isNot(equals(XEM_ID)));
      expect(id3, isNot(equals(XEM_ID)));
    });

    test('Cannot generate mosaic without a namespace', () {
      expect(
          () => IdGenerator.generateMosaicId('xem'),
          throwsA(predicate((e) =>
              e is CryptoException &&
              e.message == 'Fully qualified id is invalid due to missing mosaic (xem)')));
    });

    test('Cannot generate invalid mosaics', () {
      const String namespace = 'foo:';
      final List<String> invalidNames = [
        'A',
        'a..a',
        '.',
        '@lpha',
        'a!pha',
        'alph*',
        'alp^a',
      ];

      for (var mosaicName in invalidNames) {
        expect(
            () => IdGenerator.generateMosaicId('$namespace$mosaicName'),
            throwsA(predicate((e) =>
                e is CryptoException && e.message.contains('Fully qualified id is invalid'))));
      }
    });
  });
}
