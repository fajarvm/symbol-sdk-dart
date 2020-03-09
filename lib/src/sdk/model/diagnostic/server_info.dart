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

library symbol_sdk_dart.sdk.model.diagnostic.server_info;

/// Describes technical information of the server.
class ServerInfo {
  /// The version of the REST API that this server is using.
  final String restVersion;

  /// The version of the SDK that this server is using.
  final String sdkVersion;

  ServerInfo(this.restVersion, this.sdkVersion);

  @override
  String toString() {
    return 'ServerInfo{restVersion: $restVersion, sdkVersion: $sdkVersion}';
  }
}
