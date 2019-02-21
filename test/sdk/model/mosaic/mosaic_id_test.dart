library nem2_sdk_dart.test.sdk.model.mosaic.mosaic_id_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show Uint64;
import 'package:nem2_sdk_dart/sdk.dart' show MosaicId;

main() {
  final String XEM_HEX_STRING = 'D525AD41D95FCF29';
  final Uint64 XEM_ID = Uint64.fromHex(XEM_HEX_STRING);

  group('Create MosaicId via constructor', () {
    test('Can using Uint64 id', () {
      final MosaicId mosaicId = new MosaicId(id: XEM_ID);

      expect(mosaicId.id, equals(XEM_ID));
      expect(mosaicId.id.toHexString().toUpperCase(), equals(XEM_HEX_STRING));
      expect(mosaicId.fullName, isNull);
    });

    test('Can using a full name string', () {
      final MosaicId mosaicId = new MosaicId(fullName: 'nem:xem');

      expect(mosaicId.id, equals(XEM_ID));
      expect(mosaicId.id.toHexString().toUpperCase(), equals(XEM_HEX_STRING));
      expect(mosaicId.fullName, equals('nem:xem'));
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
