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

library symbol_sdk_dart.sdk.model.network.mosaic_restriction_network_properties;

/// Value object for mosaic restriction network properties.
class MosaicRestrictionNetworkProperties {
  /// Maximum number of mosaic restriction values.
  final String maxMosaicRestrictionValues;

  MosaicRestrictionNetworkProperties(this.maxMosaicRestrictionValues);

  @override
  String toString() {
    return 'MosaicRestrictionNetworkProperties{maxMosaicRestrictionValues: $maxMosaicRestrictionValues}';
  }
}