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

library nem2_sdk_dart.sdk.model.mosaic.mosaic_id;

import 'package:nem2_sdk_dart/core.dart' show HexUtils, StringUtils;

import '../account/public_account.dart';
import '../common/id.dart';
import '../common/id_generator.dart';
import '../common/uint64.dart';

import 'mosaic_nonce.dart';

/// The mosaic id structure describes mosaic id.
class MosaicId extends Id {
  // private constructor
  const MosaicId._(id) : super(id);

  factory MosaicId({final Uint64 id}) {
    if (id == null) {
      throw new ArgumentError('The id must not be null');
    }

    return new MosaicId._(id);
  }

  /// Creates a new [MosaicId] from an [id].
  static MosaicId fromId(final Uint64 id) {
    return new MosaicId(id: id);
  }

  /// Creates a new [MosaicId] from a [bigInt].
  static MosaicId fromBigInt(final BigInt bigInt) {
    if (bigInt == null) {
      throw new ArgumentError('The bigInt must not be null');
    }
    return new MosaicId(id: Uint64.fromBigInt(bigInt));
  }

  /// Creates a new [MosaicId] from a [hex].
  static MosaicId fromHex(final String hex) {
    if (StringUtils.isEmpty(hex)) {
      throw new ArgumentError('The hexString must not be null or empty');
    }

    if (!HexUtils.isHex(hex)) {
      throw new ArgumentError('invalid hex');
    }

    return new MosaicId(id: Uint64.fromHex(hex));
  }

  /// Creates a new [MosaicId] from a given [mosaicNonce] and [owner]'s public account.
  static MosaicId fromNonce(final MosaicNonce mosaicNonce, final PublicAccount owner) {
    final Uint64 id = IdGenerator.generateMosaicId(mosaicNonce.nonce, owner.publicKey);
    return new MosaicId(id: id);
  }

  @override
  int get hashCode => 'MosaicId'.hashCode ^ id.hashCode;

  @override
  bool operator ==(final other) =>
      identical(this, other) ||
      other is MosaicId && runtimeType == other.runtimeType && id == other.id;

  @override
  String toString() => 'MosaicId(id:$id)';
}
