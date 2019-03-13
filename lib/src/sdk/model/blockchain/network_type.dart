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

/// This class is used to identify a network type.
class NetworkType {
  static const String _UNKNOWN_NETWORK_TYPE = 'network type is unknown';

  static final NetworkType _singleton = new NetworkType._();

  NetworkType._();

  factory NetworkType() {
    return _singleton;
  }

  /// The public main net network identifier (104).
  static const int MAIN_NET = 0x68; // 104

  /// The public test network identifier (152).
  static const int TEST_NET = 0x98; // 152

  /// Mijin private network identifier (96).
  static const int MIJIN = 0x60; // 96

  /// Mijin private test network identifier (144).
  static const int MIJIN_TEST = 0x90; // 144

  static int getType(final int networkType) {
    switch (networkType) {
      case MAIN_NET:
        return NetworkType.MAIN_NET;
      case TEST_NET:
        return NetworkType.TEST_NET;
      case MIJIN:
        return NetworkType.MIJIN;
      case MIJIN_TEST:
        return NetworkType.MIJIN_TEST;
      default:
        throw new ArgumentError(_UNKNOWN_NETWORK_TYPE);
    }
  }

  static bool isValid(final int networkType) {
    try {
      return 0 < getType(networkType);
    } catch (e) {
      return false;
    }
  }
}
