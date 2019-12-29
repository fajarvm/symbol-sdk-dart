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

library nem2_sdk_dart.sdk.model.restriction.mosaic_address_restriction;

import '../account/address.dart';
import '../mosaic/mosaic_id.dart';
import 'mosaic_restriction_entry_type.dart';

/// Mosaic address restriction structure describes address restriction information for a mosaic.
class MosaicAddressRestriction {
  /// The composite hash.
  final String compositeHash;

  /// The mosaic restriction entry type.
  final MosaicRestrictionEntryType entryType;

  /// Mosaic identifier.
  final MosaicId mosaicId;

  /// Target address.
  final Address targetAddress;

  /// Mosaic restriction items.
  final Map<String, String> restrictions;

  MosaicAddressRestriction(
      this.compositeHash, this.entryType, this.mosaicId, this.targetAddress, this.restrictions);
}
