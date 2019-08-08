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

class MultisigAccountGraphInfoDTO {
  /* Level of the multisig account. */
  int level;

/* Array of multisig accounts for this level. */
  List<MultisigAccountInfoDTO> multisigEntries = [];

  MultisigAccountGraphInfoDTO();

  @override
  String toString() {
    return 'MultisigAccountGraphInfoDTO[level=$level, multisigEntries=$multisigEntries, ]';
  }

  MultisigAccountGraphInfoDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    level = json['level'];
    multisigEntries = MultisigAccountInfoDTO.listFromJson(json['multisigEntries']);
  }

  Map<String, dynamic> toJson() {
    return {'level': level, 'multisigEntries': multisigEntries};
  }

  static List<MultisigAccountGraphInfoDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <MultisigAccountGraphInfoDTO>[]
        : json.map((value) => new MultisigAccountGraphInfoDTO.fromJson(value)).toList();
  }

  static Map<String, MultisigAccountGraphInfoDTO> mapFromJson(
      Map<String, Map<String, dynamic>> json) {
    var map = <String, MultisigAccountGraphInfoDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) =>
          map[key] = new MultisigAccountGraphInfoDTO.fromJson(value));
    }
    return map;
  }
}
