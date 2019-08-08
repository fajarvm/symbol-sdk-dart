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

class MosaicDefinitionDTO {
  UInt64DTO mosaicId;

  UInt64DTO supply;

  UInt64DTO height;

/* Public key of the mosaic owner. */
  String owner;

/* Number of definitions for the same mosaic. */
  int revision;

  List<MosaicPropertyDTO> properties = [];

  MosaicDefinitionDTO();

  @override
  String toString() {
    return 'MosaicDefinitionDTO[mosaicId=$mosaicId, supply=$supply, height=$height, owner=$owner, revision=$revision, properties=$properties, ]';
  }

  MosaicDefinitionDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    mosaicId = new UInt64DTO.fromJson(json['mosaicId']);
    supply = new UInt64DTO.fromJson(json['supply']);
    height = new UInt64DTO.fromJson(json['height']);
    owner = json['owner'];
    revision = json['revision'];
    properties = MosaicPropertyDTO.listFromJson(json['properties']);
  }

  Map<String, dynamic> toJson() {
    return {
      'mosaicId': mosaicId,
      'supply': supply,
      'height': height,
      'owner': owner,
      'revision': revision,
      'properties': properties
    };
  }

  static List<MosaicDefinitionDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <MosaicDefinitionDTO>[]
        : json.map((value) => new MosaicDefinitionDTO.fromJson(value)).toList();
  }

  static Map<String, MosaicDefinitionDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, MosaicDefinitionDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new MosaicDefinitionDTO.fromJson(value));
    }
    return map;
  }
}
