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

library symbol_sdk_dart.sdk.model.network.secret_lock_network_properties;

/// Value object for secret lock network properties.
class SecretLockNetworkProperties {
  /// Maximum number of blocks for which a secret lock can exist.
  final String maxSecretLockDuration;

  /// Minimum size of a proof in bytes.
  final String minProofSize;

  /// Maximum size of a proof in bytes.
  final String maxProofSize;

  SecretLockNetworkProperties(this.maxSecretLockDuration, this.minProofSize, this.maxProofSize);

  @override
  String toString() {
    return 'SecretLockNetworkProperties{maxSecretLockDuration: $maxSecretLockDuration, minProofSize: $minProofSize, maxProofSize: $maxProofSize}';
  }
}
