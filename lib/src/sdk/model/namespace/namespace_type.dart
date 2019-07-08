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
class NamespaceType {
  static const String UNKNOWN_NAMESPACE_TYPE = 'unknown namespace type';

  static const NamespaceType ROOT_NAMESPACE = NamespaceType._(0);

  static const NamespaceType SUB_NAMESPACE = NamespaceType._(1);

  static final List<NamespaceType> values = <NamespaceType>[ROOT_NAMESPACE, SUB_NAMESPACE];

  final int _value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const NamespaceType._(this._value);

  /// The int value of this type.
  int get value => _value;

  /// Returns a [NamespaceType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static NamespaceType getType(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_NAMESPACE_TYPE);
  }
}
