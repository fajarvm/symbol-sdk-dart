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

library symbol_sdk_dart.test.sdk.model.mosaic.mosaic_info_test;

import 'package:symbol_sdk_dart/sdk.dart'
    show MosaicFlags, MosaicId, MosaicInfo, NetworkType, PublicAccount, Uint64;
import 'package:test/test.dart';

void main() {
  group('Create MosaicInfo via constructor', () {
    const publicKey = 'b4f12e7c9f6946091e2cb8b6d3a12b50d17ccbbf646386ea27ce2946a7423dcf';
    const XEM_HEX_STRING = 'D525AD41D95FCF29'; // 15358872602548358953
    final XEM_ID = Uint64.fromHex(XEM_HEX_STRING);

    test('Can create via constructor', () {
      // Mosaic info parameters and properties
      final mosaicId = MosaicId(XEM_ID);
      final supply = Uint64(9999999999);
      final height = Uint64(1);
      final owner = PublicAccount.fromPublicKey(publicKey, NetworkType.MIJIN_TEST);
      const int revision = 1;
      const int divisibility = 3;
      final flags = MosaicFlags.fromByteValue(7);
      final duration = Uint64(1000);

      // Create MosaicInfo
      final MosaicInfo mosaicInfo =
          new MosaicInfo(mosaicId, supply, height, owner, revision, flags, divisibility, duration);

      // Assert
      expect(mosaicInfo.mosaicId, equals(mosaicId));
      expect(mosaicInfo.supply.value.toInt(), 9999999999);
      expect(mosaicInfo.height.value.toInt(), 1);
      expect(mosaicInfo.owner.publicKey, equals(publicKey));
      expect(mosaicInfo.revision, revision);
      expect(mosaicInfo.isSupplyMutable, isTrue);
      expect(mosaicInfo.isTransferable, isTrue);
      expect(mosaicInfo.isRestrictable, isTrue);
      expect(mosaicInfo.divisibility, divisibility);
      expect(mosaicInfo.duration.value.toInt(), 1000);
    });

    test('Cannot create with invalid revision', () {
      expect(
          () => new MosaicInfo(null, null, null, null, -1, null, 0, null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message == 'revision must not be negative')));
      expect(
          () => new MosaicInfo(null, null, null, null, 0, null, -1, null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message == 'divisibility must not be negative')));
    });
  });
}
