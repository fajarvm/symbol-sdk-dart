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

library symbol_sdk_dart.sdk.model.mosaic.mosaic_id;

import 'package:symbol_sdk_dart/core.dart' show HexUtils, StringUtils;

import '../account/public_account.dart';
import '../common/id.dart';
import '../common/id_generator.dart';
import '../common/uint64.dart';

import 'mosaic_nonce.dart';

/// The mosaic id structure describes mosaic id.
class MosaicId extends Id {
  // private constructor
  MosaicId._(Uint64 id) : super(id);

  factory MosaicId(final Uint64 id) {
    ArgumentError.checkNotNull(id);

    return new MosaicId._(id);
  }

  /// Creates a new [MosaicId] from an [id].
  static MosaicId fromId(final Uint64 id) {
    return new MosaicId(id);
  }

  /// Creates a new [MosaicId] from a [bigInt].
  static MosaicId fromBigInt(final BigInt bigInt) {
    ArgumentError.checkNotNull(bigInt);

    return new MosaicId(Uint64.fromBigInt(bigInt));
  }

  /// Creates a new [MosaicId] from a [hex] string.
  static MosaicId fromHex(final String hex) {
    if (StringUtils.isEmpty(hex)) {
      throw new ArgumentError('The hex string must not be null or empty');
    }

    if (!HexUtils.isHex(hex)) {
      throw new ArgumentError('Invalid hex');
    }

    return new MosaicId(Uint64.fromHex(hex));
  }

  /// Creates a new [MosaicId] from a given [mosaicNonce] and [owner]'s public account.
  static MosaicId fromNonce(final MosaicNonce mosaicNonce, final PublicAccount owner) {
    final Uint64 id = IdGenerator.generateMosaicId(mosaicNonce.nonce, owner.publicKey);
    return new MosaicId(id);
  }

  /// Creates a new [MosaicId] from a pair of 32-bit integers.
  static MosaicId fromInts(final int lower, final int higher) {
    return new MosaicId(Uint64.fromInts(lower, higher));
  }

  @override
  int get hashCode => 'MosaicId'.hashCode ^ id.hashCode;

  @override
  bool operator ==(final other) =>
      identical(this, other) ||
      other is MosaicId && this.runtimeType == other.runtimeType && this.id == other.id;

  @override
  String toString() => 'MosaicId(id:$id)';
}
