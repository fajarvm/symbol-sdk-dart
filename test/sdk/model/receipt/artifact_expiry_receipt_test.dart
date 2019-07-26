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

library nem2_sdk_dart.test.sdk.model.receipt.artifact_expiry_receipt_test;

import 'package:nem2_sdk_dart/sdk.dart'
    show ArtifactExpiryReceipt, MosaicId, NamespaceId, ReceiptType, ReceiptVersion;
import 'package:test/test.dart';

void main() {
  group('ArtifactExpiryReceipt', () {
    test('Can create Mosaic expiry receipt', () {
      MosaicId id = MosaicId.fromHex('85bbea6cc462b244');
      ArtifactExpiryReceipt<MosaicId> mosaicExpiryReceipt =
          new ArtifactExpiryReceipt(id, ReceiptType.MOSAIC_EXPIRED, ReceiptVersion.ARTIFACT_EXPIRY);

      expect(mosaicExpiryReceipt.type, equals(ReceiptType.MOSAIC_EXPIRED));
      expect(mosaicExpiryReceipt.version, equals(ReceiptVersion.ARTIFACT_EXPIRY));
      expect(mosaicExpiryReceipt.artifactId.toHex(), equals('85bbea6cc462b244'));
      expect(mosaicExpiryReceipt.size, isNull);
    });

    test('Can create Namespace expiry receipt', () {
      // Namespace fullName: nem, hex: 84b3552d375ffa4b
      NamespaceId id = NamespaceId.fromHex('84b3552d375ffa4b');
      ArtifactExpiryReceipt<NamespaceId> mosaicExpiryReceipt = new ArtifactExpiryReceipt(
          id, ReceiptType.NAMESPACE_EXPIRED, ReceiptVersion.ARTIFACT_EXPIRY);

      expect(mosaicExpiryReceipt.type, equals(ReceiptType.NAMESPACE_EXPIRED));
      expect(mosaicExpiryReceipt.version, equals(ReceiptVersion.ARTIFACT_EXPIRY));
      expect(mosaicExpiryReceipt.artifactId.toHex(), equals('84b3552d375ffa4b'));
      expect(mosaicExpiryReceipt.size, isNull);
    });

    test('Can create Mosaic expiry receipt with size', () {
      MosaicId id = MosaicId.fromHex('85bbea6cc462b244');
      ArtifactExpiryReceipt<MosaicId> mosaicExpiryReceipt = new ArtifactExpiryReceipt(
          id, ReceiptType.MOSAIC_EXPIRED, ReceiptVersion.ARTIFACT_EXPIRY, 100);

      expect(mosaicExpiryReceipt.type, equals(ReceiptType.MOSAIC_EXPIRED));
      expect(mosaicExpiryReceipt.version, equals(ReceiptVersion.ARTIFACT_EXPIRY));
      expect(mosaicExpiryReceipt.artifactId.toHex(), equals('85bbea6cc462b244'));
      expect(mosaicExpiryReceipt.size, 100);
    });

    test('Should throw an exception when creating a receipt with bad parameter values', () {
      // null artifactId
      expect(
          () => ArtifactExpiryReceipt(
              null, ReceiptType.MOSAIC_EXPIRED, ReceiptVersion.ARTIFACT_EXPIRY, 100),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));

      MosaicId id = MosaicId.fromHex('85bbea6cc462b244');

      // null receipt type
      expect(
          () => ArtifactExpiryReceipt(id, null, ReceiptVersion.ARTIFACT_EXPIRY, 100),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));

      // null receipt version
      expect(
          () => ArtifactExpiryReceipt(id, ReceiptType.MOSAIC_EXPIRED, null, 100),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.toString().contains('Must not be null'))));

      // bad type for artifactId
      expect(
          () => ArtifactExpiryReceipt(
              '', ReceiptType.MOSAIC_EXPIRED, ReceiptVersion.ARTIFACT_EXPIRY, 100),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message.toString().contains('Invalid ArtifactExpiryReceipt'))));

      // invalid receipt type
      expect(
          () =>
              ArtifactExpiryReceipt(id, ReceiptType.INFLATION, ReceiptVersion.ARTIFACT_EXPIRY, 100),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message.toString().contains('Invalid ArtifactExpiryReceipt'))));
    });
  });
}
