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

library nem2_sdk_dart.sdk.model.common.unresolved_utils;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/core.dart' show HexUtils, RawAddress;

import '../account/address.dart';
import '../blockchain/network_type.dart';
import '../namespace/namespace_id.dart';

/// A utility class for internal use.
class UnresolvedUtils {
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

    throw new ArgumentError('IUnexpected UnresolvedAddress type. It should be a NamespaceId or an Address ');
  }
}
