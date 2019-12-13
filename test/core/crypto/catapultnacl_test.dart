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

library nem2_sdk_dart.test.core.crypto.catapultnacl_test;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/core.dart' show HexUtils, CatapultNacl;
import 'package:test/test.dart';

void main() {
  group('CatapultNacl', () {
    test('hex encode/decode', () {
      String plainMessage = 'Hello NEM';
      String hexEncoded = HexUtils.utf8ToHex(plainMessage);
      expect(hexEncoded, equals('48656c6c6f204e454d'));

      List<int> decoded = CatapultNacl.hexDecode(hexEncoded);

      String expected = CatapultNacl.hexEncodeToString(Uint8List.fromList(decoded));
      expect(expected, equals(hexEncoded.toUpperCase()));
    });

    test('create random bytes', () {
      Uint8List randomBytes = CatapultNacl.secureRandomBytes(8);
      expect(randomBytes.lengthInBytes, 8);

      randomBytes = CatapultNacl.secureRandomBytes(32);
      expect(randomBytes.lengthInBytes, 32);
    });
  });
}
