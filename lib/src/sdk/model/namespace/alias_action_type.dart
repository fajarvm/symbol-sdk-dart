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

library nem2_sdk_dart.sdk.model.namespace.alias_action_type;

/// The alias action type.
class AliasActionType {
  static const String UNKNOWN_ALIAS_ACTION_TYPE = 'unknown alias action type';

  /// Links an alias.
  static const AliasActionType LINK = AliasActionType._(0);

  /// Unlinks an alias.
  static const AliasActionType UNLINK = AliasActionType._(1);

  static final List<AliasActionType> values = <AliasActionType>[LINK, UNLINK];

  final int _value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const AliasActionType._(this._value);

  /// The int value of this type.
  int get value => _value;

  /// Returns a [AliasActionType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static AliasActionType getType(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_ALIAS_ACTION_TYPE);
  }
}
