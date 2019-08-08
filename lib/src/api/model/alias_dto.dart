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

class AliasDTO {
  AliasTypeEnum type;

  UInt64DTO mosaicId;

/* Aliased address in hexadecimal. */
  String address;

  AliasDTO();

  @override
  String toString() {
    return 'AliasDTO[type=$type, mosaicId=$mosaicId, address=$address, ]';
  }

  AliasDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    type = new AliasTypeEnum.fromJson(json['type']);
    mosaicId = new UInt64DTO.fromJson(json['mosaicId']);
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'mosaicId': mosaicId, 'address': address};
  }

  static List<AliasDTO> listFromJson(List<dynamic> json) {
    return json == null ? <AliasDTO>[] : json.map((value) => new AliasDTO.fromJson(value)).toList();
  }

  static Map<String, AliasDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, AliasDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new AliasDTO.fromJson(value));
    }
    return map;
  }
}
