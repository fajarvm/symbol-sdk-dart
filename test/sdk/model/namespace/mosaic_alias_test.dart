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

library nem2_sdk_dart.test.sdk.model.namespace.mosaic_alias_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show AliasType, MosaicAlias, MosaicId, Uint64;

void main() {
  final MosaicId mosaicId = MosaicId.fromHex('85bbea6cc462b244');

  group('MosaicAlias', () {
    test('Can create MosaicAlias object', () {
      final alias = new MosaicAlias(mosaicId);

      expect(alias.type, equals(AliasType.MOSAIC));
      expect(alias.mosaicId, equals(mosaicId));
      expect(alias.address, isNull);
      expect(alias.hashCode, isNotNull);
      expect(alias.toHex(), equals('85bbea6cc462b244'));
    });

    test('Can compare MosaicAliases', () {
      final alias1 = new MosaicAlias(mosaicId);
      final alias2 = new MosaicAlias(mosaicId);

      final MosaicId mosaicId2 = MosaicId.fromHex('85bbea6cc462b242');
      final alias3 = new MosaicAlias(mosaicId2);

      expect((alias1 == alias2), isTrue);
      expect((alias1 == alias3), isFalse);

      final testId = MosaicId(Uint64.fromInts(481110498, 231112637));
      expect(testId.toHex(), equals('0dc67fbd1cad29e2'));
    });
  });
}
