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

library nem2_sdk_dart.sdk.model.mosaic.mosaic;

import '../common/id.dart';
import '../common/uint64.dart';

/// A mosaic describes an instance of a mosaic definition.
/// Mosaics can be transferred by means of a transfer transaction.
class Mosaic {
  /// The mosaic id. This can either be of type [MosaicId] or [NamespaceId].
  final Id id;

  /// The mosaic amount.
  final Uint64 amount;

  /// Creates a new Mosaic with the given [id] with the given [amount].
  ///
  /// The quantity is always given in smallest units for the mosaic. For example, if it has a
  /// divisibility of 3 the quantity is given in millis.
  Mosaic(this.id, this.amount);
}
