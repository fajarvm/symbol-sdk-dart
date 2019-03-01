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

library nem2_sdk_dart.sdk.model.namespace.address_alias;

import '../account/address.dart';
import '../mosaic/mosaic_id.dart';

import 'alias.dart';
import 'alias_type.dart';

/// The AddressAlias structure describes address aliases.
class AddressAlias implements Alias {
  final Address _address;

  AddressAlias(this._address);

  /// The alias address.
  @override
  Address get address => this._address;

  /// The alias mosaicId. Always `null` for [AddressAlias].
  @override
  MosaicId get mosaicId => null;

  /// The alias type. Always [AliasType.ADDRESS] (2).
  @override
  int get type => AliasType.ADDRESS;

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is AddressAlias &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          _address == other._address;

  @override
  int get hashCode => type.hashCode ^ _address.hashCode;
}
