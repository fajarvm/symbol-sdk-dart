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

library nem2_sdk_dart.test.sdk.model.transaction.messages.secure_message_test;

import 'dart:typed_data' show Uint8List;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show ArrayUtils, HexUtils;
import 'package:nem2_sdk_dart/sdk.dart' show MessageType, SecureMessage;

void main() {
  group('SecureMessage', () {
    final senderPrivateKey =
        HexUtils.getBytes('5949fc564c90ac186cd4f9d2b8298b677bca300b9d8f926ca04e1739e4ed0cba');
    final receiverPublicKey =
        HexUtils.getBytes('5949fc564c90ac186cd4f9d2b8298b677bca300b9d8f926ca04e1739e4ed0cba');

    const ERROR_KEY = 'Sender private key and receiver public key are required to create an '
        'encrypted message payload';

    test('Can create a secure message with an encrypted payload', () {
      final secureMessage = SecureMessage.create('Hello', senderPrivateKey, receiverPublicKey);

      expect(secureMessage.payload, isNotNull);
      expect(secureMessage.type, equals(MessageType.ENCRYPTED));

      final decrypted = secureMessage.decryptMessage(senderPrivateKey, receiverPublicKey);
      expect(decrypted, equals('Hello'));
    });

    test('Cannot create a secure message without the message payload', () {
      expect(() => SecureMessage.create(null, senderPrivateKey, receiverPublicKey),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'message cannot be null')));
    });

    test('Cannot create a secure message without private/public key', () {
      expect(() => SecureMessage.create('Hello', null, receiverPublicKey),
          throwsA(predicate((e) => e is ArgumentError && e.message == ERROR_KEY)));
      expect(() => SecureMessage.create('Hello', senderPrivateKey, null),
          throwsA(predicate((e) => e is ArgumentError && e.message == ERROR_KEY)));
      expect(() => SecureMessage.create('Hello', null, null),
          throwsA(predicate((e) => e is ArgumentError && e.message == ERROR_KEY)));
    });
  });
}
