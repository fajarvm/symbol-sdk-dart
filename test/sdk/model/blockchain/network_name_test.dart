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

library symbol_sdk_dart.test.sdk.model.blockchain.network_name_test;

import 'package:symbol_sdk_dart/sdk.dart' show NetworkName;
import 'package:test/test.dart';

void main() {
  group('NetworkName', () {
    test('Can create NetworkName object', () {
      const name = 'big alice';
      const description = 'This is the description of the network name big alice';
      final networkName = new NetworkName(name, description);
      expect(networkName.name, equals(name));
      expect(networkName.description, equals(description));
      expect(networkName.toString(), equals('NetworkName{name: $name, description: $description}'));
    });
  });
}
