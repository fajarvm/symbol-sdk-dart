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

library symbol_sdk_dart.sdk.model.message.persistent_harvesting_delegation_message;

import 'package:symbol_sdk_dart/core.dart' show CryptoUtils, HexUtils;

import '../account/account.dart';
import '../network/network_type.dart';
import 'message.dart';
import 'message_marker.dart';
import 'message_type.dart';

class PersistentHarvestingDelegationMessage extends Message {
  // private constructor
  PersistentHarvestingDelegationMessage._(String encryptedPayload)
      : super(MessageType.PERSISTENT_HARVESTING_DELEGATION_MESSAGE, encryptedPayload);

  /// Creates a persistent harvesting delegation message for the [networkType].
  static PersistentHarvestingDelegationMessage create(final String delegatedPrivateKey,
      final String recipientPublicKey, final NetworkType networkType) {
    ArgumentError.checkNotNull(delegatedPrivateKey);
    ArgumentError.checkNotNull(networkType);

    if (!HexUtils.isHex(delegatedPrivateKey)) {
      throw new ArgumentError('delegatedPrivateKey is not a valid hex string');
    }

    // Create an ephemeral keypair
    final Account ephemeralAcc = Account.generate(networkType);

    // Encrypts the message
    final String encryptedPayload = CryptoUtils.encryptMessage(
        delegatedPrivateKey, ephemeralAcc.privateKey, recipientPublicKey, true);
    final result = MessageMarker.PERSISTENT_DELEGATION_UNLOCK + ephemeralAcc.publicKey + encryptedPayload.toUpperCase();

    return PersistentHarvestingDelegationMessage._(result);
  }

  /// Creates a persistent harvesting delegation message from [payload].
  ///
  /// The [payload] is a hex encoded string.
  static PersistentHarvestingDelegationMessage fromPayload(final String payload) {
    if (!HexUtils.isHex(payload)) {
      throw new ArgumentError('message payload is not a valid hex string');
    }

    final String prefix =
        MessageType.PERSISTENT_HARVESTING_DELEGATION_MESSAGE.value.toRadixString(16);

    return new PersistentHarvestingDelegationMessage._(
        prefix.toUpperCase() + payload.toUpperCase());
  }

  /// Decrypts a persistent harvesting delegation message.
  ///
  /// Returns a hex formatted string.
  static String decrypt(final PersistentHarvestingDelegationMessage encryptedMessage,
      final String recipientPrivateKey, final NetworkType networkType) {
    ArgumentError.checkNotNull(encryptedMessage);
    ArgumentError.checkNotNull(encryptedMessage.payload);
    ArgumentError.checkNotNull(networkType);

    const int markerLength = MessageMarker.PERSISTENT_DELEGATION_UNLOCK.length;
    final String ephemeralPublicKey =
        encryptedMessage.payload.substring(markerLength, markerLength + 64);
    final String payload =
        encryptedMessage.payload.substring(markerLength + ephemeralPublicKey.length);
    final String decrypted =
        CryptoUtils.decryptMessage(payload, recipientPrivateKey, ephemeralPublicKey, true);

    return decrypted.toUpperCase();
  }
}
