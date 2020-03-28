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

library symbol_sdk_dart.test.sdk.model.message.encrypted_message_test;

import 'package:symbol_sdk_dart/core.dart' show HexUtils;
import 'package:symbol_sdk_dart/sdk.dart'
    show Account, EncryptedMessage, MessageType, NetworkType, PlainMessage;
import 'package:test/test.dart';

void main() {
  group('EncryptedMessage', () {
    const String senderPrivateKey =
        '2602F4236B199B3DF762B2AAB46FC3B77D8DDB214F0B62538D3827576C46C108';
    const String recipientPrivateKey =
        'B72F2950498111BADF276D6D9D5E345F04E0D5C9B8342DA983C3395B4CF18F08';

    final Account sender = Account.fromPrivateKey(senderPrivateKey, NetworkType.MIJIN_TEST);
    final Account recipient = Account.fromPrivateKey(recipientPrivateKey, NetworkType.MIJIN_TEST);
    final Account sender_nis = Account.fromPrivateKey(senderPrivateKey, NetworkType.TEST_NET);
    final Account recipient_nis = Account.fromPrivateKey(recipientPrivateKey, NetworkType.TEST_NET);

    test('Can create an encrypted message from a payload', () {
      const message = 'test';
      final messageHex = HexUtils.utf8ToHex(message);
      final encryptedMessage = EncryptedMessage.fromPayload(messageHex);

      expect(encryptedMessage.payload, equals(messageHex));

      expect(encryptedMessage.toString(),
          equals('Message{type: ${encryptedMessage.type}, payload: ${encryptedMessage.payload}}'));
    });

    test('Should throw an error when creating an encrypted message from am invalid payload', () {
      expect(
          () => EncryptedMessage.fromPayload(null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.contains('payload is not a valid'))));
      expect(
          () => EncryptedMessage.fromPayload('test'),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.contains('payload is not a valid'))));
    });

    test('Can encrypt and decrypt a message (Catapult Schema)', () {
      const message = 'Testing simple transfer';

      // encrypt
      final encryptedMessage =
          EncryptedMessage.create(message, sender.privateKey, recipient.publicAccount.publicKey);
      expect(encryptedMessage.payload, isNotNull);
      expect(encryptedMessage.type, equals(MessageType.ENCRYPTED_MESSAGE));

      // decrypt
      final PlainMessage decrypted = EncryptedMessage.decrypt(
          encryptedMessage, recipient.privateKey, sender.publicAccount.publicKey);
      expect(decrypted.type, equals(MessageType.PLAIN_MESSAGE));
      expect(decrypted.payload, equals(message));
    });

    test('Can encrypt and decrypt a message (NIS1 Schema)', () {
      final encryptedMessage = EncryptedMessage.create(
          'Hello', sender_nis.privateKey, recipient_nis.publicAccount.publicKey);

      expect(encryptedMessage.payload, isNotNull);
      expect(encryptedMessage.type, equals(MessageType.ENCRYPTED_MESSAGE));

      final PlainMessage decrypted = EncryptedMessage.decrypt(
          encryptedMessage, recipient_nis.privateKey, sender_nis.publicAccount.publicKey);
      expect(decrypted.payload, equals('Hello'));
      expect(decrypted.type, equals(MessageType.PLAIN_MESSAGE));
    });

    test('Should fail when creating an encrypted message with null', () {
      expect(
          () => EncryptedMessage.create(null, sender.privateKey, recipient.publicAccount.publicKey),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Must not be null'))));
    });

    test('Should fail when creating an encrypted message without private/public key', () {
      expect(() => EncryptedMessage.create('Hello', null, recipient.publicAccount.publicKey),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Must not be null'))));
      expect(() => EncryptedMessage.create('Hello', senderPrivateKey, null),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Must not be null'))));
      expect(() => EncryptedMessage.create('Hello', null, null),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Must not be null'))));
    });
  });
}
