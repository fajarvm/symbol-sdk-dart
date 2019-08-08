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

class BlockMetaDTO {
  String hash;

  String generationHash;

  List<String> subCacheMerkleRoots = [];

  UInt64DTO totalFee;

  int numTransactions;

  int numStatements;

  BlockMetaDTO();

  @override
  String toString() {
    return 'BlockMetaDTO[hash=$hash, generationHash=$generationHash, subCacheMerkleRoots=$subCacheMerkleRoots, totalFee=$totalFee, numTransactions=$numTransactions, numStatements=$numStatements, ]';
  }

  BlockMetaDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    hash = json['hash'];
    generationHash = json['generationHash'];
    subCacheMerkleRoots =
        (json['subCacheMerkleRoots'] as List).map((item) => item as String).toList();
    totalFee = new UInt64DTO.fromJson(json['totalFee']);
    numTransactions = json['numTransactions'];
    numStatements = json['numStatements'];
  }

  Map<String, dynamic> toJson() {
    return {
      'hash': hash,
      'generationHash': generationHash,
      'subCacheMerkleRoots': subCacheMerkleRoots,
      'totalFee': totalFee,
      'numTransactions': numTransactions,
      'numStatements': numStatements
    };
  }

  static List<BlockMetaDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <BlockMetaDTO>[]
        : json.map((value) => new BlockMetaDTO.fromJson(value)).toList();
  }

  static Map<String, BlockMetaDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, BlockMetaDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new BlockMetaDTO.fromJson(value));
    }
    return map;
  }
}
