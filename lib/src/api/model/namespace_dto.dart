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

class NamespaceDTO {
  /* Public key of the owner of the namespace. */
  String owner;

/* Address of the owner of the namespace decoded. */
  String ownerAddress;

  UInt64DTO startHeight;

  UInt64DTO endHeight;

/* Level of the namespace. */
  int depth;

  UInt64DTO level0;

  UInt64DTO level1;

  UInt64DTO level2;

  NamespaceTypeEnum type;

  AliasDTO alias;

  UInt64DTO parentId;

  NamespaceDTO();

  @override
  String toString() {
    return 'NamespaceDTO[owner=$owner, ownerAddress=$ownerAddress, startHeight=$startHeight, endHeight=$endHeight, depth=$depth, level0=$level0, level1=$level1, level2=$level2, type=$type, alias=$alias, parentId=$parentId, ]';
  }

  NamespaceDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    owner = json['owner'];
    ownerAddress = json['ownerAddress'];
    startHeight = new UInt64DTO.fromJson(json['startHeight']);
    endHeight = new UInt64DTO.fromJson(json['endHeight']);
    depth = json['depth'];
    level0 = new UInt64DTO.fromJson(json['level0']);
    level1 = new UInt64DTO.fromJson(json['level1']);
    level2 = new UInt64DTO.fromJson(json['level2']);
    type = new NamespaceTypeEnum.fromJson(json['type']);
    alias = new AliasDTO.fromJson(json['alias']);
    parentId = new UInt64DTO.fromJson(json['parentId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'owner': owner,
      'ownerAddress': ownerAddress,
      'startHeight': startHeight,
      'endHeight': endHeight,
      'depth': depth,
      'level0': level0,
      'level1': level1,
      'level2': level2,
      'type': type,
      'alias': alias,
      'parentId': parentId
    };
  }

  static List<NamespaceDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <NamespaceDTO>[]
        : json.map((value) => new NamespaceDTO.fromJson(value)).toList();
  }

  static Map<String, NamespaceDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, NamespaceDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new NamespaceDTO.fromJson(value));
    }
    return map;
  }
}
