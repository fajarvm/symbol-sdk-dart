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
