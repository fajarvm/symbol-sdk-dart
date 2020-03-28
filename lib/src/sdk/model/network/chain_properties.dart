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

library symbol_sdk_dart.sdk.model.network.chain_properties;

/// Chain related configuration properties.
class ChainProperties {
  /// Set to true if block chain should calculate state hashes so that
  /// state is fully verifiable at each block.
  final bool enableStrictCosignatureCheck;

  /// Set to true if block chain should calculate receipts so that
  /// state changes are fully verifiable at each block.
  final bool enableVerifiableReceipts;

  /// Mosaic id used as primary chain currency.
  final String currencyMosaicId;

  /// Mosaic id used to provide harvesting ability.
  final String harvestingMosaicId;

  /// Targeted time between blocks.
  final String blockGenerationTargetTime;

  /// A higher value makes the network more biased.
  final String blockTimeSmoothingFactor;

  /// Number of blocks that should be treated as a group for importance purposes.
  final String importanceGrouping;

  /// Percentage of importance resulting from fee generation and beneficiary usage.
  final String importanceActivityPercentage;

  /// Maximum number of blocks that can be rolled back.
  final String maxRollbackBlocks;

  /// Maximum number of blocks to use in a difficulty calculation.
  final String maxDifficultyBlocks;

  /// Default multiplier to use for dynamic fees.
  final String defaultDynamicFeeMultiplier;

  /// Maximum lifetime a transaction can have before it expires.
  final String maxTransactionLifetime;

  /// Maximum future time of a block that can be accepted.
  final String maxBlockFutureTime;

  /// Initial currency atomic units available in the network.
  final String initialCurrencyAtomicUnits;

  /// Maximum atomic units (total-supply * 10 ^ divisibility) of a mosaic allowed in the network.
  final String maxMosaicAtomicUnits;

  /// Total whole importance units available in the network.
  final String totalChainImportance;

  /// Minimum number of harvesting mosaic atomic units needed for an account to be eligible for harvesting.
  final String minHarvesterBalance;

  /// Maximum number of harvesting mosaic atomic units needed for an account to be eligible for harvesting.
  final String maxHarvesterBalance;

  /// Percentage of the harvested fee that is collected by the beneficiary account.
  final String harvestBeneficiaryPercentage;

  /// Number of blocks between cache pruning.
  final String blockPruneInterval;

  /// Maximum number of transactions per block.
  final String maxTransactionsPerBlock;

  ChainProperties(
      this.enableStrictCosignatureCheck,
      this.enableVerifiableReceipts,
      this.currencyMosaicId,
      this.harvestingMosaicId,
      this.blockGenerationTargetTime,
      this.blockTimeSmoothingFactor,
      this.importanceGrouping,
      this.importanceActivityPercentage,
      this.maxRollbackBlocks,
      this.maxDifficultyBlocks,
      this.defaultDynamicFeeMultiplier,
      this.maxTransactionLifetime,
      this.maxBlockFutureTime,
      this.initialCurrencyAtomicUnits,
      this.maxMosaicAtomicUnits,
      this.totalChainImportance,
      this.minHarvesterBalance,
      this.maxHarvesterBalance,
      this.harvestBeneficiaryPercentage,
      this.blockPruneInterval,
      this.maxTransactionsPerBlock);

  @override
  String toString() {
    return 'ChainProperties{enableStrictCosignatureCheck: $enableStrictCosignatureCheck, enableVerifiableReceipts: $enableVerifiableReceipts, currencyMosaicId: $currencyMosaicId, harvestingMosaicId: $harvestingMosaicId, blockGenerationTargetTime: $blockGenerationTargetTime, blockTimeSmoothingFactor: $blockTimeSmoothingFactor, importanceGrouping: $importanceGrouping, importanceActivityPercentage: $importanceActivityPercentage, maxRollbackBlocks: $maxRollbackBlocks, maxDifficultyBlocks: $maxDifficultyBlocks, defaultDynamicFeeMultiplier: $defaultDynamicFeeMultiplier, maxTransactionLifetime: $maxTransactionLifetime, maxBlockFutureTime: $maxBlockFutureTime, initialCurrencyAtomicUnits: $initialCurrencyAtomicUnits, maxMosaicAtomicUnits: $maxMosaicAtomicUnits, totalChainImportance: $totalChainImportance, minHarvesterBalance: $minHarvesterBalance, maxHarvesterBalance: $maxHarvesterBalance, harvestBeneficiaryPercentage: $harvestBeneficiaryPercentage, blockPruneInterval: $blockPruneInterval, maxTransactionsPerBlock: $maxTransactionsPerBlock}';
  }
}
