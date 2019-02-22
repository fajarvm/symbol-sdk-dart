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

import 'package:nem2_sdk_dart/core.dart' show Uint64;

import 'mosaic_id.dart';

/// A mosaic describes an instance of a mosaic definition.
/// Mosaics can be transferred by means of a transfer transaction.
class Mosaic {
  final MosaicId id;
  final Uint64 amount;

  const Mosaic._(this.id, this.amount);

  /// Creates a new Mosaic with the given [id] with the given [amount].
  ///
  /// The quantity is always given in smallest units for the mosaic. For example, if it has a
  /// divisibility of 3 the quantity is given in millis.
  factory Mosaic(final MosaicId id, final Uint64 amount) {
    if (id == null) {
      throw new ArgumentError('MosaicId must not be null');
    }

    return new Mosaic._(id, amount);
  }
}
