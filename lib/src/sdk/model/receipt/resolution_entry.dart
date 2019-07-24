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

library nem2_sdk_dart.sdk.model.receipt.resolution_entry;

import '../namespace/address_alias.dart';
import '../namespace/mosaic_alias.dart';
import 'receipt_source.dart';
import 'receipt_type.dart';

/// The receipt source object.
class ResolutionEntry {
  /// A resolved address or resolved mosaicId alias (MosaicAlias| AddressAlias).
  final Object resolved;

  /// The receipt source.
  final ReceiptSource receiptSource;

  /// The receipt type.
  final ReceiptType receiptType;

  ResolutionEntry._(this.resolved, this.receiptSource, this.receiptType);

  factory ResolutionEntry(Object resolved, ReceiptSource receiptSource, ReceiptType receiptType) {
    ArgumentError.checkNotNull(resolved);
    ArgumentError.checkNotNull(receiptSource);
    ArgumentError.checkNotNull(receiptType);

    _validateReceiptType(receiptType);
    _validateResolvedType(resolved);

    return ResolutionEntry._(resolved, receiptSource, receiptType);
  }

  /// Validates the given receipt [type].
  ///
  /// Throws an error if the receipt type is not of type [ReceiptType.ResolutionStatement].
  static void _validateReceiptType(final ReceiptType type) {
    if (!ReceiptType.ResolutionStatement.contains(type)) {
      throw new ArgumentError('Invalid receipt type: $type');
    }
  }

  /// Validates the resolved type (MosaicId | NamespaceId) of the given [resolutionObject].
  static void _validateResolvedType(Object resolutionObject) {
    if (resolutionObject is AddressAlias) {
      // OK
      return;
    }

    if (resolutionObject is MosaicAlias) {
      // OK
      return;
    }

    // Not OK. Throw an error.
    throw new ArgumentError('Invalid resolution entry: $resolutionObject');
  }
}
