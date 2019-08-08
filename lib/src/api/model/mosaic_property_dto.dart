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

class MosaicPropertyDTO {
  MosaicPropertyIdEnum id;

  UInt64DTO value;

  MosaicPropertyDTO();

  @override
  String toString() {
    return 'MosaicPropertyDTO[id=$id, value=$value, ]';
  }

  MosaicPropertyDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    id = new MosaicPropertyIdEnum.fromJson(json['id']);
    value = new UInt64DTO.fromJson(json['value']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'value': value};
  }

  static List<MosaicPropertyDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <MosaicPropertyDTO>[]
        : json.map((value) => new MosaicPropertyDTO.fromJson(value)).toList();
  }

  static Map<String, MosaicPropertyDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, MosaicPropertyDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new MosaicPropertyDTO.fromJson(value));
    }
    return map;
  }
}
