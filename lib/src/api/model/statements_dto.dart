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

class StatementsDTO {
  /* Array of transaction statements for the block requested. */
  List<TransactionStatementDTO> transactionStatements = [];

/* Array of address resolutions for the block requested. */
  List<ResolutionStatementDTO> addressResolutionStatements = [];

/* Array of mosaic resolutions for the block requested. */
  List<ResolutionStatementDTO> mosaicResolutionStatements = [];

  StatementsDTO();

  @override
  String toString() {
    return 'StatementsDTO[transactionStatements=$transactionStatements, addressResolutionStatements=$addressResolutionStatements, mosaicResolutionStatements=$mosaicResolutionStatements, ]';
  }

  StatementsDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    transactionStatements = TransactionStatementDTO.listFromJson(json['transactionStatements']);
    addressResolutionStatements =
        ResolutionStatementDTO.listFromJson(json['addressResolutionStatements']);
    mosaicResolutionStatements =
        ResolutionStatementDTO.listFromJson(json['mosaicResolutionStatements']);
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionStatements': transactionStatements,
      'addressResolutionStatements': addressResolutionStatements,
      'mosaicResolutionStatements': mosaicResolutionStatements
    };
  }

  static List<StatementsDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <StatementsDTO>[]
        : json.map((value) => new StatementsDTO.fromJson(value)).toList();
  }

  static Map<String, StatementsDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, StatementsDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new StatementsDTO.fromJson(value));
    }
    return map;
  }
}
