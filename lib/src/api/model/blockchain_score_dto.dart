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

class BlockchainScoreDTO {
  UInt64DTO scoreHigh;

  UInt64DTO scoreLow;

  BlockchainScoreDTO();

  @override
  String toString() {
    return 'BlockchainScoreDTO[scoreHigh=$scoreHigh, scoreLow=$scoreLow, ]';
  }

  BlockchainScoreDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    scoreHigh = new UInt64DTO.fromJson(json['scoreHigh']);
    scoreLow = new UInt64DTO.fromJson(json['scoreLow']);
  }

  Map<String, dynamic> toJson() {
    return {'scoreHigh': scoreHigh, 'scoreLow': scoreLow};
  }

  static List<BlockchainScoreDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <BlockchainScoreDTO>[]
        : json.map((value) => new BlockchainScoreDTO.fromJson(value)).toList();
  }

  static Map<String, BlockchainScoreDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, BlockchainScoreDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new BlockchainScoreDTO.fromJson(value));
    }
    return map;
  }
}
