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

/// The resolution entry object.
class ResolutionEntry<T> {
  /// A resolved address or resolved mosaicId alias (MosaicAlias| AddressAlias).
  final T resolved;

  /// The receipt source.
  final ReceiptSource receiptSource;

  /// The receipt type.
  final ReceiptType receiptType;

  ResolutionEntry._(this.resolved, this.receiptSource, this.receiptType);

  factory ResolutionEntry(T resolved, ReceiptSource source, ReceiptType type) {
    ArgumentError.checkNotNull(resolved);
    ArgumentError.checkNotNull(source);
    ArgumentError.checkNotNull(type);

    _validate(resolved, type);

    return ResolutionEntry._(resolved, source, type);
  }

  /// Validates the resolved object and receipt type.
  static void _validate(final Object object, final ReceiptType type) {
    if (object is AddressAlias || object is MosaicAlias) {
      if (ReceiptType.ResolutionStatement.contains(type)) {
        // OK. Match found.
        return;
      }
    }

    throw new ArgumentError('Invalid ResolutionEntry: ['
        'resolved="$object",'
        'receiptType="$type",'
        ']');
  }
}
