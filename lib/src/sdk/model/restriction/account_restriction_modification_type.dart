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

library nem2_sdk_dart.sdk.model.restriction.account_restriction_modification_type;

/// Account restriction modification type.
class AccountRestrictionModificationAction {
  static const String UNKNOWN_RESTRICTION_MODIFICATION_TYPE =
      'unknown restriction modification type';

  /// Addition.
  static const AccountRestrictionModificationAction ADD = AccountRestrictionModificationAction._(0x00);

  /// Deletion.
  static const AccountRestrictionModificationAction REMOVE = AccountRestrictionModificationAction._(0x01);

  static final List<AccountRestrictionModificationAction> values = <AccountRestrictionModificationAction>[ADD, REMOVE];

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const AccountRestrictionModificationAction._(this.value);

  /// Returns a [AccountRestrictionModificationAction] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static AccountRestrictionModificationAction fromInt(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_RESTRICTION_MODIFICATION_TYPE);
  }
}
