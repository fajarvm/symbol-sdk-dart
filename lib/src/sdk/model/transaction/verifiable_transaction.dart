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

library nem2_sdk_dart.sdk.model.transaction.verifiable_transaction;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/core.dart' show HexUtils, Ed25519, KeyPair;

import '../../schema.dart' show Schema;

/// Represents the VerifiableTransaction model object
class VerifiableTransaction {
  /// The bytes after flat-buffers
  final Uint8List bytes;

  /// Schema definition corresponding to flatbuffer Schema
  final Schema schema;

  VerifiableTransaction(this.bytes, this.schema);

  /// Returns the catapult bytes buffer of this transaction bytes based on its [Schema] definition.
  Uint8List serialize() {
    return schema.serialize(bytes);
  }

  /// Creates a SHA3-256 transaction hash of the [payloadHex].
  ///
  /// Returns a hex string representation of the hash.
  static String createTransactionHash(final String payloadHex) {
    final Uint8List payloadBytes = HexUtils.getBytes(payloadHex);
    final List<int> signingPart = payloadBytes.skip(4).take(32).toList();
    final List<int> keyPart =
        payloadBytes.skip(4 + 64).take(payloadBytes.length - (4 + 64)).toList();
    final Uint8List signingBytes = Uint8List.fromList(signingPart + keyPart);

    final Uint8List hash = Ed25519.createSha3Digest(length: 32).process(signingBytes);
    final String hashHex = HexUtils.getString(hash);

    return hashHex;
  }

  /// Sign this transaction with the given [keypair].
  ///
  /// Returns the signed transaction payload as a hex string.
  String signTransaction(final KeyPair keypair) {
    final Uint8List byteBuffer = this.serialize();
    final List<int> signingPart = byteBuffer.take(4 + 64 + 32).toList();
    final KeyPair kp = KeyPair.fromPrivateKey(HexUtils.getString(keypair.privateKey));
    final Uint8List signature = KeyPair.signData(kp, Uint8List.fromList(signingPart));
    final List<int> txPart = byteBuffer.skip(4).take(byteBuffer.length - 4).toList();
    final Uint8List payload =
        Uint8List.fromList(txPart + signature.toList() + kp.publicKey.toList());

    return HexUtils.getString(payload);
  }
}
