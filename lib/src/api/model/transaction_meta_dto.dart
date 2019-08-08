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

class TransactionMetaDTO {
  UInt64DTO height;

  String hash;

  String merkleComponentHash;

  int index;

  String id;

  TransactionMetaDTO();

  @override
  String toString() {
    return 'TransactionMetaDTO[height=$height, hash=$hash, merkleComponentHash=$merkleComponentHash, index=$index, id=$id, ]';
  }

  TransactionMetaDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    height = new UInt64DTO.fromJson(json['height']);
    hash = json['hash'];
    merkleComponentHash = json['merkleComponentHash'];
    index = json['index'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'hash': hash,
      'merkleComponentHash': merkleComponentHash,
      'index': index,
      'id': id
    };
  }

  static List<TransactionMetaDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <TransactionMetaDTO>[]
        : json.map((value) => new TransactionMetaDTO.fromJson(value)).toList();
  }

  static Map<String, TransactionMetaDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, TransactionMetaDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new TransactionMetaDTO.fromJson(value));
    }
    return map;
  }
}
