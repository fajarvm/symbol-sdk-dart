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

library symbol_sdk_dart.sdk.model.mosaic.mosaic_flags;

import 'package:fixnum/fixnum.dart' show Int64;

/// Describes the properties a mosaic can have.
class MosaicFlags {
  /// The mosaic supply mutability. When set to `true`, allows the supply to be changed at
  /// later point.
  ///
  /// Default value is `false`.
  final bool supplyMutable;

  /// The mosaic transferability. Defines if the mosaic is allowed for transfers among accounts
  /// other than the creator. When set to `false`, this mosaic can only be transferred to and from
  /// the creator of this mosaic. When set to `true` this mosaic can be transferred to and from
  /// arbitrary accounts.
  ///
  /// Default value is `true`.
  final bool transferable;

  /// Not all the mosaics of a given network will be subject to mosaic restrictions. The feature
  /// will only affect those to which the issuer adds the "restrictable" property explicitly at the
  /// moment of its creation. This property appears disabled by default, as it is undesirable for
  /// autonomous tokens like the public network currency.
  ///
  /// Default value is `true`.
  final bool restrictable;

  MosaicFlags._(this.supplyMutable, this.transferable, this.restrictable);

  /// Creates mosaic flags with the default parameters.
  static MosaicFlags create(
      [final bool supplyMutable = false,
      final bool transferable = true,
      final bool restrictable = true]) {
    return new MosaicFlags._(supplyMutable, transferable, restrictable);
  }

  /// Creates mosaic flags from the configurable byte value.
  static MosaicFlags fromByteValue(int flags) {
    final String binaryString = '00${Int64(flags).shiftRightUnsigned(0).toRadixString(2)}';
    final String bitArray = binaryString.substring(binaryString.length - 3);

    return MosaicFlags.create(bitArray[2] == '1', bitArray[1] == '1', bitArray[0] == '1');
  }

  /// Returns the mosaic flag value in integer.
  int get value => (this.supplyMutable ? 1 : 0) + (this.transferable ? 2 : 0) + (this.restrictable ? 4 : 0);

  @override
  String toString() {
    return 'MosaicFlags{'
        'supplyMutable: $supplyMutable, '
        'transferable: $transferable, '
        'restrictable: $restrictable'
        '}';
  }
}
