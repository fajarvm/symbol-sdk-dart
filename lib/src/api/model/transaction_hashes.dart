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

class TransactionHashes {
  /* Array of transaction hashes. */
  List<String> hashes = [];

  TransactionHashes();

  @override
  String toString() {
    return 'TransactionHashes[hashes=$hashes, ]';
  }

  TransactionHashes.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    hashes = (json['hashes'] as List).map((item) => item as String).toList();
  }

  Map<String, dynamic> toJson() {
    return {'hashes': hashes};
  }

  static List<TransactionHashes> listFromJson(List<dynamic> json) {
    return json == null
        ? <TransactionHashes>[]
        : json.map((value) => new TransactionHashes.fromJson(value)).toList();
  }

  static Map<String, TransactionHashes> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, TransactionHashes>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new TransactionHashes.fromJson(value));
    }
    return map;
  }
}
