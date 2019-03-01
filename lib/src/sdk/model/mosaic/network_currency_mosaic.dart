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
import 'dart:typed_data' show Uint8List;

import '../namespace/namespace_id.dart';
import '../transaction/id_generator.dart';
import '../transaction/uint64.dart';

import 'mosaic.dart';
import 'mosaic_id.dart';

/// The NetworkCurrencyMosaic mosaic.
///
/// This mosaic represents the native currency of the network. The mosaicId of this mosaic is
/// aliased with the namespace name `currency`.
class NetworkCurrencyMosaic implements Mosaic {
  /// The public key of the owner of this mosaic.
  static const String OWNER_PUBLIC_KEY =
      'B4F12E7C9F6946091E2CB8B6D3A12B50D17CCBBF646386EA27CE2946A7423DCF';

  /// The namespaceId of this mosaic.
  static final NAMESPACE_ID = _createNamespaceId();

  /// The mosaicId of this mosaic.
  static final MOSAIC_ID = _createMosaicId();

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

  final Uint64 _amount;

  // private constructor
  const NetworkCurrencyMosaic._(this._amount);

  @override
  Uint64 get amount => this._amount;

  @override
  MosaicId get id => NetworkCurrencyMosaic.MOSAIC_ID;

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

  // ------------------------------ private / protected functions ------------------------------ //

  static MosaicId _createMosaicId() {
    final Uint8List nonce = new Uint8List.fromList([0x0, 0x0, 0x0, 0x0]); // Little-endian nonce
    final Uint64 id = IdGenerator.generateMosaicId(nonce, OWNER_PUBLIC_KEY);
    return MosaicId(id: id);
  }

  static NamespaceId _createNamespaceId() {
    return new NamespaceId(fullName: 'cat.currency');
  }
}
