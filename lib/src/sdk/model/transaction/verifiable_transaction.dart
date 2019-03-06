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

/// Represents the VerifiableTransaction model object.
class VerifiableTransaction {
  /// The bytes after flatbuffers.
  final Uint8List bytes;

  /// Schema definition corresponding to flatbuffer Schema.
  final Schema schema;

  VerifiableTransaction(this.bytes, this.schema);

  /// Returns the catapult bytes buffer of this transaction bytes based on its [Schema] definition.
  Uint8List serialize() {
    return schema.serialize(Uint8List.fromList(bytes.toList()));
  }

  /// Creates a SHA3-256 transaction hash of the [payloadHex].
  ///
  /// Returns a hex string representation of the hash.
  static String createTransactionHash(final String payloadHex) {
    final Uint8List payload = HexUtils.getBytes(payloadHex);
    final List<int> signingPart = payload.skip(4).take(32).toList();
    final List<int> keyPart = payload.skip(4 + 64).take(payload.length - (4 + 64)).toList();
    final Uint8List signingBytes = Uint8List.fromList(signingPart + keyPart);

    final Uint8List hash = Ed25519.createSha3Digest(length: 32).process(signingBytes);
    final String hashHex = HexUtils.getString(hash);

    return hashHex;
  }

  /// Sign this transaction with the given [keypair].
  ///
  /// Returns the signed transaction payload as a hex string.
  String signTransaction(final KeyPair keypair) {
    final Uint8List buffer = this.serialize();
    final List<int> tx = buffer.skip(4).take(buffer.length - 4).toList();
    final KeyPair kp = KeyPair.fromPrivateKey(HexUtils.getString(keypair.privateKey));
    final Uint8List signing = Uint8List.fromList(buffer.take(4 + 64 + 32).toList());
    final Uint8List signature = KeyPair.signData(kp, signing);
    final Uint8List payload = Uint8List.fromList(tx + signature.toList() + kp.publicKey.toList());

    return HexUtils.getString(payload);
  }

  /// Extracts the aggregate part from the [input].
  static Uint8List extractAggregatePart(final Uint8List input) {
    final List<int> part1 = input.skip(4 + 64).take(32 + 2 + 2).toList();
    final List<int> part2 = input
        .skip(4 + 64 + 32 + 2 + 2 + 8 + 8)
        .take(input.length - (4 + 64 + 32 + 2 + 2 + 8 + 8))
        .toList();

    return Uint8List.fromList(part1 + part2);
  }
}
