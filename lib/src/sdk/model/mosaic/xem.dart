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

library nem2_sdk_dart.sdk.model.mosaic.xem;

import 'dart:math' show pow;

import 'package:nem2_sdk_dart/core.dart' show Uint64;

import '../namespace/namespace_id.dart';

import 'mosaic.dart';
import 'mosaic_id.dart';

/// The XEM mosaic.
class XEM implements Mosaic {
  /// Divisibility of 6.
  static const int DIVISIBILITY = 6;

  /// Initial supply.
  static const int INITIAL_SUPPLY = 8999999999;

  /// This mosaic is transferable.
  static const bool TRANSFERABLE = true;

  /// The supply of mosaic cannot be changed (immutable supply).
  static const SUPPLY_MUTABLE = false;

  /// The mosaicId of this mosaic.
  static final MOSAIC_ID = new MosaicId(fullName: 'nem:xem');

  /// The namespaceId of this mosaic.
  static final NAMESPACE_ID = new NamespaceId(fullName: 'nem');

  final Uint64 _amount;

  XEM._(this._amount);

  factory XEM(final Uint64 amount) {
    return XEM._(amount);
  }

  @override
  Uint64 get amount => this._amount;

  @override
  MosaicId get id => XEM.MOSAIC_ID;

  /// Creates XEM with using XEM as unit.
  static XEM createRelative(final Uint64 amount) {
    return new XEM(Uint64.fromBigInt(amount.value * BigInt.from(pow(10, XEM.DIVISIBILITY))));
  }

  /// Creates XEM with using micro XEM as unit. 1 XEM = 1000000 micro XEM.
  static XEM createAbsolute(final Uint64 microXemAmount) {
    return new XEM(microXemAmount);
  }
}
