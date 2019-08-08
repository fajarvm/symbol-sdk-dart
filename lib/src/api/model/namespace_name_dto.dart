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

class NamespaceNameDTO {
  UInt64DTO parentId;

  UInt64DTO namespaceId;

/* Name of the namespace. */
  String name;

  NamespaceNameDTO();

  @override
  String toString() {
    return 'NamespaceNameDTO[parentId=$parentId, namespaceId=$namespaceId, name=$name, ]';
  }

  NamespaceNameDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    parentId = new UInt64DTO.fromJson(json['parentId']);
    namespaceId = new UInt64DTO.fromJson(json['namespaceId']);
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {'parentId': parentId, 'namespaceId': namespaceId, 'name': name};
  }

  static List<NamespaceNameDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <NamespaceNameDTO>[]
        : json.map((value) => new NamespaceNameDTO.fromJson(value)).toList();
  }

  static Map<String, NamespaceNameDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, NamespaceNameDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new NamespaceNameDTO.fromJson(value));
    }
    return map;
  }
}
