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

library symbol_sdk_dart.test.sdk.model.metadata.metadata_entry_test;

import 'package:symbol_sdk_dart/sdk.dart'
    show Account, MetadataEntry, MetadataType, MosaicId, NamespaceId, NetworkType, Uint64;
import 'package:test/test.dart';

void main() {
  group('MetadataEntry', () {
    const hash = '57F7DA205008026C776CB6AED843393F04CD458E0AA2D9F1D5F31A402072B2D6';
    final testingAccount = Account.fromPrivateKey(
        '26b64cb10f005e5988a36744ca19e20d835ccc7c105aaa5f3b212da593180930', NetworkType.MIJIN_TEST);

    test('can create an Account MetadataEntry object', () {
      final scopedMetaKey = Uint64.fromHex('85BBEA6CC462B244');
      final MetadataEntry metadataEntry = MetadataEntry(hash, testingAccount.publicKey,
          testingAccount.publicKey, scopedMetaKey, MetadataType.ACCOUNT, '12345');

      expect(metadataEntry.compositeHash, equals(hash));
      expect(metadataEntry.senderPublicKey, equals(testingAccount.publicKey));
      expect(metadataEntry.targetPublicKey, equals(testingAccount.publicKey));
      expect(metadataEntry.scopedMetadataKey, equals(scopedMetaKey));
      expect(metadataEntry.metadataType, equals(MetadataType.ACCOUNT));
      expect(metadataEntry.value, equals('12345'));
      expect(metadataEntry.targetId, isNull);
    });

    test('can create a Mosaic MetadataEntry object', () {
      final scopedMetaKey = Uint64.fromHex('85BBEA6CC462B244');
      final mosaicId = MosaicId.fromHex('85BBEA6CC462B244');
      final MetadataEntry metadataEntry = MetadataEntry(hash, testingAccount.publicKey,
          testingAccount.publicKey, scopedMetaKey, MetadataType.MOSAIC, '12345', mosaicId);

      expect(metadataEntry.compositeHash, equals(hash));
      expect(metadataEntry.senderPublicKey, equals(testingAccount.publicKey));
      expect(metadataEntry.targetPublicKey, equals(testingAccount.publicKey));
      expect(metadataEntry.scopedMetadataKey, equals(scopedMetaKey));
      expect(metadataEntry.metadataType, equals(MetadataType.MOSAIC));
      expect(metadataEntry.value, equals('12345'));
      expect(metadataEntry.targetId.toHex(), equals(mosaicId.toHex()));
    });

    test('can create a Mosaic MetadataEntry object', () {
      final scopedMetaKey = Uint64.fromHex('85BBEA6CC462B244');
      final namespaceId = NamespaceId.fromHex('85BBEA6CC462B244');
      final MetadataEntry metadataEntry = MetadataEntry(hash, testingAccount.publicKey,
          testingAccount.publicKey, scopedMetaKey, MetadataType.NAMESPACE, '12345', namespaceId);

      expect(metadataEntry.compositeHash, equals(hash));
      expect(metadataEntry.senderPublicKey, equals(testingAccount.publicKey));
      expect(metadataEntry.targetPublicKey, equals(testingAccount.publicKey));
      expect(metadataEntry.scopedMetadataKey, equals(scopedMetaKey));
      expect(metadataEntry.metadataType, equals(MetadataType.NAMESPACE));
      expect(metadataEntry.value, equals('12345'));
      expect(metadataEntry.targetId.toHex(), equals(namespaceId.toHex()));
    });
  });
}
