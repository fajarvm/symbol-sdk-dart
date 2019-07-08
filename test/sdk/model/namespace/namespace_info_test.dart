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

library nem2_sdk_dart.test.sdk.model.namespace.namespace_info_test;

import 'package:nem2_sdk_dart/sdk.dart'
    show
        AliasType,
        MosaicAlias,
        MosaicId,
        NamespaceId,
        NamespaceInfo,
        NamespaceType,
        NetworkType,
        PublicAccount,
        Uint64;
import 'package:test/test.dart';

void main() {
  group('NamespaceInfo', () {
    test('Can create via constructor', () {
      // Prepare
      const bool isActive = true;
      const int index = 0;
      const metaId = '59FDA0733F17CF0001772CBC';
      const publicKey = 'b4f12e7c9f6946091e2cb8b6d3a12b50d17ccbbf646386ea27ce2946a7423dcf';
      final owner = PublicAccount.fromPublicKey(publicKey, NetworkType.MIJIN_TEST);
      final mosaicId = MosaicId(id: Uint64.fromHex('D525AD41D95FCF29'));
      final alias = new MosaicAlias(mosaicId);

      // sub namespaces
      final level1 = new NamespaceId(fullName: 'foo');
      final level2 = new NamespaceId(fullName: 'bar');

      // Create NamespaceInfo
      final NamespaceInfo namespaceInfo = new NamespaceInfo(
          isActive,
          index,
          metaId,
          NamespaceType.ROOT_NAMESPACE,
          1,
          [level1, level2],
          new NamespaceId(id: Uint64(0)),
          owner,
          Uint64(0),
          Uint64(9999),
          alias);

      expect(namespaceInfo.active, isTrue);
      expect(namespaceInfo.index, 0);
      expect(namespaceInfo.metaId, equals(metaId));
      expect(namespaceInfo.type, equals(NamespaceType.ROOT_NAMESPACE));
      expect(namespaceInfo.depth, 1);
      expect(namespaceInfo.levels.length, 2);
      expect(namespaceInfo.levels[0], equals(level1));
      expect(namespaceInfo.levels[1], equals(level2));
      expect(namespaceInfo.parentId, equals(new NamespaceId(id: Uint64(0))));
      expect(namespaceInfo.owner.publicKey, equals(publicKey));
      expect(namespaceInfo.startHeight, equals(Uint64(0)));
      expect(namespaceInfo.endHeight, equals(Uint64(9999)));
      expect(namespaceInfo.alias, alias);
      expect(namespaceInfo.alias.type, AliasType.MOSAIC);
      expect(namespaceInfo.alias.mosaicId, mosaicId);
      expect(namespaceInfo.id, equals(level2));
      expect(namespaceInfo.isRoot(), isTrue);
      expect(namespaceInfo.isSubnamespace(), isFalse);
      expect(namespaceInfo.hasAlias(), isTrue);

      expect(() => namespaceInfo.parentNamespaceId(),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'This is a root namespace')));
    });

    test('Cannot create with invalid index, depth or levels', () {
      expect(
          () => new NamespaceInfo(
              true, -1, '', NamespaceType.ROOT_NAMESPACE, 1, null, null, null, null, null, null),
          throwsA(
              predicate((e) => e is ArgumentError && e.message == 'index must not be negative')));
      expect(
          () => new NamespaceInfo(
              true, 0, '', NamespaceType.ROOT_NAMESPACE, -1, null, null, null, null, null, null),
          throwsA(
              predicate((e) => e is ArgumentError && e.message == 'depth must not be negative')));
      expect(
          () => new NamespaceInfo(
              true, 0, '', NamespaceType.ROOT_NAMESPACE, 1, null, null, null, null, null, null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message == 'levels must not be null or empty')));
      expect(
          () => new NamespaceInfo(
              true, 0, '', NamespaceType.ROOT_NAMESPACE, 1, [], null, null, null, null, null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message == 'levels must not be null or empty')));
    });
  });
}
