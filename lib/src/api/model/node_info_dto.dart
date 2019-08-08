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

class NodeInfoDTO {
  /* Public key used to identify the node. */
  String publicKey;

/* Port used for the communication. */
  int port;

  int networkIdentifier;

/* Version of the application. */
  int version;

  RolesTypeEnum roles;

/* IP address of the endpoint. */
  String host;

/* Name of the node. */
  String friendlyName;

  NodeInfoDTO();

  @override
  String toString() {
    return 'NodeInfoDTO[publicKey=$publicKey, port=$port, networkIdentifier=$networkIdentifier, version=$version, roles=$roles, host=$host, friendlyName=$friendlyName, ]';
  }

  NodeInfoDTO.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    publicKey = json['publicKey'];
    port = json['port'];
    networkIdentifier = json['networkIdentifier'];
    version = json['version'];
    roles = new RolesTypeEnum.fromJson(json['roles']);
    host = json['host'];
    friendlyName = json['friendlyName'];
  }

  Map<String, dynamic> toJson() {
    return {
      'publicKey': publicKey,
      'port': port,
      'networkIdentifier': networkIdentifier,
      'version': version,
      'roles': roles,
      'host': host,
      'friendlyName': friendlyName
    };
  }

  static List<NodeInfoDTO> listFromJson(List<dynamic> json) {
    return json == null
        ? <NodeInfoDTO>[]
        : json.map((value) => new NodeInfoDTO.fromJson(value)).toList();
  }

  static Map<String, NodeInfoDTO> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, NodeInfoDTO>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new NodeInfoDTO.fromJson(value));
    }
    return map;
  }
}
