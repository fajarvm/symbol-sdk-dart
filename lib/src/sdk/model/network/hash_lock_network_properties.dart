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

library symbol_sdk_dart.sdk.model.network.hash_lock_network_properties;

/// Value object for hash lock network properties.
class HashLockNetworkProperties {
  /// Amount that has to be locked per aggregate in partial cache.
  final String lockedFundsPerAggregate;

  /// Maximum number of blocks for which a hash lock can exist.
  final String maxHashLockDuration;

  HashLockNetworkProperties(this.lockedFundsPerAggregate, this.maxHashLockDuration);

  @override
  String toString() {
    return 'HashLockNetworkProperties{lockedFundsPerAggregate: $lockedFundsPerAggregate, maxHashLockDuration: $maxHashLockDuration}';
  }
}
