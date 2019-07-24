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

library nem2_sdk_dart.sdk.model.receipt.resolution_statement;

import 'package:nem2_sdk_dart/src/sdk/model/receipt/receipt_type.dart';

import '../account/address.dart';
import '../common/uint64.dart';
import '../mosaic/mosaic_id.dart';
import 'resolution_entry.dart';

/// The receipt source object.
class ResolutionStatement {
  /// The block height.
  final Uint64 height;

  /// The unresolved object. It can be either an [Address] or a [MosaicId].
  final Object unresolved;

  /// Returns a list of resolution entry.
  final List<ResolutionEntry> resolutionEntries;

  // private constructor
  ResolutionStatement._(this.height, this.unresolved, this.resolutionEntries);

  factory ResolutionStatement(Uint64 height, Object unresolved, List<ResolutionEntry> entries) {
    return ResolutionStatement._(height, unresolved, entries);
  }

  /// Validates an unresolved object against a list of resolution entry.
  ///
  /// Throws an error if no resolution match can be found.
  static void _validateType(Object unresolved, List<ResolutionEntry> entries) {
    if (!(unresolved is Address) && !(unresolved is MosaicId)) {
      throw new ArgumentError('Unresolved type: ["$unresolved"] '
          'is not valid for this ResolutionStatement');
    }

    for (var entry in entries) {
      if ((unresolved is Address && ReceiptType.ADDRESS_ALIAS_RESOLUTION != entry.receiptType) ||
          (unresolved is MosaicId && ReceiptType.MOSAIC_ALIAS_RESOLUTION != entry.receiptType)) {
        throw new ArgumentError('Unresolved type: ["$unresolved"] '
            'does not match ResolutionEntry type: [${entry.receiptType}]');
      }
    }

    throw new StateError('should not have reached this state');
  }
}
