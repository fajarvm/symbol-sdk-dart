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

library nem2_sdk_dart.test.sdk.model.namespace.namespace_name_test;

import 'package:nem2_sdk_dart/sdk.dart' show NamespaceId, NamespaceName, Uint64;
import 'package:test/test.dart';

void main() {
  group('NamespaceName', () {
    test('Can create a NamespaceName object', () {
      final NEM_ID = Uint64.fromHex('84B3552D375FFA4B');
      final namespaceId = new NamespaceId(id: NEM_ID);
      final parentId = new NamespaceId(fullName: 'test');

      final namespaceName = new NamespaceName(namespaceId, 'nem', parentId);

      expect(namespaceName.namespaceId, equals(namespaceId));
      expect(namespaceName.name, equals('nem'));
      expect(namespaceName.parentId, equals(parentId));
      expect(
          namespaceName.toString(),
          equals(
              'NamespaceName{namespaceId: $namespaceId, name: ${namespaceName.name}, parentId: $parentId}'));
    });
  });
}
