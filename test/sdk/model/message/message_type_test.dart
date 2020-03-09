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

library symbol_sdk_dart.test.sdk.model.message.message_type_test;

import 'package:symbol_sdk_dart/sdk.dart' show MessageType;
import 'package:test/test.dart';

void main() {
  group('MessageType', () {
    test('valid message types', () {
      expect(MessageType.PLAIN_MESSAGE.value, 0x00);
      expect(MessageType.ENCRYPTED_MESSAGE.value, 0x01);
      expect(MessageType.PERSISTENT_HARVESTING_DELEGATION_MESSAGE.value, 0xFE);

      expect(MessageType.PLAIN_MESSAGE.toString(),
          equals('MessageType{value: ${MessageType.PLAIN_MESSAGE.value}}'));
    });

    test('Can retrieve valid message types', () {
      expect(MessageType.getType(0), MessageType.PLAIN_MESSAGE);
      expect(MessageType.getType(1), MessageType.ENCRYPTED_MESSAGE);
      expect(MessageType.getType(254), MessageType.PERSISTENT_HARVESTING_DELEGATION_MESSAGE);
    });

    test('Trying to retrieve an invalid message type will throw an error', () {
      String errorMessage = MessageType.UNKNOWN_MESSAGE_TYPE;
      expect(() => MessageType.getType(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => MessageType.getType(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => MessageType.getType(2),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });
  });
}
