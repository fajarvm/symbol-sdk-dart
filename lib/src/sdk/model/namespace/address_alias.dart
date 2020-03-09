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

library symbol_sdk_dart.sdk.model.namespace.address_alias;

import '../account/address.dart';
import '../mosaic/mosaic_id.dart';
import 'alias.dart';
import 'alias_type.dart';

/// The AddressAlias structure describes address aliases.
class AddressAlias implements Alias {
  /// The alias address.
  @override
  final Address address;

  AddressAlias(this.address);

  /// The alias mosaicId. Always `null` for [AddressAlias].
  @override
  MosaicId get mosaicId => null;

  /// The alias type. Always [AliasType.ADDRESS] (2).
  @override
  AliasType get type => AliasType.ADDRESS;

  @override
  bool operator ==(final other) =>
      identical(this, other) ||
      other is AddressAlias &&
          this.runtimeType == other.runtimeType &&
          this.type == other.type &&
          this.address == other.address;

  @override
  int get hashCode => type.hashCode ^ address.hashCode;
}
