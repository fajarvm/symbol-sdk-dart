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

library nem2_sdk_dart.sdk.model.message.message_type;

/// The Message type.
class MessageType {
  static const String UNKNOWN_MESSAGE_TYPE = 'unknown message type';

  /// Plain text or unencrypted message.
  static const MessageType PLAIN_MESSAGE = MessageType._(0x00); // 0

  /// Secured text or encrypted message.
  static const MessageType ENCRYPTED_MESSAGE = MessageType._(0x01); // 1

  /// Persistent harvesting delegation.
  static const MessageType PERSISTENT_HARVESTING_DELEGATION_MESSAGE = MessageType._(0xFE); // 254

  static final List<MessageType> values = <MessageType>[
    PLAIN_MESSAGE,
    ENCRYPTED_MESSAGE,
    PERSISTENT_HARVESTING_DELEGATION_MESSAGE
  ];

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const MessageType._(this.value);

  /// Returns a [AliasType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static MessageType getType(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_MESSAGE_TYPE);
  }
}
