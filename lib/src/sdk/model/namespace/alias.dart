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

library nem2_sdk_dart.sdk.model.namespace.alias;

import '../account/address.dart';
import '../mosaic/mosaic_id.dart';

import 'alias_type.dart';

/// The alias structure defines an interface for Aliases.
// Developer Note:
// Dart doesn't have a syntax for declaring interfaces. Instead, every class implicitly defines an
// interface containing all the instance members of the class and of any interfaces it implements.
class Alias {
  /// The alias type.
  final AliasType type;

  /// The alias address.
  final Address address;

  /// The alias mosaicId.
  final MosaicId mosaicId;

  Alias._(this.type, [this.address, this.mosaicId]);

  @override
  String toString() {
    return 'Alias{type: $type, address: $address, mosaicId: $mosaicId}';
  }
}
