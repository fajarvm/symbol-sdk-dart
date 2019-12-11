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

import '../account/address.dart';
import '../mosaic/mosaic_id.dart';
import 'receipt_source.dart';

/// The resolution entry object.
class ResolutionEntry<T> {
  /// The resolved object. It must either be an [Address] or a [MosaicId].
  final T resolved;

  /// The receipt source.
  final ReceiptSource receiptSource;

  ResolutionEntry._(this.resolved, this.receiptSource);

  factory ResolutionEntry(T resolved, ReceiptSource source) {
    ArgumentError.checkNotNull(resolved);
    ArgumentError.checkNotNull(source);

    if (resolved is! Address && resolved is! MosaicId) {
      throw new ArgumentError('Invalid ResolutionEntry: [resolved="$resolved"]');
    }

    return ResolutionEntry._(resolved, source);
  }
}
