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

library nem2_sdk_dart.test.sdk.model.mosaic.mosaic_levy_test;

import 'package:nem2_sdk_dart/sdk.dart'
    show Address, MosaicId, MosaicLevy, MosaicLevyType, NetworkType;
import 'package:test/test.dart';

void main() {
  group('Create MosaicLevy via constructor', () {
    const publicKey = 'b4f12e7c9f6946091e2cb8b6d3a12b50d17ccbbf646386ea27ce2946a7423dcf';
    const XEM_HEX_STRING = 'D525AD41D95FCF29'; // 15358872602548358953
    final XEM_ID = MosaicId.fromHex(XEM_HEX_STRING);

    test('Can create mosaic levy object', () {
      final recipient = Address.fromPublicKey(publicKey, NetworkType.MIJIN_TEST);
      final mosaicLevy = new MosaicLevy(XEM_ID, recipient, MosaicLevyType.CALCULATED);

      expect(mosaicLevy.mosaicId, equals(XEM_ID));
      expect(mosaicLevy.mosaicId.toHex().toUpperCase(), equals(XEM_HEX_STRING));
      expect(mosaicLevy.recipient, equals(recipient));
      expect(mosaicLevy.levyType, equals(MosaicLevyType.CALCULATED));
    });
  });
}
