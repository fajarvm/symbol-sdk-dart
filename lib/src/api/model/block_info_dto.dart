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

class BlockInfoDTO {
  BlockMetaDTO meta;

  BlockDTO block;

  BlockInfoDTO();

  @override
  String toString() {
    return 'BlockInfoDTO[meta=$meta, block=$block, ]';
  }

  BlockInfoDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    meta = new BlockMetaDTO.fromJson(json['meta']);
    block = new BlockDTO.fromJson(json['block']);
  }

  Map<String, dynamic> toJson() {
    return {'meta': meta, 'block': block};
  }

  static List<BlockInfoDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <BlockInfoDTO>[]
        : json.map((value) => new BlockInfoDTO.fromJson(value)).toList();
  }

  static Map<String, BlockInfoDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, BlockInfoDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new BlockInfoDTO.fromJson(value));
    }
    return map;
  }
}
