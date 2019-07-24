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

library nem2_sdk_dart.sdk.model.namespace.namespace_id;

import 'package:nem2_sdk_dart/core.dart' show HexUtils, StringUtils;

import '../common/id.dart';
import '../common/id_generator.dart';
import '../common/uint64.dart';

/// The namespace id structure describes namespace id.
class NamespaceId extends Id {
  /// Namespace full name (Examples: `nem`, or `universe.milky_way.planet_earth`).
  ///
  /// The full name can be empty when the namespace id is created using only the [Uint64] id.
  final String fullName;

  // private constructor
  NamespaceId._(id, this.fullName) : super(id);

  /// Create a [NamespaceId] from a 64-bit unsigned integer [id] OR a namespace [fullName].
  ///
  /// When both the [id] and the [fullName] are provided, a new [id] will be generated from the
  /// provided [fullName] and the provided [id] will be ignored.
  factory NamespaceId({final Uint64 id, final String fullName}) {
    final String fullNamespaceName = StringUtils.trim(fullName);
    if (id == null && StringUtils.isEmpty(fullNamespaceName)) {
      throw new ArgumentError('Missing argument. Either id or fullName is required.');
    }

    if (StringUtils.isNotEmpty(fullNamespaceName)) {
      final Uint64 namespaceId = IdGenerator.generateNamespacePath(fullNamespaceName);
      return new NamespaceId._(namespaceId, fullNamespaceName);
    }

    ArgumentError.checkNotNull(id);

    return new NamespaceId._(id, null);
  }

  /// Creates a new [NamespaceId] from an [id].
  static NamespaceId fromId(final Uint64 id) {
    return new NamespaceId(id: id);
  }

  /// Creates a new [NamespaceId] from a [bigInt].
  static NamespaceId fromBigInt(final BigInt bigInt) {
    ArgumentError.checkNotNull(bigInt);

    return new NamespaceId(id: Uint64.fromBigInt(bigInt));
  }

  /// Creates a new [NamespaceId] from a [fullName].
  static NamespaceId fromFullName(final String fullName) {
    if (StringUtils.isEmpty(fullName)) {
      throw new ArgumentError('The fullName must not be null or empty');
    }

    return new NamespaceId(fullName: fullName);
  }

  /// Creates a new [NamespaceId] from a [hex].
  static NamespaceId fromHex(final String hex) {
    if (StringUtils.isEmpty(hex)) {
      throw new ArgumentError('The hexString must not be null or empty');
    }

    if (!HexUtils.isHex(hex)) {
      throw new ArgumentError('invalid hex');
    }

    return new NamespaceId(id: Uint64.fromHex(hex));
  }

  @override
  int get hashCode => 'NamespaceId'.hashCode ^ id.hashCode;

  @override
  bool operator ==(final other) => other is NamespaceId &&
      this.runtimeType == other.runtimeType &&
      this.id == other.id;

  @override
  String toString() => 'NamespaceId(id:$id, fullName:$fullName)';
}
