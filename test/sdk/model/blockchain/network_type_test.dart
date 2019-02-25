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

library nem2_sdk_dart.test.sdk.model.blockchain.network_type_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show NetworkType;

void main() {
  group('NetworkType', () {
    test('valid network types', () {
      // Main net
      expect(NetworkType.MAIN_NET, 0x68);
      expect(NetworkType.MAIN_NET, 104);
      // Test net
      expect(NetworkType.TEST_NET, 0x98);
      expect(NetworkType.TEST_NET, 152);
      // Mijin main net
      expect(NetworkType.MIJIN, 0x60);
      expect(NetworkType.MIJIN, 96);
      // Mijin test net
      expect(NetworkType.MIJIN_TEST, 0x90);
      expect(NetworkType.MIJIN_TEST, 144);
    });
  });

  group('getNetworkType()', () {
    test('Can identify a valid NetworkType', () {
      expect(NetworkType.getNetworkType(0x68), NetworkType.MAIN_NET);
      expect(NetworkType.getNetworkType(104), NetworkType.MAIN_NET);
      expect(NetworkType.getNetworkType(0x98), NetworkType.TEST_NET);
      expect(NetworkType.getNetworkType(152), NetworkType.TEST_NET);
      expect(NetworkType.getNetworkType(0x60), NetworkType.MIJIN);
      expect(NetworkType.getNetworkType(96), NetworkType.MIJIN);
      expect(NetworkType.getNetworkType(0x90), NetworkType.MIJIN_TEST);
      expect(NetworkType.getNetworkType(144), NetworkType.MIJIN_TEST);
    });

    test('invalid or unknown network type should throw an error', () {
      expect(() => NetworkType.getNetworkType(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'network type is unknown')));
      expect(() => NetworkType.getNetworkType(0),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'network type is unknown')));
      expect(() => NetworkType.getNetworkType(103),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'network type is unknown')));
    });
  });

  group('isValidNetworkType()', () {
    test('Can identify that a network tye is valid/supported', () {
      expect(NetworkType.isValidNetworkType(NetworkType.MAIN_NET), isTrue);
      expect(NetworkType.isValidNetworkType(0x68), isTrue);
      expect(NetworkType.isValidNetworkType(104), isTrue);
      expect(NetworkType.isValidNetworkType(NetworkType.TEST_NET), isTrue);
      expect(NetworkType.isValidNetworkType(0x98), isTrue);
      expect(NetworkType.isValidNetworkType(152), isTrue);
      expect(NetworkType.isValidNetworkType(NetworkType.MIJIN), isTrue);
      expect(NetworkType.isValidNetworkType(0x60), isTrue);
      expect(NetworkType.isValidNetworkType(96), isTrue);
      expect(NetworkType.isValidNetworkType(NetworkType.MIJIN_TEST), isTrue);
      expect(NetworkType.isValidNetworkType(0x90), isTrue);
      expect(NetworkType.isValidNetworkType(144), isTrue);
    });

    test('Can identify that a network tye is invalid or is unknown', () {
      expect(NetworkType.isValidNetworkType(0), isFalse);
      expect(NetworkType.isValidNetworkType(0x00), isFalse);
      expect(NetworkType.isValidNetworkType(0xFF), isFalse);
      expect(NetworkType.isValidNetworkType(103), isFalse);
    });
  });
}
