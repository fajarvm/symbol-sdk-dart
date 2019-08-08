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

class TransactionStatementDTO {
  UInt64DTO height;

  SourceDTO source;

/* Array of receipts. */
  List<Object> receipts = [];

  TransactionStatementDTO();

  @override
  String toString() {
    return 'TransactionStatementDTO[height=$height, source=$source, receipts=$receipts, ]';
  }

  TransactionStatementDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    height = new UInt64DTO.fromJson(json['height']);
    source = new SourceDTO.fromJson(json['source']);
    receipts = ObjectDTO.listFromJson(json['receipts']);
  }

  Map<String, dynamic> toJson() {
    return {'height': height, 'source': source, 'receipts': receipts};
  }

  static List<TransactionStatementDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <TransactionStatementDTO>[]
        : json.map((value) => new TransactionStatementDTO.fromJson(value)).toList();
  }

  static Map<String, TransactionStatementDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, TransactionStatementDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new TransactionStatementDTO.fromJson(value));
    }
    return map;
  }
}
