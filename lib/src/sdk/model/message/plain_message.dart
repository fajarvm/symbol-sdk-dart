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

library symbol_sdk_dart.sdk.model.message.plain_message;

import 'package:symbol_sdk_dart/core.dart' show HexUtils;

import 'message.dart';
import 'message_type.dart';

/// The plain message model defines a message with plain unencrypted string.
///
/// When sending it to the network we transform the payload to hex-string.
class PlainMessage extends Message {
  static final PlainMessage EMPTY_MESSAGE = PlainMessage('');

  // private constructor
  PlainMessage._(String payload) : super(MessageType.PLAIN_MESSAGE, payload);

  factory PlainMessage(final String text) {
    ArgumentError.checkNotNull(text);

    return new PlainMessage._(text);
  }

  /// Creates a plain message object containing the given [message].
  static Message create(String message) {
    return PlainMessage(message);
  }

  /// Creates a plain message object from [payload]. The [payload] is a hex encoded string.
  static Message fromPayload(String payload) {
    if (!HexUtils.isHex(payload)) {
      throw new ArgumentError('message payload is not a valid hex string');
    }

    return PlainMessage(HexUtils.tryHexToUtf8(payload));
  }
}
