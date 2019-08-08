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

class UInt64DTO {
  UInt64DTO();

  @override
  String toString() {
    return 'UInt64DTO[]';
  }

  UInt64DTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
  }

  Map<String, dynamic> toJson() {
    return {};
  }

  static List<UInt64DTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <UInt64DTO>[]
        : json.map((value) => new UInt64DTO.fromJson(value)).toList();
  }

  static Map<String, UInt64DTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, UInt64DTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new UInt64DTO.fromJson(value));
    }
    return map;
  }
}
