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

library nem2_sdk_dart.sdk.model.namespace.empty_alias;

import '../account/address.dart';
import '../mosaic/mosaic_id.dart';
import 'alias.dart';
import 'alias_type.dart';

/// The EmptyAlias structure describes empty aliases (type: 0).
class EmptyAlias implements Alias {
  EmptyAlias();

  /// The alias address. Always `null` for [EmptyAlias].
  @override
  Address get address => null;

  /// The alias mosaicId. Always `null` for [EmptyAlias].
  @override
  MosaicId get mosaicId => null;

  /// The alias type. Always [AliasType.NONE] (0).
  @override
  AliasType get type => AliasType.NONE;

  @override
  bool operator ==(final other) =>
      identical(this, other) ||
      other is EmptyAlias && this.runtimeType == other.runtimeType && this.type == other.type;

  @override
  int get hashCode => 'EmptyAlias'.hashCode ^ type.hashCode;
}
