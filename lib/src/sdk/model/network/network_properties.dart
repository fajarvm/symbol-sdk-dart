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

library symbol_sdk_dart.sdk.model.network.network_properties;

import 'node_identity_equality_strategy.dart';

/// Network related configuration properties.
class NetworkProperties {
  /// Network identifier.
  final String identifier;

  /// Defines if the identifier for the node must be its public key or host.
  final NodeIdentityEqualityStrategy nodeEqualityStrategy;

  /// Nemesis public key.
  final String publicKey;

  /// Nemesis generation hash.
  final String generationHash;

  /// Nemesis epoch time adjustment.
  final String epochAdjustment;

  NetworkProperties(this.identifier, this.nodeEqualityStrategy, this.publicKey, this.generationHash,
      this.epochAdjustment);

  @override
  String toString() {
    return 'NetworkProperties{identifier: $identifier, nodeEqualityStrategy: $nodeEqualityStrategy, publicKey: $publicKey, generationHash: $generationHash, epochAdjustment: $epochAdjustment}';
  }
}
