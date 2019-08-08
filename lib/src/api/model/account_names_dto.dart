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

class AccountNamesDTO {
  /* Address of the account decoded. */
  String address;

/* Account linked namespace names. */
  List<String> names = [];

  AccountNamesDTO();

  @override
  String toString() {
    return 'AccountNamesDTO[address=$address, names=$names, ]';
  }

  AccountNamesDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    address = json['address'];
    names = (json['names'] as List).map((item) => item as String).toList();
  }

  Map<String, dynamic> toJson() {
    return {'address': address, 'names': names};
  }

  static List<AccountNamesDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <AccountNamesDTO>[]
        : json.map((value) => new AccountNamesDTO.fromJson(value)).toList();
  }

  static Map<String, AccountNamesDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, AccountNamesDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new AccountNamesDTO.fromJson(value));
    }
    return map;
  }
}
