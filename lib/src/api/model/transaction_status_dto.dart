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

class TransactionStatusDTO {
  String group;

  String status;

  String hash;

  UInt64DTO deadline;

  UInt64DTO height;

  TransactionStatusDTO();

  @override
  String toString() {
    return 'TransactionStatusDTO[group=$group, status=$status, hash=$hash, deadline=$deadline, height=$height, ]';
  }

  TransactionStatusDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    group = json['group'];
    status = json['status'];
    hash = json['hash'];
    deadline = new UInt64DTO.fromJson(json['deadline']);
    height = new UInt64DTO.fromJson(json['height']);
  }

  Map<String, dynamic> toJson() {
    return {'group': group, 'status': status, 'hash': hash, 'deadline': deadline, 'height': height};
  }

  static List<TransactionStatusDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <TransactionStatusDTO>[]
        : json.map((value) => new TransactionStatusDTO.fromJson(value)).toList();
  }

  static Map<String, TransactionStatusDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, TransactionStatusDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new TransactionStatusDTO.fromJson(value));
    }
    return map;
  }
}
