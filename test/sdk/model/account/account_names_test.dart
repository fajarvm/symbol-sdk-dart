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

library symbol_sdk_dart.test.sdk.model.account.account_names_test;

import 'package:test/test.dart';

import 'package:symbol_sdk_dart/sdk.dart' show AccountNames, Address, NamespaceId, NamespaceName;

void main() {
  group('AccountNames', () {
    test('can create an AccountNames object', () {
      final address = Address.fromRawAddress('SDGLFWDSHILTIUHGIBH5UGX2VYF5VNJEKCCDBR26');
      final name1 = new NamespaceName(NamespaceId.fromFullName('alias1'), 'alias1');
      final name2 = new NamespaceName(NamespaceId.fromFullName('alias2'), 'alias2');
      final names = [name1, name2];

      final accountNames = AccountNames(address, names);

      expect(accountNames.address.plain, equals('SDGLFWDSHILTIUHGIBH5UGX2VYF5VNJEKCCDBR26'));
      expect(accountNames.names[0].name, equals('alias1'));
      expect(accountNames.names[1].name, equals('alias2'));

      // toString()
      final toString = 'AccountNames{address: $address, names: $names}';
      expect(accountNames.toString(), equals(toString));
    });
  });
}
