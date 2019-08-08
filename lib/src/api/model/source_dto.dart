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

class SourceDTO {
  /* Transaction index within the block. */
  int primaryId;

/* Transaction index inside within the aggregate transaction. If the transaction is not an inner transaction, then the secondary id is set to 0. */
  int secondaryId;

  SourceDTO();

  @override
  String toString() {
    return 'SourceDTO[primaryId=$primaryId, secondaryId=$secondaryId, ]';
  }

  SourceDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    primaryId = json['primaryId'];
    secondaryId = json['secondaryId'];
  }

  Map<String, dynamic> toJson() {
    return {'primaryId': primaryId, 'secondaryId': secondaryId};
  }

  static List<SourceDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <SourceDTO>[]
        : json.map((value) => new SourceDTO.fromJson(value)).toList();
  }

  static Map<String, SourceDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, SourceDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new SourceDTO.fromJson(value));
    }
    return map;
  }
}
