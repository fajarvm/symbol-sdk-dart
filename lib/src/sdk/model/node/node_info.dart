//
// Copyright (c) 2020 Fajar van Megen
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

library symbol_sdk_dart.sdk.model.node.node_info;

import '../blockchain/network_type.dart';
import 'role_type.dart';

/// The node info structure describes basic information of a node.
class NodeInfo {
  /// The public key used to identify the node.
  final String publicKey;

  /// The port used for the communication.
  final int port;

  /// The network identifier.
  final NetworkType networkIdentifier;

  /// The version of the application.
  final int version;

  /// The role of the application.
  final RoleType role;

  /// The IP address of the endpoint.
  final String host;

  /// The name of the node.
  final String friendlyName;

  NodeInfo(this.publicKey, this.port, this.networkIdentifier, this.version, this.role, this.host,
      this.friendlyName);

  @override
  String toString() {
    return 'NodeInfo{'
        'publicKey: $publicKey, '
        'port: $port, '
        'networkIdentifier: $networkIdentifier, '
        'version: $version, '
        'role: $role, '
        'host: $host, '
        'friendlyName: $friendlyName'
        '}';
  }
}
