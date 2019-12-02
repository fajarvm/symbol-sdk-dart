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

library nem2_sdk_dart.test.sdk.model.namespace.namespace_type_test;

import 'package:nem2_sdk_dart/sdk.dart' show NamespaceType;
import 'package:test/test.dart';

void main() {
  group('NamespaceType', () {
    test('valid namespace types', () {
      expect(NamespaceType.ROOT_NAMESPACE.value, 0);
      expect(NamespaceType.SUB_NAMESPACE.value, 1);

      expect(NamespaceType.ROOT_NAMESPACE.toString(),
          equals('NamespaceType{value: ${NamespaceType.ROOT_NAMESPACE.value}}'));
    });

    test('Can retrieve a valid namespace type', () {
      expect(NamespaceType.fromInt(0), NamespaceType.ROOT_NAMESPACE);
      expect(NamespaceType.fromInt(1), NamespaceType.SUB_NAMESPACE);
    });

    test('Trying to retrieve an invalid namespace type will throw an error', () {
      String errorMessage = NamespaceType.UNKNOWN_NAMESPACE_TYPE;
      expect(() => NamespaceType.fromInt(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => NamespaceType.fromInt(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => NamespaceType.fromInt(2),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });
  });
}
