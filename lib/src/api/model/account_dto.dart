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

part of nem2_sdk_dart.sdk.api.model;

class AccountDTO {
  /* Address of the account decoded.  */
  String address;

  UInt64DTO addressHeight;

/* Public key of the account. Only accounts that have already published a transaction have a public key assigned to the account. Otherwise, the field is null.  */
  String publicKey;

  UInt64DTO publicKeyHeight;

/* List of mosaics the account owns. The amount is represented in absolute amount. Thus a balance of 123456789 for a mosaic with divisibility 6 (absolute) means the account owns 123.456789 instead.  */
  List<MosaicDTO> mosaics = [];

  UInt64DTO importance;

  UInt64DTO importanceHeight;

  AccountDTO();

  @override
  String toString() {
    return 'AccountDTO[address=$address, addressHeight=$addressHeight, publicKey=$publicKey, publicKeyHeight=$publicKeyHeight, mosaics=$mosaics, importance=$importance, importanceHeight=$importanceHeight, ]';
  }

  AccountDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    address = json['address'];
    addressHeight = new UInt64DTO.fromJson(json['addressHeight']);
    publicKey = json['publicKey'];
    publicKeyHeight = new UInt64DTO.fromJson(json['publicKeyHeight']);
    mosaics = MosaicDTO.listFromJson(json['mosaics']);
    importance = new UInt64DTO.fromJson(json['importance']);
    importanceHeight = new UInt64DTO.fromJson(json['importanceHeight']);
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'addressHeight': addressHeight,
      'publicKey': publicKey,
      'publicKeyHeight': publicKeyHeight,
      'mosaics': mosaics,
      'importance': importance,
      'importanceHeight': importanceHeight
    };
  }

  static List<AccountDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <AccountDTO>[]
        : json.map((value) => new AccountDTO.fromJson(value)).toList();
  }

  static Map<String, AccountDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, AccountDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new AccountDTO.fromJson(value));
    }
    return map;
  }
}
