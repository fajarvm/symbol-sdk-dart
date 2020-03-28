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

library symbol_sdk_dart.sdk.model.network.plugin_properties;

import 'account_link_network_properties.dart';
import 'account_restriction_network_properties.dart';
import 'aggregate_network_properties.dart';
import 'hash_lock_network_properties.dart';
import 'metadata_network_properties.dart';
import 'mosaic_network_properties.dart';
import 'mosaic_restriction_network_properties.dart';
import 'multisig_network_properties.dart';
import 'namespace_network_properties.dart';
import 'secret_lock_network_properties.dart';
import 'transfer_network_proeprties.dart';

/// Plugin related configuration properties.
class PluginProperties {
  /// Network identifier.
  final AccountLinkNetworkProperties accountLink;

  /// Nemesis public key.
  final AggregateNetworkProperties aggregate;

  /// Nemesis generation hash.
  final HashLockNetworkProperties lockHash;

  /// Nemesis epoch time adjustment.
  final SecretLockNetworkProperties lockSecret;

  final MetadataNetworkProperties metadata;
  final MosaicNetworkProperties mosaic;
  final MultisigNetworkProperties multisig;
  final NamespaceNetworkProperties namespace;
  final AccountRestrictionNetworkProperties restrictionAccount;
  final MosaicRestrictionNetworkProperties restrictionMosaic;
  final TransferNetworkProperties transfer;

  PluginProperties(
      this.accountLink,
      this.aggregate,
      this.lockHash,
      this.lockSecret,
      this.metadata,
      this.mosaic,
      this.multisig,
      this.namespace,
      this.restrictionAccount,
      this.restrictionMosaic,
      this.transfer);

  @override
  String toString() {
    return 'PluginProperties{accountLink: $accountLink, aggregate: $aggregate, lockHash: $lockHash, lockSecret: $lockSecret, metadata: $metadata, mosaic: $mosaic, multisig: $multisig, namespace: $namespace, restrictionAccount: $restrictionAccount, restrictionMosaic: $restrictionMosaic, transfer: $transfer}';
  }
}
