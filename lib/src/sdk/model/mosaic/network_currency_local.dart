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

library symbol_sdk_dart.sdk.model.mosaic.network_currency_local;

import 'dart:math' show pow;

import '../common/id.dart';
import '../common/uint64.dart';
import '../namespace/namespace_id.dart';
import 'mosaic.dart';

/// The NetworkCurrencyLocal mosaic for local test network (local bootstrap server).
///
/// This mosaic represents the pre-network currency mosaic. The mosaicId of this mosaic is
/// aliased with the namespace name `cat.currency`.
class NetworkCurrencyLocal extends Mosaic {
  /// The namespaceId of this mosaic.
  static final Id NAMESPACE_ID = new NamespaceId(fullName: 'cat.currency');

  /// The divisibility of this mosaic.
  static const int DIVISIBILITY = 6;

  /// The initial supply of this mosaic.
  static const int INITIAL_SUPPLY = 8999999998;

  /// This mosaic is transferable.
  static const bool TRANSFERABLE = true;

  /// The supply of mosaic cannot be changed (immutable supply).
  static const SUPPLY_MUTABLE = false;

  // private constructor
  NetworkCurrencyLocal._(Uint64 amount) : super(NAMESPACE_ID, amount);

  @override
  Id get id => NetworkCurrencyLocal.NAMESPACE_ID;

  /// Creates NetworkCurrencyLocal with using NetworkCurrencyLocal as unit.
  static NetworkCurrencyLocal createRelative(final Uint64 amount) {
    return new NetworkCurrencyLocal._(
        Uint64.fromBigInt(amount.value * BigInt.from(pow(10, NetworkCurrencyLocal.DIVISIBILITY))));
  }

  /// Creates NetworkCurrencyLocal with using micro NetworkCurrencyLocal as unit.
  ///
  /// 1 NetworkCurrencyLocal = 1000000 micro NetworkCurrencyLocal.
  static NetworkCurrencyLocal createAbsolute(final Uint64 microAmount) {
    return new NetworkCurrencyLocal._(microAmount);
  }
}
