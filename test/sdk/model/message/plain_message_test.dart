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

library nem2_sdk_dart.test.sdk.model.message.plain_message_test;

import 'package:nem2_sdk_dart/core.dart' show HexUtils;
import 'package:nem2_sdk_dart/sdk.dart' show MessageType, PlainMessage;

import 'package:test/test.dart';

void main() {
  group('PlainMessage', () {
    test('Valid constants', () {
      expect(PlainMessage.EMPTY_MESSAGE.type, equals(MessageType.PLAIN_MESSAGE));
      expect(PlainMessage.EMPTY_MESSAGE.payload, equals(''));
    });

    test('Can create using constructor', () {
      // Empty string
      PlainMessage plainMessage = new PlainMessage('');

      expect(plainMessage.payload, equals(''));
      expect(plainMessage.type, equals(MessageType.PLAIN_MESSAGE));

      // Plain text
      String message = 'This is a plain text message';
      plainMessage = new PlainMessage(message);
      expect(plainMessage.payload, equals(message));

      // UTF-8 text
      message = '안녕하세요 test words |@#¢∞¬÷“”≠[]}{– ';
      plainMessage = new PlainMessage(message);
      expect(plainMessage.payload, equals(message));
    });

    test('create() - Can create using static constructor', () {
      // Empty string
      PlainMessage plainMessage = PlainMessage.create('');
      expect(plainMessage.payload, equals(''));
      expect(plainMessage.type, equals(MessageType.PLAIN_MESSAGE));

      // Plain text
      String message = 'This is a plain text message';
      plainMessage = PlainMessage.create(message);
      expect(plainMessage.payload, equals(message));

      // UTF-8 text
      message = '안녕하세요 test words |@#¢∞¬÷“”≠[]}{– ';
      plainMessage = PlainMessage.create(message);
      expect(plainMessage.payload, equals(message));
    });

    test('fromPayload() - Can create using static constructor', () {
      // Empty string
      PlainMessage plainMessage = PlainMessage.fromPayload('');
      expect(plainMessage.payload, equals(''));
      expect(plainMessage.type, equals(MessageType.PLAIN_MESSAGE));

      // Plain text
      String message = 'This is a plain text message';
      plainMessage = PlainMessage.fromPayload(HexUtils.utf8ToHex(message));
      expect(plainMessage.payload, equals(message));

      // UTF-8 text
      message = '안녕하세요 test words |@#¢∞¬÷“”≠[]}{– ';
      plainMessage = PlainMessage.fromPayload(HexUtils.utf8ToHex(message));
      expect(plainMessage.payload, equals(message));
    });

    test('Cannot create a plain message without the message', () {
      expect(() => PlainMessage(null),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Must not be null'))));
      expect(() => PlainMessage.create(null),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Must not be null'))));
    });

    test('Cannot create a plain message with an invalid payload', () {
      expect(
          () => PlainMessage.fromPayload(null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.contains('payload is not a valid'))));
      expect(
          () => PlainMessage.fromPayload('test'),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.contains('payload is not a valid'))));
    });
  });
}
