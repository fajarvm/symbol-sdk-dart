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

library nem2_sdk_dart.sdk.model.namespace.mosaic_alias;

import '../account/address.dart';
import '../mosaic/mosaic_id.dart';

import 'alias.dart';
import 'alias_type.dart';

/// The MosaicAlias structure describes mosaic aliases.
class MosaicAlias implements Alias {
  final MosaicId _mosaicId;

  MosaicAlias(this._mosaicId);

  /// The alias address. Always `null` for [MosaicAlias].
  @override
  Address get address => null;

  /// The alias mosaicId.
  @override
  MosaicId get mosaicId => this._mosaicId;

  /// The alias type. Always [AliasType.MOSAIC] (1).
  @override
  AliasType get type => AliasType.MOSAIC;

  @override
  bool operator ==(final other) =>
      identical(this, other) ||
      other is MosaicAlias &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          _mosaicId == other._mosaicId;

  @override
  int get hashCode => type.hashCode ^ _mosaicId.hashCode;

  /// Get the hex string representative of the mosaicId.
  String toHex() {
    return mosaicId.toHex();
  }
}
