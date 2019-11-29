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

library nem2_sdk_dart.sdk.model.restriction.account_restriction_flags;

import 'account_restriction_type.dart';

/// Defines the restriction flags for an account.
class AccountRestrictionFlags {
  static const String UNKNOWN_ACCOUNT_RESTRICTION_FLAG = 'unknown account restriction flag';

  /// Allow only incoming transactions from a given address.
  static final AccountRestrictionFlags ALLOW_INCOMING_ADDRESS =
      AccountRestrictionFlags._(AccountRestrictionType.ADDRESS.value);

  /// Allow only incoming transactions containing a given mosaic identifier.
  static final AccountRestrictionFlags ALLOW_MOSAIC =
      AccountRestrictionFlags._(AccountRestrictionType.MOSAIC.value);

  /// Allow only incoming transactions of a given transaction type.
  static final AccountRestrictionFlags ALLOW_INCOMING_TRANSACTION_TYPE =
      AccountRestrictionFlags._(AccountRestrictionType.TRANSACTION_TYPE.value);

  /// Allow only outgoing transactions to a given address.
  static final AccountRestrictionFlags ALLOW_OUTGOING_ADDRESS = AccountRestrictionFlags._(
      AccountRestrictionType.ADDRESS.value + AccountRestrictionType.OUTGOING.value);

  /// Allow only outgoing transactions of a given transaction type.
  static final AccountRestrictionFlags ALLOW_OUTGOING_TRANSACTION_TYPE = AccountRestrictionFlags._(
      AccountRestrictionType.TRANSACTION_TYPE.value + AccountRestrictionType.OUTGOING.value);

  /// Block incoming transactions from a given address.
  static final AccountRestrictionFlags BLOCK_INCOMING_ADDRESS = AccountRestrictionFlags._(
      AccountRestrictionType.ADDRESS.value + AccountRestrictionType.BLOCK.value);

  /// Block incoming transactions containing a given mosaic identifier.
  static final AccountRestrictionFlags BLOCK_MOSAIC = AccountRestrictionFlags._(
      AccountRestrictionType.MOSAIC.value + AccountRestrictionType.BLOCK.value);

  /// Block incoming transactions of a given transaction type.
  static final AccountRestrictionFlags BLOCK_INCOMING_TRANSACTION_TYPE = AccountRestrictionFlags._(
      AccountRestrictionType.TRANSACTION_TYPE.value + AccountRestrictionType.BLOCK.value);

  /// Block outgoing transactions from a given address.
  static final AccountRestrictionFlags BLOCK_OUTGOING_ADDRESS = AccountRestrictionFlags._(
      AccountRestrictionType.ADDRESS.value +
          AccountRestrictionType.BLOCK.value +
          AccountRestrictionType.OUTGOING.value);

  /// Block outgoing transactions of a given transaction type.
  static final AccountRestrictionFlags BLOCK_OUTGOING_TRANSACTION_TYPE = AccountRestrictionFlags._(
      AccountRestrictionType.TRANSACTION_TYPE.value +
          AccountRestrictionType.BLOCK.value +
          AccountRestrictionType.OUTGOING.value);

  /// Supported restriction flags.
  static final List<AccountRestrictionFlags> values = <AccountRestrictionFlags>[
    ALLOW_INCOMING_ADDRESS,
    ALLOW_MOSAIC,
    ALLOW_INCOMING_TRANSACTION_TYPE,
    ALLOW_OUTGOING_ADDRESS,
    ALLOW_OUTGOING_TRANSACTION_TYPE,
    BLOCK_INCOMING_ADDRESS,
    BLOCK_MOSAIC,
    BLOCK_INCOMING_TRANSACTION_TYPE,
    BLOCK_OUTGOING_ADDRESS,
    BLOCK_OUTGOING_TRANSACTION_TYPE
  ];

  /// The int value of this flag.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const AccountRestrictionFlags._(this.value);

  /// Returns a [AccountRestrictionFlags] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static AccountRestrictionFlags fromInt(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_ACCOUNT_RESTRICTION_FLAG);
  }

  @override
  String toString() {
    return 'AccountRestrictionFlags{value: $value}';
  }
}
