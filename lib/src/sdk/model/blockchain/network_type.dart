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
  static const String UNKNOWN_NETWORK_TYPE = 'network type is unknown';

  /// The public main net network identifier. Decimal value = 104.
  static const NetworkType MAIN_NET = NetworkType._(0x68); // 104

  /// The public test network identifier. Decimal value = 152.
  static const NetworkType TEST_NET = NetworkType._(0x98); // 152

  /// Mijin private network identifier. Decimal value = 96.
  static const NetworkType MIJIN = NetworkType._(0x60); // 96

  /// Mijin private test network identifier. Decimal value = 144.
  static const NetworkType MIJIN_TEST = NetworkType._(0x90); // 144

  /// Supported network types.
  static final List<NetworkType> values = <NetworkType>[MAIN_NET, TEST_NET, MIJIN, MIJIN_TEST];

  final int _value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const NetworkType._(this._value);

  /// The int value of this type.
  int get value => _value;

  /// Returns a [NetworkType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static NetworkType getType(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_NETWORK_TYPE);
  }

  /// Checks if the given int value is of a valid network type.
  static bool isValid(final int networkType) {
    try {
      if (getType(networkType) != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
