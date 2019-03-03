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

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show NamespaceType;

void main() {
  group('NamespaceType', () {
    test('creating a new instance returns a singleton', () {
      final namespaceType1 = new NamespaceType();
      final namespaceType2 = new NamespaceType();

      expect(identical(namespaceType1, namespaceType2), isTrue);
    });

    test('valid namespace types', () {
      expect(NamespaceType.ROOT_NAMESPACE, 0);
      expect(NamespaceType.SUB_NAMESPACE, 1);
    });

    test('Can retrieve a valid namespace types', () {
      expect(NamespaceType.getNamespaceType(0), NamespaceType.ROOT_NAMESPACE);
      expect(NamespaceType.getNamespaceType(1), NamespaceType.SUB_NAMESPACE);
    });

    test('Trying to retrieve an invalid namespace type will throw an error', () {
      expect(() => NamespaceType.getNamespaceType(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'invalid namespace type')));
      expect(() => NamespaceType.getNamespaceType(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'invalid namespace type')));
      expect(() => NamespaceType.getNamespaceType(2),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'invalid namespace type')));
    });
  });
}
