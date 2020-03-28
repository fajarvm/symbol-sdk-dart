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

library symbol_sdk_dart.sdk.model.node.node_status;

/// The status of a node.
class NodeStatus {
  static const String UNKNOWN_STATUS = 'unknown node status';

  /// Indicates the node is up.
  static const NodeStatus UP = NodeStatus._('up');

  /// Indicates the node is down.
  static const NodeStatus DOWN = NodeStatus._('down');

  /// Supported status types.
  static final List<NodeStatus> values = <NodeStatus>[UP, DOWN];

  /// The value of this status.
  final String value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const NodeStatus._(this.value);

  /// Returns a [NodeStatus] for the given value.
  ///
  /// Throws an error when the status is unknown.
  static NodeStatus fromValue(final String value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_STATUS);
  }

  @override
  String toString() {
    return 'NodeStatus{value: $value}';
  }
}
