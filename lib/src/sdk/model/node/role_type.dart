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

library nem2_sdk_dart.sdk.model.node.role_type;

/// The role type of a node.
class RoleType {
  static const String UNKNOWN_ROLE_TYPE = 'unknown role type';

  /// Indicates a peer type node.
  static const RoleType PEER_NODE = RoleType._(1);

  /// Indicates an API type node.
  static const RoleType API_NODE = RoleType._(2);

  /// Supported role types.
  static final List<RoleType> values = <RoleType>[PEER_NODE, API_NODE];

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const RoleType._(this.value);

  /// Returns a [RoleType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static RoleType fromInt(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_ROLE_TYPE);
  }
}
