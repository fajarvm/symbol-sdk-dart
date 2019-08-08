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

class MosaicInfoDTO {
  MosaicMetaDTO meta;

  MosaicDefinitionDTO mosaic;

  MosaicInfoDTO();

  @override
  String toString() {
    return 'MosaicInfoDTO[meta=$meta, mosaic=$mosaic, ]';
  }

  MosaicInfoDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    meta = new MosaicMetaDTO.fromJson(json['meta']);
    mosaic = new MosaicDefinitionDTO.fromJson(json['mosaic']);
  }

  Map<String, dynamic> toJson() {
    return {'meta': meta, 'mosaic': mosaic};
  }

  static List<MosaicInfoDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <MosaicInfoDTO>[]
        : json.map((value) => new MosaicInfoDTO.fromJson(value)).toList();
  }

  static Map<String, MosaicInfoDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, MosaicInfoDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new MosaicInfoDTO.fromJson(value));
    }
    return map;
  }
}
