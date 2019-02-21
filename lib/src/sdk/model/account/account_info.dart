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

library nem2_sdk_dart.sdk.model.account.account_info;

import 'address.dart';

import '../mosaic/mosaic.dart';

/// The account info structure describes basic information for an account.
class AccountInfo {
  final Address _address;
  final BigInt _addressHeight;
  final String _publicKey;
  final BigInt _publicKeyHeight;
  final BigInt _importance;
  final BigInt _importanceHeight;
  final List<Mosaic> _mosaics;

  const AccountInfo._(this._address, this._addressHeight, this._publicKey, this._publicKeyHeight,
      this._importance, this._importanceHeight, this._mosaics);

  factory AccountInfo(
      final Address address,
      final BigInt addressHeight,
      final String publicKey,
      final BigInt publicKeyHeight,
      final BigInt importance,
      final BigInt importanceHeight,
      final List<Mosaic> mosaics) {
    return new AccountInfo._(
        address, addressHeight, publicKey, publicKeyHeight, importance, importanceHeight, mosaics);
  }
}
