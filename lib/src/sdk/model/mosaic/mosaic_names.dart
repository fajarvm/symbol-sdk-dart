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

library symbol_sdk_dart.sdk.model.mosaic.mosaic_names;

import '../namespace/namespace_name.dart';
import 'mosaic_id.dart';

/// The friendly names of one mosaic. The names are namespaces linked using mosaic aliases.
class MosaicNames {
  /// The mosaic identifier.
  final MosaicId mosaicId;

  /// The linked namespace names.
  final List<NamespaceName> names;

  MosaicNames(this.mosaicId, this.names);

  @override
  String toString() {
    return 'MosaicNames{mosaicId: $mosaicId, names: $names}';
  }
}
