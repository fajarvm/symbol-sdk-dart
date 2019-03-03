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

library nem2_sdk_dart.test.sdk.model.transaction.messages.plain_message_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show ArrayUtils, HexUtils;
import 'package:nem2_sdk_dart/sdk.dart' show MessageType, PlainMessage;

void main() {
  group('PlainMessage', () {
    test('Valid constants', () {
      expect(PlainMessage.EMPTY_MESSAGE.type, equals(MessageType.UNENCRYPTED));
      expect(PlainMessage.EMPTY_MESSAGE.payload, equals(HexUtils.getBytes(HexUtils.utf8ToHex(''))));
    });

    test('Can create a plain message with the message payload in plain text', () {
      // Empty string
      String message = '';
      PlainMessage plainMessage = new PlainMessage(text: message);

      expect(plainMessage.payload, equals(HexUtils.getBytes(HexUtils.utf8ToHex(message))));
      expect(plainMessage.type, equals(MessageType.UNENCRYPTED));

      // Plain text
      message = 'This is a plain text message';
      plainMessage = new PlainMessage(text: message);

      expect(plainMessage.payload, equals(HexUtils.getBytes(HexUtils.utf8ToHex(message))));
      expect(plainMessage.type, equals(MessageType.UNENCRYPTED));

      // UTF-8 text
      message = '안녕하세요 test words |@#¢∞¬÷“”≠[]}{– ';
      plainMessage = new PlainMessage(text: message);

      expect(plainMessage.payload, equals(HexUtils.getBytes(HexUtils.utf8ToHex(message))));
      expect(plainMessage.type, equals(MessageType.UNENCRYPTED));
    });

    test('Can create a plain message with the message payload in hex string', () {
      const message = 'This is a plain text message';
      final hexString = HexUtils.utf8ToHex(message);
      final plainMessage = new PlainMessage(text: hexString);

      expect(plainMessage.payload, equals(HexUtils.getBytes(hexString)));
      expect(plainMessage.type, equals(MessageType.UNENCRYPTED));
    });

    test('Can create a plain message with the message payload in bytes', () {
      const message = 'This is a plain text message';
      final bytes = HexUtils.getBytes(HexUtils.utf8ToHex(message));
      final plainMessage = new PlainMessage(bytes: bytes);

      expect(ArrayUtils.deepEqual(plainMessage.payload, bytes), isTrue);
      expect(plainMessage.type, equals(MessageType.UNENCRYPTED));
    });

    test('Cannot create a plain message without the message payload', () {
      expect(
          () => PlainMessage(),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message == 'The message payload must not be null')));
      expect(
          () => PlainMessage(bytes: null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message == 'The message payload must not be null')));
      expect(
          () => PlainMessage(text: null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message == 'The message payload must not be null')));
      expect(
          () => PlainMessage(text: null, bytes: null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message == 'The message payload must not be null')));
    });
  });
}
