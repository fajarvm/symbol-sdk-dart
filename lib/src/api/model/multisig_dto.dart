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

class MultisigDTO {
  /* Public key of the account. */
  String account;

/* Address of the account decoded. */
  String accountAddress;

/* Number of signatures needed to approve a transaction. */
  int minApproval;

/* Number of signatures needed to remove a cosignatory. */
  int minRemoval;

/* Array of public keys of the cosignatory accounts. */
  List<String> cosignatories = [];

/* Array of multisig accounts where the account is cosignatory. */
  List<String> multisigAccounts = [];

  MultisigDTO();

  @override
  String toString() {
    return 'MultisigDTO[account=$account, accountAddress=$accountAddress, minApproval=$minApproval, minRemoval=$minRemoval, cosignatories=$cosignatories, multisigAccounts=$multisigAccounts, ]';
  }

  MultisigDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    account = json['account'];
    accountAddress = json['accountAddress'];
    minApproval = json['minApproval'];
    minRemoval = json['minRemoval'];
    cosignatories = (json['cosignatories'] as List).map((item) => item as String).toList();
    multisigAccounts = (json['multisigAccounts'] as List).map((item) => item as String).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'accountAddress': accountAddress,
      'minApproval': minApproval,
      'minRemoval': minRemoval,
      'cosignatories': cosignatories,
      'multisigAccounts': multisigAccounts
    };
  }

  static List<MultisigDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <MultisigDTO>[]
        : json.map((value) => new MultisigDTO.fromJson(value)).toList();
  }

  static Map<String, MultisigDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, MultisigDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new MultisigDTO.fromJson(value));
    }
    return map;
  }
}
