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

library nem2_sdk_dart.sdk.model.transaction.messages.message_type;

/// The Message type.
///
/// Supported types are:
/// * 0: Plain text (Unencrypted).
/// * 1: Secured text (Encrypted).
class MessageType {
  static const String _INVALID_MESSAGE_TYPE = 'invalid message type';

  /// Plain text or unencrypted.
  static const int UNENCRYPTED = 0x00;

  /// Secured text or encrypted.
  static const int ENCRYPTED = 0x01;

  static final MessageType _singleton = new MessageType._();

  MessageType._();

  factory MessageType() {
    return _singleton;
  }

  static int getType(final int messageType) {
    switch (messageType) {
      case UNENCRYPTED:
        return MessageType.UNENCRYPTED;
      case ENCRYPTED:
        return MessageType.ENCRYPTED;
      default:
        throw new ArgumentError(_INVALID_MESSAGE_TYPE);
    }
  }
}
