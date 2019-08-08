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

class NamespaceTypeEnum {
  /// The underlying value of this enum member.
  int value;

  NamespaceTypeEnum._internal(this.value);

  /// Type of namespace: * 0 - Root namespace. * 1 - Subnamespace.
  static NamespaceTypeEnum number0_ = NamespaceTypeEnum._internal(0);

  /// Type of namespace: * 0 - Root namespace. * 1 - Subnamespace.
  static NamespaceTypeEnum number1_ = NamespaceTypeEnum._internal(1);

  NamespaceTypeEnum.fromJson(dynamic data) {
    switch (data) {
      case 0:
        value = data;
        break;
      case 1:
        value = data;
        break;
      default:
        throw ArgumentError('Unknown enum value to decode: $data');
    }
  }

  static dynamic encode(NamespaceTypeEnum data) {
    return data.value;
  }
}
