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

library nem2_sdk_dart.test.sdk.model.account.account_properties_info_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show ArrayUtils;
import 'package:nem2_sdk_dart/sdk.dart'
    show
        AccountProperty,
        AccountProperties,
        AccountPropertiesInfo,
        Address,
        PropertyModificationType,
        PropertyType;

void main() {
  group('AccountPropertiesInfo', () {
    test('Can create an AccountPropertiesInfo object', () {
      final meta = {'id': '12345'};
      final address = Address.fromEncoded('9050B9837EFAB4BBE8A4B9BB32D812F9885C00D8FC1650E142');
      final property = new AccountProperty(PropertyType.ALLOW_ADDRESS, [
        {
          'modificationType': PropertyModificationType.ADD,
          'value': 'SDUP5PLHDXKBX3UU5Q52LAY4WYEKGEWC6IB3VBFM',
        }
      ]);
      final accountProperties = new AccountProperties(address, [property]);
      final propertyList = <AccountProperties>[accountProperties];

      // create
      final accountPropertiesInfo = new AccountPropertiesInfo(meta, propertyList);

      // Assert
      expect(accountPropertiesInfo.meta['id'], equals(meta['id']));
      expect(accountPropertiesInfo.accountProperties.length, 1);
      expect(ArrayUtils.deepEqual(accountPropertiesInfo.accountProperties, propertyList), isTrue);
    });
  });
}
