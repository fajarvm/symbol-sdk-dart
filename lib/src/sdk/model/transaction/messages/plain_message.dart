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

library nem2_sdk_dart.sdk.model.transaction.messages.plain_message;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/core.dart' show HexUtils;

import 'message.dart';
import 'message_type.dart';

/// The plain message model defines a message with plain unencrypted string.
///
/// When sending it to the network we transform the payload to hex-string.
class PlainMessage extends Message {
  static final PlainMessage EMPTY_MESSAGE = new PlainMessage(text: '');

  // private constructor
  PlainMessage._(Uint8List payload) : super(MessageType.UNENCRYPTED, payload);

  factory PlainMessage({final Uint8List bytes, final String text}) {
    if (text == null && bytes == null) {
      throw new ArgumentError('The message payload must not be null');
    }

    // Bytes as the payload
    if (bytes != null && bytes.isNotEmpty) {
      return new PlainMessage._(bytes);
    }

    // Hex string message payload
    if (HexUtils.isHexString(text)) {
      return new PlainMessage._(HexUtils.getBytes(text));
    }

    // Text (UTF-8) message payload
    return new PlainMessage._(HexUtils.getBytes(HexUtils.utf8ToHex(text)));
  }
}
