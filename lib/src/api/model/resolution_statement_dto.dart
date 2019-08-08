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

class ResolutionStatementDTO {
  UInt64DTO height;

  UInt64DTO unresolved;

/* Array of resolution entries linked to the unresolved namespaceId. It is an array instead of a single UInt64 field since within one block the resolution might change for different sources due to alias related transactions. */
  List<ResolutionEntryDTO> resolutionEntries = [];

  ResolutionStatementDTO();

  @override
  String toString() {
    return 'ResolutionStatementDTO[height=$height, unresolved=$unresolved, resolutionEntries=$resolutionEntries, ]';
  }

  ResolutionStatementDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    height = new UInt64DTO.fromJson(json['height']);
    unresolved = new UInt64DTO.fromJson(json['unresolved']);
    resolutionEntries = ResolutionEntryDTO.listFromJson(json['resolutionEntries']);
  }

  Map<String, dynamic> toJson() {
    return {'height': height, 'unresolved': unresolved, 'resolutionEntries': resolutionEntries};
  }

  static List<ResolutionStatementDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <ResolutionStatementDTO>[]
        : json.map((value) => new ResolutionStatementDTO.fromJson(value)).toList();
  }

  static Map<String, ResolutionStatementDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, ResolutionStatementDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new ResolutionStatementDTO.fromJson(value));
    }
    return map;
  }
}
