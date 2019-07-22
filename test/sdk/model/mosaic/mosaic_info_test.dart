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

library nem2_sdk_dart.test.sdk.model.mosaic.mosaic_info_test;

import 'package:nem2_sdk_dart/sdk.dart'
    show MosaicId, MosaicInfo, MosaicProperties, NetworkType, PublicAccount, Uint64;
import 'package:test/test.dart';

void main() {
  group('Create MosaicInfo via constructor', () {
    const publicKey = 'b4f12e7c9f6946091e2cb8b6d3a12b50d17ccbbf646386ea27ce2946a7423dcf';
    const XEM_HEX_STRING = 'D525AD41D95FCF29'; // 15358872602548358953
    final XEM_ID = Uint64.fromHex(XEM_HEX_STRING);

    test('Can create via constructor', () {
      // Mosaic info parameters and properties
      const metaId = '59FDA0733F17CF0001772CBC';
      final mosaicId = MosaicId(XEM_ID);
      final supply = Uint64(9999999999);
      final height = Uint64(1);
      final owner = PublicAccount.fromPublicKey(publicKey, NetworkType.MIJIN_TEST);
      const int revision = 1;

      final properties = MosaicProperties.create(Uint64(9000));

      // Create MosaicInfo
      final MosaicInfo mosaicInfo =
          new MosaicInfo(metaId, mosaicId, supply, height, owner, revision, properties);

      // Assert
      expect(mosaicInfo.metaId, equals(metaId));
      expect(mosaicInfo.mosaicId, equals(mosaicId));
      expect(mosaicInfo.supply.value.toInt(), 9999999999);
      expect(mosaicInfo.height.value.toInt(), 1);
      expect(mosaicInfo.owner.publicKey, equals(publicKey));
      expect(mosaicInfo.revision, 1);
      expect(mosaicInfo.isSupplyMutable, isFalse);
      expect(mosaicInfo.isTransferable, isTrue);
      expect(mosaicInfo.divisibility, 0);
      expect(mosaicInfo.duration.value.toInt(), 9000);
    });

    test('Cannot create with invalid revision', () {
      expect(
          () => new MosaicInfo(null, null, null, null, null, -1, null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message == 'revision must not be negative')));
    });
  });
}
