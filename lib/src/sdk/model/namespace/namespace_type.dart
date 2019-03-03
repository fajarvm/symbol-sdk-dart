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

library nem2_sdk_dart.sdk.model.namespace.namespace_type;

/// The namespace type.
///
/// Supported supply types are:
/// * 0: Namespace.
/// * 1: Sub namespace.
class NamespaceType {
  static const int ROOT_NAMESPACE = 0;

  static const int SUB_NAMESPACE = 1;

  static final NamespaceType _singleton = new NamespaceType._();

  NamespaceType._();

  factory NamespaceType() {
    return _singleton;
  }

  static int getNamespaceType(final int namespaceType) {
    switch (namespaceType) {
      case ROOT_NAMESPACE:
        return NamespaceType.ROOT_NAMESPACE;
      case SUB_NAMESPACE:
        return NamespaceType.SUB_NAMESPACE;
      default:
        throw new ArgumentError('invalid namespace type');
    }
  }
}
