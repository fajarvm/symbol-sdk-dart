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

class ResolutionEntryDTO {
  SourceDTO source;

  UInt64DTO resolved;

  ResolutionEntryDTO();

  @override
  String toString() {
    return 'ResolutionEntryDTO[source=$source, resolved=$resolved, ]';
  }

  ResolutionEntryDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    source = new SourceDTO.fromJson(json['source']);
    resolved = new UInt64DTO.fromJson(json['resolved']);
  }

  Map<String, dynamic> toJson() {
    return {'source': source, 'resolved': resolved};
  }

  static List<ResolutionEntryDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <ResolutionEntryDTO>[]
        : json.map((value) => new ResolutionEntryDTO.fromJson(value)).toList();
  }

  static Map<String, ResolutionEntryDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, ResolutionEntryDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new ResolutionEntryDTO.fromJson(value));
    }
    return map;
  }
}
