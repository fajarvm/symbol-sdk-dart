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

library symbol_sdk_dart.sdk.model.network.node_identity_equality_strategy;

/// Node identity equality strategy.
///
/// Defines if the identifier for the node must be its public key or host.
class NodeIdentityEqualityStrategy {
  static const String UNKNOWN_NODE_IDENTITY = 'node identifier is unknown';

  /// Host node identifier.
  static const NodeIdentityEqualityStrategy HOST = NodeIdentityEqualityStrategy._('host'); // 104

  /// Public-key node identifier.
  static const NodeIdentityEqualityStrategy PUBLIC_KEY =
      NodeIdentityEqualityStrategy._('public-key'); // 152

  /// Supported node identifier.
  static final List<NodeIdentityEqualityStrategy> values = <NodeIdentityEqualityStrategy>[
    HOST,
    PUBLIC_KEY
  ];

  /// The value of this node identifier.
  final String value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a ?value.
  const NodeIdentityEqualityStrategy._(this.value);

  /// Returns a [NodeIdentityEqualityStrategy] for the given value.
  ///
  /// Throws an error when the identifier is unknown.
  static NodeIdentityEqualityStrategy fromValue(final String value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_NODE_IDENTITY);
  }

  @override
  String toString() {
    return 'NodeIdentityEqualityStrategy{value: $value}';
  }
}
