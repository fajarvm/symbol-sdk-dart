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

library nem2_sdk_dart.test.sdk.model.transaction.messages.message_type_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show MessageType;

void main() {
  group('MessageType', () {
    test('creating a new instance returns a singleton', () {
      final type1 = new MessageType();
      final type2 = new MessageType();

      expect(identical(type1, type2), isTrue);
    });

    test('valid message types', () {
      expect(MessageType.UNENCRYPTED, 0x00);
      expect(MessageType.ENCRYPTED, 0x01);
    });

    test('Can retrieve valid message types', () {
      expect(MessageType.getMessageType(0), MessageType.UNENCRYPTED);
      expect(MessageType.getMessageType(1), MessageType.ENCRYPTED);
    });

    test('Trying to retrieve an invalid message type will throw an error', () {
      expect(() => MessageType.getMessageType(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'invalid message type')));
      expect(() => MessageType.getMessageType(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'invalid message type')));
      expect(() => MessageType.getMessageType(2),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'invalid message type')));
    });
  });
}
