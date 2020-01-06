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

library nem2_sdk_dart.sdk.model.utils.unresolved_utils;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/core.dart' show HexUtils, RawAddress;

import '../account/address.dart';
import '../blockchain/network_type.dart';
import '../mosaic/mosaic_id.dart';
import '../namespace/namespace_id.dart';

/// A utility class for internal use.
class UnresolvedUtils {
  /// Try to covert an [inputHex] string to [MosaicId] or [NamespaceId].
  ///
  /// Throws an error when [inputHex] is not a valid hex string.
  static dynamic toUnresolvedMosaic(final String inputHex) {
    if (!HexUtils.isHex(inputHex)) {
      throw new ArgumentError('Input string is not a valid hexadecimal string.');
    }

    final bytes = HexUtils.getBytes(inputHex);
    final byte0 = bytes[0];

    // if most significant bit of byte 0 is set, then we have a namespaceId
    if ((byte0 & 128) == 128) {
      return NamespaceId.fromHex(inputHex);
    }
    // most significant bit of byte 0 is not set => mosaicId
    return MosaicId.fromHex(inputHex);
  }

  /// Map unresolved address string to [Address] or [NamespaceId].
  ///
  /// Throws an error when [inputHex] is not a valid hex string.
  static dynamic toUnresolvedAddress(final String inputHex) {
    if (!HexUtils.isHex(inputHex)) {
      throw new ArgumentError('Input string is not a valid hexadecimal string.');
    }

    // If bit 0 of byte 0 is not set (like in 0x90), then it is a regular address.
    // Else (e.g. 0x91) it represents a namespace id which starts at byte 1.
    final bit0 = HexUtils.getBytes(inputHex.substring(1, 3))[0];
    if ((bit0 & 16) == 16) {
      // namespaceId encoded hexadecimal notation provided
      // only 8 bytes are relevant to resolve the NamespaceId
      final relevantPart = inputHex.substring(2);
      final reversed = HexUtils.reverseHexString(relevantPart);
      return NamespaceId.fromHex(reversed);
    }

    // read address from encoded hexadecimal notation
    return Address.fromEncoded(inputHex);
  }

  /// Returns the bytes of an [unresolvedAddress]. The [unresolvedAddress] must either be
  /// a [NamespaceId] or an [Address].
  ///
  /// Throws an error when [unresolvedAddress] cannot be resolved.
  static Uint8List toUnresolvedAddressBytes(
      dynamic unresolvedAddress, final NetworkType networkType) {
    ArgumentError.checkNotNull(unresolvedAddress);
    ArgumentError.checkNotNull(networkType);

    if (unresolvedAddress is NamespaceId) {
      return RawAddress.aliasToRecipient(HexUtils.getBytes(unresolvedAddress.toHex()), networkType);
    } else if (unresolvedAddress is Address) {
      return RawAddress.stringToAddress(unresolvedAddress.plain);
    }

    throw new ArgumentError(
        'Unexpected UnresolvedAddress type. It should be a NamespaceId or an Address');
  }
}
