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

library symbol_sdk_dart.test.sdk.model.diagnostic.server_info_test;

import 'package:symbol_sdk_dart/sdk.dart' show ServerInfo;
import 'package:test/test.dart';

void main() {
  group('ServerInfo', () {
    test('Can create a ServerInfo object', () {
      String restVersion = '1.0';
      String sdkVersion = '0.5';
      ServerInfo serverInfo = new ServerInfo(restVersion, sdkVersion);
      expect(serverInfo.restVersion, equals(restVersion));
      expect(serverInfo.sdkVersion, equals(sdkVersion));
      expect(serverInfo.toString(),
          equals('ServerInfo{restVersion: $restVersion, sdkVersion: $sdkVersion}'));
    });
  });
}
