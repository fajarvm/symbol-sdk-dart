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

library nem2_sdk_dart.test.sdk.model.message.encrypted_message_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show HexUtils;
import 'package:nem2_sdk_dart/sdk.dart' show Account, EncryptedMessage, MessageType, NetworkType;

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

    test('Valid constants', () {
      expect(EncryptedMessage.KEY_SIZE, 32);
      expect(EncryptedMessage.BLOCK_SIZE, 16);
    });

    test('Can create an encrypted message from a payload', () {
      const message = 'test';
      final messageHex = HexUtils.utf8ToHex(message);
      final encryptedMessage = EncryptedMessage.fromPayload(messageHex);

      expect(encryptedMessage.payload, equals(messageHex));
    });

    test('Cannot create an encrypted message from a payload', () {
      expect(
          () => EncryptedMessage.fromPayload(null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.contains('payload is not a valid'))));
      expect(
          () => EncryptedMessage.fromPayload('test'),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.contains('payload is not a valid'))));
    });

    test('Can create an encrypted message', () {
      final encryptedMessage = EncryptedMessage.create(
          'Hello', sender.privateKey, recipient.publicAccount.publicKey, NetworkType.MIJIN_TEST);

      expect(encryptedMessage.payload, isNotNull);
      expect(encryptedMessage.type, equals(MessageType.ENCRYPTED_MESSAGE));

      final decrypted = encryptedMessage.decrypt(
          sender.privateKey, recipient.publicAccount.publicKey, NetworkType.MIJIN_TEST);
      expect(decrypted, equals('Hello'));
    });

    test('Can create an encrypted message using NIS1 schema', () {
      final encryptedMessage = EncryptedMessage.create('Hello', sender_nis.privateKey,
          recipient_nis.publicAccount.publicKey, NetworkType.TEST_NET);

      expect(encryptedMessage.payload, isNotNull);
      expect(encryptedMessage.type, equals(MessageType.ENCRYPTED_MESSAGE));

      final decrypted = encryptedMessage.decrypt(
          sender_nis.privateKey, recipient_nis.publicAccount.publicKey, NetworkType.TEST_NET);
      expect(decrypted, equals('Hello'));
    });

    test('Cannot create an encrypted message without the message payload', () {
      expect(
          () => EncryptedMessage.create(
              null, sender.privateKey, recipient.publicAccount.publicKey, NetworkType.MIJIN_TEST),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Must not be null'))));
    });

    test('Cannot create an encrypted message without private/public key', () {
      expect(
          () => EncryptedMessage.create(
              'Hello', null, recipient.publicAccount.publicKey, NetworkType.MIJIN_TEST),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message.contains('Sender private key and recipient public key are required'))));
      expect(
          () => EncryptedMessage.create('Hello', senderPrivateKey, null, NetworkType.MIJIN_TEST),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message.contains('Sender private key and recipient public key are required'))));
      expect(
          () => EncryptedMessage.create('Hello', null, null, NetworkType.MIJIN_TEST),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message.contains('Sender private key and recipient public key are required'))));
    });
  });
}
