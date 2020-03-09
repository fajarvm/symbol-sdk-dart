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

library symbol_sdk_dart.test.sdk.model.message.persistent_harvesting_delegation_message_test;

import 'package:convert/convert.dart' show hex;

import 'package:test/test.dart';

import 'package:symbol_sdk_dart/sdk.dart'
    show Account, EncryptedMessage, MessageType, NetworkType, PersistentHarvestingDelegationMessage;

void main() {
  group('PersistentHarvestingDelegationMessage', () {
    const String senderPrivateKey =
        '2602F4236B199B3DF762B2AAB46FC3B77D8DDB214F0B62538D3827576C46C108';
    const String recipientPrivateKey =
        'B72F2950498111BADF276D6D9D5E345F04E0D5C9B8342DA983C3395B4CF18F08';
    const String delegatedPrivateKey =
        'F0AB1010EFEE19EE5373719881DF5123C13E643C519655F7E97347BFF77175BF';

    final Account sender = Account.fromPrivateKey(senderPrivateKey, NetworkType.MIJIN_TEST);
    final Account recipient = Account.fromPrivateKey(recipientPrivateKey, NetworkType.MIJIN_TEST);
    final Account sender_nis = Account.fromPrivateKey(senderPrivateKey, NetworkType.TEST_NET);
    final Account recipient_nis = Account.fromPrivateKey(recipientPrivateKey, NetworkType.TEST_NET);

    test('Can create a PersistentHarvestingDelegation message', () {
      final encryptedMessage = PersistentHarvestingDelegationMessage.create(
          delegatedPrivateKey, sender.privateKey, recipient.publicKey, NetworkType.MIJIN_TEST);
      expect(encryptedMessage.payload.length, equals(208));
      expect(encryptedMessage.type, equals(MessageType.PERSISTENT_HARVESTING_DELEGATION_MESSAGE));
    });

    test('Can create a persistent harvesting delegation message from a payload', () {
      const payload = 'CC71C764BFE598FC121A1816D40600FF3CE1F5C8839DF6EA01A04A630CBEC5C8A'
          'C121C890E95BBDC67E50AD37E2442279D1BA2328FB7A1781C59D2F414AEFCA288CD'
          '7B2D9F38D11C186CBD33869F2BB6A9F617A4696E4841628F1F396478BDDD0046BA264A1820';
      final encryptedMessage = PersistentHarvestingDelegationMessage.fromPayload(payload);

      final String messageTypeHex =
          MessageType.PERSISTENT_HARVESTING_DELEGATION_MESSAGE.value.toRadixString(16);

      expect(encryptedMessage.payload.length, equals(208));
      expect(encryptedMessage.payload.substring(2), equals(payload));
      expect(encryptedMessage.type, equals(MessageType.PERSISTENT_HARVESTING_DELEGATION_MESSAGE));
      expect(encryptedMessage.payload.substring(0, 2), equals(messageTypeHex));
    });

    test('Should throw an error when creating a message from an invalid payload', () {
      expect(
          () => PersistentHarvestingDelegationMessage.fromPayload(null),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.contains('payload is not a valid'))));
      expect(
          () => PersistentHarvestingDelegationMessage.fromPayload('test'),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message.contains('payload is not a valid'))));
    });

    test('Can create and decrypt message (Catapult Schema)', () {
      final encryptedMessage = PersistentHarvestingDelegationMessage.create(
          delegatedPrivateKey,
          sender.privateKey.toUpperCase(),
          recipient.publicKey.toUpperCase(),
          NetworkType.MIJIN_TEST);
      expect(encryptedMessage.payload, isNotNull);
      expect(encryptedMessage.type, equals(MessageType.PERSISTENT_HARVESTING_DELEGATION_MESSAGE));

      final decryptedMessage = PersistentHarvestingDelegationMessage.decrypt(
          encryptedMessage,
          recipient.privateKey.toUpperCase(),
          sender.publicKey.toUpperCase(),
          NetworkType.MIJIN_TEST);
      hex.decode(decryptedMessage);

      expect(decryptedMessage.toUpperCase(), equals(delegatedPrivateKey));
    });

    test('Can create and decrypt message (NIS1 Schema)', () {
      final encryptedMessage = PersistentHarvestingDelegationMessage.create(delegatedPrivateKey,
          sender_nis.privateKey, recipient_nis.publicAccount.publicKey, NetworkType.TEST_NET);

      expect(encryptedMessage.payload, isNotNull);
      expect(encryptedMessage.type, equals(MessageType.PERSISTENT_HARVESTING_DELEGATION_MESSAGE));

      final String decrypted = PersistentHarvestingDelegationMessage.decrypt(encryptedMessage,
          recipient_nis.privateKey, sender_nis.publicAccount.publicKey, NetworkType.TEST_NET);
      expect(decrypted.toUpperCase(), equals(delegatedPrivateKey));
    });

    test('Cannot create a message without the message payload', () {
      expect(
          () => PersistentHarvestingDelegationMessage.create(
              null, sender.privateKey, recipient.publicAccount.publicKey, NetworkType.MIJIN_TEST),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Must not be null'))));
    });

    test('Cannot create a message without private/public key', () {
      expect(
          () => PersistentHarvestingDelegationMessage.create(
              delegatedPrivateKey, null, recipient.publicAccount.publicKey, NetworkType.MIJIN_TEST),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Must not be null'))));
      expect(() => EncryptedMessage.create('Hello', senderPrivateKey, null, NetworkType.MIJIN_TEST),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Must not be null'))));
      expect(() => EncryptedMessage.create('Hello', null, null, NetworkType.MIJIN_TEST),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Must not be null'))));
    });
  });
}
