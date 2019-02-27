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

library nem2_sdk_dart.sdk.model.transaction.transaction_helper;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/core.dart' show Ed25519;

/// A helper class for transactions.
class TransactionHelper {
  /// Create a SHA3-256 hash of the [input] bytes.
  static Uint8List hash(final Uint8List input) {
    final List<int> sign = input.skip(4).take(32).toList();
    final List<int> key = input.skip(4 + 64).take(input.length - (4 + 64)).toList();
    final Uint8List signAndKey = Uint8List.fromList(sign + key);

    return Ed25519.createSha3Hasher(length: 32).process(signAndKey);
  }

  /// Extracts the aggregate part from the [input] bytes.
  static Uint8List extractAggregateBytes(final Uint8List input) {
    final List<int> part1 = input.skip(4 + 64).take(32 + 2 + 2).toList();
    final List<int> part2 = input
        .skip(4 + 64 + 32 + 2 + 2 + 8 + 8)
        .take(input.length - (4 + 64 + 32 + 2 + 2 + 8 + 8))
        .toList();

    return Uint8List.fromList(part1 + part2);
  }
}
