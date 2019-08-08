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

class NamespaceMetaDTO {
  String id;

  bool active;

  int index;

  NamespaceMetaDTO();

  @override
  String toString() {
    return 'NamespaceMetaDTO[id=$id, active=$active, index=$index, ]';
  }

  NamespaceMetaDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    id = json['id'];
    active = json['active'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'active': active, 'index': index};
  }

  static List<NamespaceMetaDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <NamespaceMetaDTO>[]
        : json.map((value) => new NamespaceMetaDTO.fromJson(value)).toList();
  }

  static Map<String, NamespaceMetaDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, NamespaceMetaDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new NamespaceMetaDTO.fromJson(value));
    }
    return map;
  }
}
