library nem2_sdk_dart.test.sdk.model.mosaic.mosaic_id_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show Uint64;
import 'package:nem2_sdk_dart/sdk.dart' show MosaicId;

main() {
  final Uint64 XEM_ID = Uint64.fromHex('D525AD41D95FCF29');

  group('MosaicId', () {
    test('Can create mosaicId from an integer', () {
      final MosaicId mosaicId = new MosaicId(id: XEM_ID);

      expect(mosaicId.id, equals(XEM_ID));
      expect(mosaicId.id.toHexString().toUpperCase(), equals('D525AD41D95FCF29'));
    });

    test('Can create mosaicId from a full name', () {
      final MosaicId mosaicId = new MosaicId(fullName: 'nem:xem');

      expect(mosaicId.id, equals(XEM_ID));
      expect(mosaicId.id.toHexString().toUpperCase(), equals('D525AD41D95FCF29'));
      expect(mosaicId.fullName, equals('nem:xem'));
    });
  });
}
