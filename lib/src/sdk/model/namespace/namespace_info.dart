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

library nem2_sdk_dart.sdk.model.namespace.namespace_info;

import '../account/public_account.dart';
import '../common/uint64.dart';

import 'alias.dart';
import 'namespace_id.dart';

/// Contains information about a namespace
class NamespaceInfo {
  /// Determines if the namespace is active or not.
  final bool active;

  /// The namespace index.
  final int index;

  /// The meta ID.
  final String metaId;

  /// The namespace type, namespace and sub namespace.
  final int type;

  /// The level of namespace.
  final int depth;

  /// The namespace id levels.
  final List<NamespaceId> levels;

  /// The namespace parent id.
  final NamespaceId parentId;

  /// The owner of this namespace.
  final PublicAccount owner;

  /// The height (in blocks) at which the ownership begins.
  final Uint64 startHeight;

  /// The height (in blocks) at which the ownership ends.
  final Uint64 endHeight;

  /// The alias linked to a namespace.
  final Alias alias;

  const NamespaceInfo._(this.active, this.index, this.metaId, this.type, this.depth, this.levels,
      this.parentId, this.owner, this.startHeight, this.endHeight, this.alias);

  factory NamespaceInfo(
      final bool isActive,
      final int index,
      final String metaId,
      final int type,
      final int depth,
      final List<NamespaceId> levels,
      final NamespaceId parentId,
      final PublicAccount owner,
      final Uint64 startHeight,
      final Uint64 endHeight,
      final Alias alias) {
    if (0 > index) {
      throw new ArgumentError('index must not be negative');
    }
    if (0 > depth) {
      throw new ArgumentError('depth must not be negative');
    }

    if (levels == null || levels.isEmpty) {
      throw new ArgumentError('levels must not be null or empty');
    }

    return NamespaceInfo._(isActive, index, metaId, type, depth, levels, parentId, owner,
        startHeight, endHeight, alias);
  }

  /// Retrieves the namespace id.
  NamespaceId get id => this.levels[this.levels.length - 1];

  /// Determines if this is a namespace root.
  bool isRoot() {
    return this.type == 0;
  }

  /// Determines if this is a sub namespace.
  bool isSubnamespace() {
    return this.type == 1;
  }

  bool hasAlias() {
    return this.alias != null && this.alias.type != 0;
  }

  /// Retrieves the parent namespace id.
  NamespaceId parentNamespaceId() {
    if (this.isRoot()) {
      throw new ArgumentError('This is a root namespace');
    }
    return this.parentId;
  }
}
