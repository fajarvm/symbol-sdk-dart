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

import '../transaction/id_generator.dart';
import '../transaction/uint64.dart';

/// The namespace id structure describes namespace id.
class NamespaceId {
  /// Namespace 64-bit unsigned integer id.
  final Uint64 id;

  /// Namespace full name (Examples: `nem`, or `universe.milky_way.planet_earth`).
  ///
  /// The full name can be empty when the namespace id is created using only the [Uint64] id.
  final String fullName;

  const NamespaceId._(this.id, this.fullName);

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

    if (id == null) {
      throw new ArgumentError('The id must not be null or empty');
    }

    return new NamespaceId._(id, null);
  }

  /// Creates a new [NamespaceId] from an [id].
  static NamespaceId fromId(final Uint64 id) {
    return new NamespaceId(id: id);
  }

  /// Creates a new [NamespaceId] from a [bigInt].
  static NamespaceId fromBigInt(final BigInt bigInt) {
    if (bigInt == null) {
      throw new ArgumentError('The bigInt must not be null');
    }
    return new NamespaceId(id: Uint64.fromBigInt(bigInt));
  }

  /// Creates a new [NamespaceId] from a [fullName].
  static NamespaceId fromFullName(final String fullName) {
    if (StringUtils.isEmpty(fullName)) {
      throw new ArgumentError('The fullName must not be null or empty');
    }

    return new NamespaceId(fullName: fullName);
  }

  /// Creates a new [NamespaceId] from a [hexString].
  static NamespaceId fromHex(final String hexString) {
    if (StringUtils.isEmpty(hexString)) {
      throw new ArgumentError('The hexString must not be null or empty');
    }

    if (!HexUtils.isHexString(hexString)) {
      throw new ArgumentError('invalid hex');
    }

    return new NamespaceId(id: Uint64.fromHex(hexString));
  }

  @override
  int get hashCode => 'NamespaceId'.hashCode ^ id.hashCode;

  @override
  bool operator ==(final other) => other is NamespaceId && id == other.id;

  @override
  String toString() => 'NamespaceId(id:$id, fullName:$fullName)';
}
