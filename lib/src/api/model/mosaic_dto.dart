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

class MosaicDTO {
  UInt64DTO id;

  UInt64DTO amount;

  MosaicDTO();

  @override
  String toString() {
    return 'MosaicDTO[id=$id, amount=$amount, ]';
  }

  MosaicDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    id = new UInt64DTO.fromJson(json['id']);
    amount = new UInt64DTO.fromJson(json['amount']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'amount': amount};
  }

  static List<MosaicDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <MosaicDTO>[]
        : json.map((value) => new MosaicDTO.fromJson(value)).toList();
  }

  static Map<String, MosaicDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, MosaicDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new MosaicDTO.fromJson(value));
    }
    return map;
  }
}
