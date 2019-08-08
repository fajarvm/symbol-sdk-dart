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

class AccountIds {
  /* Array of public keys. */
  List<String> publicKeys = [];

/* Array of addresses. */
  List<String> addresses = [];

  AccountIds();

  @override
  String toString() {
    return 'AccountIds[publicKeys=$publicKeys, addresses=$addresses, ]';
  }

  AccountIds.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    publicKeys = (json['publicKeys'] as List).map((item) => item as String).toList();
    addresses = (json['addresses'] as List).map((item) => item as String).toList();
  }

  Map<String, dynamic> toJson() {
    return {'publicKeys': publicKeys, 'addresses': addresses};
  }

  static List<AccountIds> listFromJson(List<dynamic> json) {
    return json == null
        ? <AccountIds>[]
        : json.map((value) => new AccountIds.fromJson(value)).toList();
  }

  static Map<String, AccountIds> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, AccountIds>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new AccountIds.fromJson(value));
    }
    return map;
  }
}
