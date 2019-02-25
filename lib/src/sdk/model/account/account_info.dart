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

import '../account/public_account.dart';
import '../mosaic/mosaic.dart';
import '../transaction/uint64.dart';
import 'address.dart';

/// The account info structure describes basic information for an account.
class AccountInfo {
  /// The address of the account.
  final Address address;

  /// The block height when the address was published.
  final Uint64 addressHeight;

  /// The public key of the account.
  final String publicKey;

  /// the block height when the public key was first published.
  final Uint64 publicKeyHeight;

  /// The importance of the account.
  final Uint64 importance;

  /// The importance height of the account.
  final Uint64 importanceHeight;

  /// A collection of mosaics hold by the account.
  final List<Mosaic> mosaics;

  const AccountInfo(this.address, this.addressHeight, this.publicKey, this.publicKeyHeight,
      this.importance, this.importanceHeight, this.mosaics);

  /// Returns the public account of this account.
  PublicAccount get publicAccount => PublicAccount.fromPublicKey(publicKey, address.networkType);
}
