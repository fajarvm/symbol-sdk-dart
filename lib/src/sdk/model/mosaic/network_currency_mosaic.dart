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

library nem2_sdk_dart.sdk.model.mosaic.network_currency_mosaic;

import 'dart:math' show pow;

import '../common/id.dart';
import '../common/uint64.dart';
import '../namespace/namespace_id.dart';
import 'mosaic.dart';

/// The NetworkCurrencyMosaic mosaic.
///
/// This mosaic represents the native currency of the network. The mosaicId of this mosaic is
/// aliased with the namespace name `cat.currency`.
class NetworkCurrencyMosaic extends Mosaic {
  /// The namespaceId of this mosaic.
  static final Id NAMESPACE_ID = new NamespaceId(fullName: 'cat.currency');

  /// Divisibility of 6.
  static const int DIVISIBILITY = 6;

  /// Initial supply.
  static const int INITIAL_SUPPLY = 8999999999;

  /// This mosaic is transferable.
  static const bool TRANSFERABLE = true;

  /// The supply of mosaic cannot be changed (immutable supply).
  static const SUPPLY_MUTABLE = false;

  /// The levy of mosaic cannot be changed (immutable levy).
  static const LEVY_MUTABLE = false;

  // private constructor
  NetworkCurrencyMosaic._(Uint64 amount) : super(NAMESPACE_ID, amount);

  @override
  Id get id => NetworkCurrencyMosaic.NAMESPACE_ID;

  /// Creates NetworkCurrencyMosaic with using NetworkCurrencyMosaic as unit.
  static NetworkCurrencyMosaic createRelative(final Uint64 amount) {
    return new NetworkCurrencyMosaic._(
        Uint64.fromBigInt(amount.value * BigInt.from(pow(10, NetworkCurrencyMosaic.DIVISIBILITY))));
  }

  /// Creates NetworkCurrencyMosaic with using micro XEM as unit.
  ///
  /// 1 NetworkCurrencyMosaic = 1000000 micro NetworkCurrencyMosaic.
  static NetworkCurrencyMosaic createAbsolute(final Uint64 microXemAmount) {
    return new NetworkCurrencyMosaic._(microXemAmount);
  }
}
