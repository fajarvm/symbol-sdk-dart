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

library nem2_sdk_dart.sdk.model.restriction.account_restriction_type;

/// The restriction type of an account.
///
/// Supported types are:
/// * 0x0001	Account restriction type is an address.
/// * 0x0002	Account restriction type is a mosaic id.
/// * 0x0004	Account restriction type is a transaction type.
/// * 0x4000  Account restriction is interpreted as outgoing restriction.
/// * 0x8000  Account restriction is interpreted as blocking operation.
class AccountRestrictionType {
  static const String UNKNOWN_ACCOUNT_RESTRICTION_TYPE = 'unknown account restriction type';

  /// Address restriction type.
  static const AccountRestrictionType ADDRESS = AccountRestrictionType._(0x0001);

  /// Mosaic identifier restriction type.
  static const AccountRestrictionType MOSAIC = AccountRestrictionType._(0x0002);

  /// Transaction type restriction type.
  static const AccountRestrictionType TRANSACTION_TYPE = AccountRestrictionType._(0x0004);

  /// Outgoing transaction restriction type.
  static const AccountRestrictionType OUTGOING = AccountRestrictionType._(0x4000);

  /// Blocking operation restriction type.
  static const AccountRestrictionType BLOCK = AccountRestrictionType._(0x8000);

  /// Supported restriction types.
  static final List<AccountRestrictionType> values = <AccountRestrictionType>[
    ADDRESS,
    MOSAIC,
    TRANSACTION_TYPE,
    OUTGOING,
    BLOCK
  ];

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const AccountRestrictionType._(this.value);

  /// Returns a [AccountRestrictionType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static AccountRestrictionType fromInt(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_ACCOUNT_RESTRICTION_TYPE);
  }
}
