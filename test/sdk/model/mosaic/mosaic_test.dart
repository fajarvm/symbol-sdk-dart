library nem2_sdk_dart.test.sdk.model.mosaic.mosaic_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show Uint64;
import 'package:nem2_sdk_dart/sdk.dart' show Mosaic, MosaicId;

main() {
  group('Mosaic', () {
    test('Can create mosaic object', () {
      final String XEM_HEX_STRING = 'D525AD41D95FCF29';
      final MosaicId mosaicId = MosaicId.fromHex(XEM_HEX_STRING);
      final Uint64 amount = new Uint64(9999999999);
      final Mosaic mosaic = new Mosaic(mosaicId, amount);

      expect(mosaic.id, equals(mosaicId));
      expect(mosaic.amount, equals(amount));
      expect(mosaic.amount.value.toInt(), equals(9999999999));
    });
  });
}
