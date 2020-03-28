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

library symbol_sdk_dart.sdk.model.network.aggregate_network_properties;

/// Value object for account restriction network properties.
class AggregateNetworkProperties {
  /// Maximum number of transactions per aggregate.
  final String maxTransactionsPerAggregate;

  /// Maximum number of cosignatures per aggregate.
  final String maxCosignaturesPerAggregate;

  /// Set to true if cosignatures must exactly match component signers.
  /// Set to false if cosignatures should be validated externally.
  final bool enableStrictCosignatureCheck;

  /// Set to true if bonded aggregates should be allowed.
  /// Set to false if bonded aggregates should be rejected.
  final bool enableBondedAggregateSupport;

  /// Maximum lifetime a bonded transaction can have before it expires.
  final String maxBondedTransactionLifetime;

  AggregateNetworkProperties(
    this.maxTransactionsPerAggregate,
    this.maxCosignaturesPerAggregate,
    this.enableStrictCosignatureCheck,
    this.enableBondedAggregateSupport,
    this.maxBondedTransactionLifetime);
}
