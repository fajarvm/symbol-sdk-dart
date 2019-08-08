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

class MosaicNamesDTO {
  UInt64DTO mosaicId;

/* Mosaic linked namespace names. */
  List<String> names = [];

  MosaicNamesDTO();

  @override
  String toString() {
    return 'MosaicNamesDTO[mosaicId=$mosaicId, names=$names, ]';
  }

  MosaicNamesDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    mosaicId = new UInt64DTO.fromJson(json['mosaicId']);
    names = (json['names'] as List).map((item) => item as String).toList();
  }

  Map<String, dynamic> toJson() {
    return {'mosaicId': mosaicId, 'names': names};
  }

  static List<MosaicNamesDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <MosaicNamesDTO>[]
        : json.map((value) => new MosaicNamesDTO.fromJson(value)).toList();
  }

  static Map<String, MosaicNamesDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, MosaicNamesDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) =>
          map[key] = new MosaicNamesDTO.fromJson(value));
    }
    return map;
  }
}
