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

class MerkleProofInfoDTO {
  /* Complementary data needed to calculate the merkle root. */
  List<MerklePathItem> merklePath = [];

  MerkleProofInfoDTO();

  @override
  String toString() {
    return 'MerkleProofInfoDTO[merklePath=$merklePath, ]';
  }

  MerkleProofInfoDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    merklePath = MerklePathItem.listFromJson(json['merklePath']);
  }

  Map<String, dynamic> toJson() {
    return {'merklePath': merklePath};
  }

  static List<MerkleProofInfoDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <MerkleProofInfoDTO>[]
        : json.map((value) => new MerkleProofInfoDTO.fromJson(value)).toList();
  }

  static Map<String, MerkleProofInfoDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, MerkleProofInfoDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new MerkleProofInfoDTO.fromJson(value));
    }
    return map;
  }
}
