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

library symbol_sdk_dart.test.sdk.model.namespace.namespace_registration_type_test;

import 'package:symbol_sdk_dart/sdk.dart' show NamespaceRegistrationType;
import 'package:test/test.dart';

void main() {
  group('NamespaceRegistrationType', () {
    test('valid namespace types', () {
      expect(NamespaceRegistrationType.ROOT_NAMESPACE.value, 0);
      expect(NamespaceRegistrationType.SUB_NAMESPACE.value, 1);

      expect(NamespaceRegistrationType.ROOT_NAMESPACE.toString(),
          equals('NamespaceRegistrationType{value: ${NamespaceRegistrationType.ROOT_NAMESPACE.value}}'));
    });

    test('Can retrieve a valid namespace type', () {
      expect(NamespaceRegistrationType.fromInt(0), NamespaceRegistrationType.ROOT_NAMESPACE);
      expect(NamespaceRegistrationType.fromInt(1), NamespaceRegistrationType.SUB_NAMESPACE);
    });

    test('Trying to retrieve an invalid namespace type will throw an error', () {
      String errorMessage = NamespaceRegistrationType.UNKNOWN_NAMESPACE_REGISTRATION_TYPE;
      expect(() => NamespaceRegistrationType.fromInt(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => NamespaceRegistrationType.fromInt(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => NamespaceRegistrationType.fromInt(2),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });
  });
}
