library nem2_sdk_dart.test.core.utils.id_generator_test;

import 'package:fixnum/fixnum.dart' show Int64;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/src/core/crypto.dart' show CryptoException;
import 'package:nem2_sdk_dart/src/core/utils.dart' show IdGenerator;

main() {
  final Int64 NEM_ID = Int64.parseHex('84B3552D375FFA4B');
  final Int64 XEM_ID = Int64.parseHex('D525AD41D95FCF29');

  group('generateId', () {
    test('Can generate correct namespace', () {
      final Int64 namespaceId = IdGenerator.generateId(IdGenerator.NAMESPACE_BASE_ID, 'nem');

      expect(namespaceId, equals(NEM_ID));
    });

    test('Can generate correct mosaic', () {
      final Int64 namespaceId = IdGenerator.generateId(IdGenerator.NAMESPACE_BASE_ID, 'nem');
      final Int64 mosaicId = IdGenerator.generateId(namespaceId, 'xem');

      expect(namespaceId, equals(NEM_ID));
      expect(mosaicId, equals(XEM_ID));
    });

    test('Can generate correct namespace and mosaic by chaining', () {
      final Int64 namespaceId = IdGenerator.generateId(IdGenerator.NAMESPACE_BASE_ID, 'nem');
      final Int64 mosaicId = IdGenerator.generateId(namespaceId, 'xem');

      final Int64 generated = IdGenerator.generateMosaicId('nem:xem');
      final Int64 chained = IdGenerator.generateId(
          IdGenerator.generateId(IdGenerator.NAMESPACE_BASE_ID, 'nem'), 'xem');

      expect(namespaceId, equals(NEM_ID));
      expect(mosaicId, equals(XEM_ID));
      expect(generated, equals(XEM_ID));
      expect(chained, equals(XEM_ID));
    });

    test('Can generate multilevel namespaces', () {
      List<Int64> ids = new List<Int64>();
      ids.add(IdGenerator.generateId(IdGenerator.NAMESPACE_BASE_ID, 'foo'));
      ids.add(IdGenerator.generateId(ids[0], 'bar'));
      ids.add(IdGenerator.generateId(ids[1], 'baz'));

      List<Int64> namespaces = IdGenerator.generateNamespacePath('foo.bar.baz');

      expect(ids.length, equals(namespaces.length));
      expect(ids[0].toHexString(), equals(namespaces[0].toHexString()));
      expect(ids[1].toHexString(), equals(namespaces[1].toHexString()));
      expect(ids[2].toHexString(), equals(namespaces[2].toHexString()));
    });

    test('Can generate multilevel namespaces with mosaic', () {
      List<Int64> namespaceIds = new List<Int64>();
      namespaceIds.add(IdGenerator.generateId(IdGenerator.NAMESPACE_BASE_ID, 'foo'));
      namespaceIds.add(IdGenerator.generateId(namespaceIds[0], 'bar'));
      namespaceIds.add(IdGenerator.generateId(namespaceIds[1], 'baz'));
      Int64 mosaicId = IdGenerator.generateId(namespaceIds[2], 'xem');

      List<Int64> namespaceIdsGen = IdGenerator.generateNamespacePath('foo.bar.baz');
      Int64 mosaicIdGen = IdGenerator.generateMosaicId('foo.bar.baz:xem');

      expect(namespaceIds, equals(namespaceIdsGen));
      expect(mosaicId, equals(mosaicIdGen));
    });
  });

  group('generateNameSpacePath', () {
    test('Can generate a correct well known namespace root path', () {
      final List<Int64> ids = IdGenerator.generateNamespacePath('nem');

      expect(ids.length, equals(1));
      expect(ids[0], equals(NEM_ID));
    });

    test('Can generate correct well known namespace path with child', () {
      final List<Int64> ids = IdGenerator.generateNamespacePath('nem.xem');

      expect(ids.length, equals(2));
      expect(ids[0], equals(NEM_ID));
      expect(ids[1], equals(XEM_ID));
    });

    test('Can generate namespace path with enough parts', () {
      final List<Int64> ids = IdGenerator.generateNamespacePath('a.b.c');

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
      Int64 id1 = IdGenerator.generateMosaicId('nem:xem');

      expect(id1, equals(XEM_ID));
    });

    test('Mosaics with the same name from different namespaces are different', () {
      Int64 id1 = IdGenerator.generateMosaicId('nem:xem');
      // different namespaces
      Int64 id2 = IdGenerator.generateMosaicId('foo.bar:xem');
      Int64 id3 = IdGenerator.generateMosaicId('a.b.c:xem');

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
      final String namespace = 'foo:';
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
            () => IdGenerator.generateMosaicId('${namespace}${mosaicName}'),
            throwsA(predicate((e) =>
                e is CryptoException && e.message.contains('Fully qualified id is invalid'))));
      }
    });
  });
}
