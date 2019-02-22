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

library nem2_sdk_dart.sdk.model.blockchain.network_type;

/// This class is used to identify a network type
class NetworkType {
  static final NetworkType singleton = new NetworkType._();

  NetworkType._();

  factory NetworkType() {
    return singleton;
  }

  /// Main net network.
  static const int MAIN_NET = 0x68;

  /// Test net network.
  static const int TEST_NET = 0x98;

  /// Mijin net network.
  static const int MIJIN = 0x60;

  /// Mijin test net network.
  static const int MIJIN_TEST = 0x90;

  static bool isValidNetworkType(int networkType) =>
      networkType != null &&
      (networkType == MIJIN_TEST ||
          networkType == MIJIN ||
          networkType == TEST_NET ||
          networkType == MAIN_NET);
}
