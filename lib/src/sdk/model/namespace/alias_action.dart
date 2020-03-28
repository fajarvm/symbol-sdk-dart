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

library symbol_sdk_dart.sdk.model.namespace.alias_action;

/// The alias action type.
class AliasAction {
  static const String UNKNOWN_ALIAS_ACTION = 'unknown alias action';

  /// Links an alias.
  static const AliasAction LINK = AliasAction._(0);

  /// Unlinks an alias.
  static const AliasAction UNLINK = AliasAction._(1);

  /// Supported alias action types.
  static final List<AliasAction> values = <AliasAction>[LINK, UNLINK];

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const AliasAction._(this.value);

  /// Returns a [AliasAction] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static AliasAction fromInt(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_ALIAS_ACTION);
  }

  @override
  String toString() {
    return 'AliasAction{value: $value}';
  }
}
