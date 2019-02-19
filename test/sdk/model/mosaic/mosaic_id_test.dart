library nem2_sdk_dart.test.sdk.model.mosaic.mosaic_id_test;

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show MosaicId;

main() {
  final Int64 XEM_ID = Int64.parseHex('D525AD41D95FCF29');

  group('MosaicId', () {
    test('Can create mosaicId from an integer', () {
      final MosaicId mosaicId = new MosaicId(id: XEM_ID);

      expect(mosaicId.id, equals(XEM_ID));
      expect(mosaicId.id.toHexString(), equals('D525AD41D95FCF29'));
    });

    test('Can create mosaicId from a full name', () {
      final MosaicId mosaicId = new MosaicId(fullName: 'nem:xem');

      expect(mosaicId.id, equals(XEM_ID));
      expect(mosaicId.id.toHexString(), equals('D525AD41D95FCF29'));
      expect(mosaicId.fullName, equals('nem:xem'));
    });
  });
}
