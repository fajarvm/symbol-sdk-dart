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

library symbol_sdk_dart.sdk.model.network.rental_fees;

import '../common/uint64.dart';

/// Rental fees.
class RentalFees {
  /// Absolute amount.
  ///
  /// An amount of 123456789 (absolute) for a mosaic with divisibility 6 means
  /// 123.456789 (relative).
  final Uint64 effectiveRootNamespaceRentalFeePerBlock;

  /// Absolute amount.
  ///
  /// An amount of 123456789 (absolute) for a mosaic with divisibility 6 means
  /// 123.456789 (relative).
  final Uint64 effectiveChildNamespaceRentalFee;

  /// Absolute amount.
  ///
  /// An amount of 123456789 (absolute) for a mosaic with divisibility 6 means
  /// 123.456789 (relative).
  final Uint64 effectiveMosaicRentalFee;

  RentalFees(this.effectiveRootNamespaceRentalFeePerBlock, this.effectiveChildNamespaceRentalFee,
      this.effectiveMosaicRentalFee);

  @override
  String toString() {
    return 'RentalFees{effectiveRootNamespaceRentalFeePerBlock: $effectiveRootNamespaceRentalFeePerBlock, effectiveChildNamespaceRentalFee: $effectiveChildNamespaceRentalFee, effectiveMosaicRentalFee: $effectiveMosaicRentalFee}';
  }
}
