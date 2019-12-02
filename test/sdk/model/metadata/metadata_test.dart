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

library nem2_sdk_dart.test.sdk.model.metadata.metadata_test;

import 'package:nem2_sdk_dart/sdk.dart'
    show Account, Metadata, MetadataEntry, MetadataType, NetworkType, Uint64;
import 'package:test/test.dart';

void main() {
  group('MetadataEntry', () {
    const hash = '57F7DA205008026C776CB6AED843393F04CD458E0AA2D9F1D5F31A402072B2D6';
    final testingAccount = Account.fromPrivateKey(
        '26b64cb10f005e5988a36744ca19e20d835ccc7c105aaa5f3b212da593180930', NetworkType.MIJIN_TEST);

    test('can create a meta object', () {
      const id = '9999';
      final scopedMetaKey = Uint64.fromHex('85BBEA6CC462B244');
      final MetadataEntry metadataEntry = MetadataEntry(hash, testingAccount.publicKey,
          testingAccount.publicKey, scopedMetaKey, MetadataType.ACCOUNT, '12345');

      final metadata = Metadata(id, metadataEntry);

      expect(metadata.id, equals('9999'));
      expect(metadata.metadataEntry.compositeHash, equals(hash));
      expect(metadata.metadataEntry.senderPublicKey, equals(testingAccount.publicKey));
      expect(metadata.metadataEntry.targetPublicKey, equals(testingAccount.publicKey));
      expect(metadata.metadataEntry.scopedMetadataKey, equals(scopedMetaKey));
      expect(metadata.metadataEntry.metadataType, equals(MetadataType.ACCOUNT));
      expect(metadata.metadataEntry.value, equals('12345'));
      expect(metadata.metadataEntry.targetId, isNull);
    });
  });
}
