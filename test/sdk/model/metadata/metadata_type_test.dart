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

library symbol_sdk_dart.test.sdk.model.metadata.metadata_type_test;

import 'package:symbol_sdk_dart/sdk.dart' show MetadataType;
import 'package:test/test.dart';

void main() {
  group('MetadataType', () {
    test('valid metadata types', () {
      expect(MetadataType.ACCOUNT.value, 0);
      expect(MetadataType.MOSAIC.value, 01);
      expect(MetadataType.NAMESPACE.value, 2);

      expect(MetadataType.ACCOUNT.toString(),
          equals('MetadataType{value: ${MetadataType.ACCOUNT.value}}'));
    });

    test('Can retrieve valid metadata types', () {
      expect(MetadataType.getType(0), MetadataType.ACCOUNT);
      expect(MetadataType.getType(1), MetadataType.MOSAIC);
      expect(MetadataType.getType(2), MetadataType.NAMESPACE);
    });

    test('Trying to retrieve an invalid metadata type will throw an error', () {
      String errorMessage = MetadataType.UNKNOWN_METADATA_TYPE;
      expect(() => MetadataType.getType(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => MetadataType.getType(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => MetadataType.getType(3),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });
  });
}
