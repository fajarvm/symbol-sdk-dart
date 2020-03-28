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

library symbol_sdk_dart.sdk.model.network.mosaic_network_properties;

/// Value object for mosaic network properties.
class MosaicNetworkProperties {
  /// Maximum number of mosaics that an account can own.
  final String maxMosaicsPerAccount;

  /// Maximum mosaic duration.
  final String maxMosaicDuration;

  /// Maximum mosaic divisibility.
  final String maxMosaicDivisibility;

  /// Public key of the mosaic rental fee sink account.
  final String mosaicRentalFeeSinkPublicKey;

  /// Mosaic rental fee.
  final String mosaicRentalFee;

  MosaicNetworkProperties(
      this.maxMosaicsPerAccount,
      this.maxMosaicDuration,
      this.maxMosaicDivisibility,
      this.mosaicRentalFeeSinkPublicKey,
      this.mosaicRentalFee);

  @override
  String toString() {
    return 'MosaicNetworkProperties{maxMosaicsPerAccount: $maxMosaicsPerAccount, maxMosaicDuration: $maxMosaicDuration, maxMosaicDivisibility: $maxMosaicDivisibility, mosaicRentalFeeSinkPublicKey: $mosaicRentalFeeSinkPublicKey, mosaicRentalFee: $mosaicRentalFee}';
  }
}
