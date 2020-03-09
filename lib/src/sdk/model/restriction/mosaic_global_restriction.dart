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

library symbol_sdk_dart.sdk.model.restriction.mosaic_global_restriction;

import '../mosaic/mosaic_id.dart';
import 'mosaic_global_restriction_item.dart';
import 'mosaic_restriction_entry_type.dart';

/// Mosaic global restriction structure describes mosaicId restriction information for a mosaic.
class MosaicGlobalRestriction {
  /// The composite hash.
  final String compositeHash;

  /// The mosaic restriction entry type.
  final MosaicRestrictionEntryType entryType;

  /// Mosaic identifier.
  final MosaicId mosaicId;

  /// Mosaic restriction items.
  final Map<String, MosaicGlobalRestrictionItem> restrictions;

  MosaicGlobalRestriction(this.compositeHash, this.entryType, this.mosaicId, this.restrictions);
}
