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

library symbol_sdk_dart.sdk.model.network.namespace_network_properties;

/// Value object for namespace network properties.
class NamespaceNetworkProperties {
  /// Maximum namespace name size.
  final String maxNameSize;

  /// Maximum number of children for a root namespace.
  final String maxChildNamespaces;

  /// Maximum namespace depth.
  final String maxNamespaceDepth;

  /// Minimum namespace duration.
  final String minNamespaceDuration;

  /// Maximum namespace duration.
  final String maxNamespaceDuration;

  /// Grace period during which time only the previous owner can renew an expired namespace.
  final String namespaceGracePeriodDuration;

  /// Reserved root namespaces that cannot be claimed.
  final String reservedRootNamespaceNames;

  /// Public key of the namespace rental fee sink account.
  final String namespaceRentalFeeSinkPublicKey;

  /// Root namespace rental fee per block.
  final String rootNamespaceRentalFeePerBlock;

  /// Child namespace rental fee.
  final String childNamespaceRentalFee;

  NamespaceNetworkProperties(
      this.maxNameSize,
      this.maxChildNamespaces,
      this.maxNamespaceDepth,
      this.minNamespaceDuration,
      this.maxNamespaceDuration,
      this.namespaceGracePeriodDuration,
      this.reservedRootNamespaceNames,
      this.namespaceRentalFeeSinkPublicKey,
      this.rootNamespaceRentalFeePerBlock,
      this.childNamespaceRentalFee);

  @override
  String toString() {
    return 'NamespaceNetworkProperties{maxNameSize: $maxNameSize, maxChildNamespaces: $maxChildNamespaces, maxNamespaceDepth: $maxNamespaceDepth, minNamespaceDuration: $minNamespaceDuration, maxNamespaceDuration: $maxNamespaceDuration, namespaceGracePeriodDuration: $namespaceGracePeriodDuration, reservedRootNamespaceNames: $reservedRootNamespaceNames, namespaceRentalFeeSinkPublicKey: $namespaceRentalFeeSinkPublicKey, rootNamespaceRentalFeePerBlock: $rootNamespaceRentalFeePerBlock, childNamespaceRentalFee: $childNamespaceRentalFee}';
  }
}
