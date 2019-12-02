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

library nem2_sdk_dart.sdk.model.mosaic.mosaic_name;

import '../namespace/namespace_id.dart';
import 'mosaic_id.dart';

/// The mosaic name info structure describes basic information of a mosaic and name.
class MosaicName {
  /// The mosaic identifier.
  final MosaicId mosaicId;

  /// The mosaic name.
  final String name;

  /// The namespace identifier this mosaic belongs to.
  final NamespaceId parentId;

  MosaicName(this.mosaicId, this.name, this.parentId);

  @override
  String toString() {
    return 'MosaicName{mosaicId: $mosaicId, name: $name, parentId: $parentId}';
  }
}
