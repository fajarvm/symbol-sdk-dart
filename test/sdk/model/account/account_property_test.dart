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

library nem2_sdk_dart.test.sdk.model.account.account_property_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show ArrayUtils;
import 'package:nem2_sdk_dart/sdk.dart'
    show AccountProperty, PropertyModificationType, PropertyType;

void main() {
  group('AccountProperty', () {
    test('Can create an AccountProperty object', () {
      const values = [
        {
          'modificationType': PropertyModificationType.ADD,
          'value': 'SDUP5PLHDXKBX3UU5Q52LAY4WYEKGEWC6IB3VBFM'
        }
      ];
      final accountProperty = new AccountProperty(PropertyType.ALLOW_ADDRESS, values);

      // Assert
      expect(accountProperty.propertyType, equals(PropertyType.ALLOW_ADDRESS));
      expect(accountProperty.values.length, equals(values.length));
      expect(ArrayUtils.deepEqual(accountProperty.values, values), isTrue);
    });
  });
}
