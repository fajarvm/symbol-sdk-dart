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

//import '../transaction/id_generator.dart';
import '../transaction/uint64.dart';

/// The mosaic id structure describes mosaic id.
class MosaicId {
  /// Mosaic 64-bit unsigned integer id.
  final Uint64 id;

// Deprecated. To be re-introduced after AliasTransaction implementation.
//  /// Mosaic full name with namespace name (Example: nem:xem).
//  ///
//  /// The full name can be empty when the mosaic id is created using only the [Uint64] id.
//  final String fullName;
//
//  const MosaicId._(this.id, this.fullName);
//
//   Deprecated. To be re-introduced after AliasTransaction implementation.
//  /// Create a [MosaicId] from a 64-bit unsigned integer [id] OR a namespace-mosaic [fullName].
//  ///
//  /// When both the [id] and the [fullName] are provided, a new [id] will be generated from the
//  /// provided [fullName] and the provided [id] will be ignored.
//  factory MosaicId({final Uint64 id, final String fullName}) {
//    final String fullMosaicName = StringUtils.trim(fullName);
//    if (id == null && StringUtils.isEmpty(fullMosaicName)) {
//      throw new ArgumentError('Missing argument. Either id or fullName is required.');
//    }
//
//    if (StringUtils.isNotEmpty(fullMosaicName)) {
//      final Uint64 mosaicId = IdGenerator.generateMosaicId(fullMosaicName);
//      return new MosaicId._(mosaicId, fullMosaicName);
//    }
//    return new MosaicId._(id, null);
//  }

  const MosaicId._(this.id);

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

// Deprecated. To be re-introduced after AliasTransaction implementation.
//  /// Creates a new [MosaicId] from a [fullName].
//  static MosaicId fromFullName(final String fullName) {
//    if (StringUtils.isEmpty(fullName)) {
//      throw new ArgumentError('The fullName must not be null or empty');
//    }
//
//    return new MosaicId(fullName: fullName);
//  }

  /// Creates a new [MosaicId] from a [hexString].
  static MosaicId fromHex(final String hexString) {
    if (StringUtils.isEmpty(hexString)) {
      throw new ArgumentError('The hexString must not be null or empty');
    }

    if (!HexUtils.isHexString(hexString)) {
      throw new ArgumentError('invalid hex');
    }

    return new MosaicId(id: Uint64.fromHex(hexString));
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
