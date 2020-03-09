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

library symbol_sdk_dart.sdk.model.account.acount_type;

/// The type of an account.
///
/// Available types:
/// * 0 - Unlinked.
/// * 1 - Main account that is linked to a remote harvester account.
/// * 2 - Remote harvester account that is linked to a balance-holding account.
/// * 3 - Remote harvester eligible account that is unlinked.
class AccountType {
  static const String UNKNOWN_ACCOUNT_TYPE = 'unknown account type';

  /// Unlinked.
  static const AccountType UNLINKED = AccountType._(0);

  /// Balance-holding account that is linked to a remote harvester account.
  static const AccountType MAIN = AccountType._(1);

  /// Remote harvester account that is linked to a balance-holding account.
  static const AccountType REMOTE = AccountType._(2);

  /// Remote harvester eligible account that is unlinked.
  static const AccountType REMOTE_UNLINKED = AccountType._(3);

  /// Supported account types.
  static final List<AccountType> values = <AccountType>[UNLINKED, MAIN, REMOTE, REMOTE_UNLINKED];

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const AccountType._(this.value);

  /// Returns a [AccountType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static AccountType fromInt(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_ACCOUNT_TYPE);
  }

  @override
  String toString() {
    return 'AccountType{value: $value}';
  }
}
