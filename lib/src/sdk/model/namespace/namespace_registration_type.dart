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

library symbol_sdk_dart.sdk.model.namespace.namespace_registration_type;

/// The namespace registration type.
class NamespaceRegistrationType {
  static const String UNKNOWN_NAMESPACE_REGISTRATION_TYPE = 'unknown namespace registration type';

  /// Indicates a root namespace.
  static const NamespaceRegistrationType ROOT_NAMESPACE = NamespaceRegistrationType._(0);

  /// Indicates a sub namespace.
  static const NamespaceRegistrationType SUB_NAMESPACE = NamespaceRegistrationType._(1);

  /// Supported namespace types.
  static final List<NamespaceRegistrationType> values = <NamespaceRegistrationType>[ROOT_NAMESPACE, SUB_NAMESPACE];

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const NamespaceRegistrationType._(this.value);

  /// Returns a [NamespaceRegistrationType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static NamespaceRegistrationType fromInt(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_NAMESPACE_REGISTRATION_TYPE);
  }

  @override
  String toString() {
    return 'NamespaceRegistrationType{value: $value}';
  }
}
