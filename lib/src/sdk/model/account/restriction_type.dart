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

library nem2_sdk_dart.sdk.model.account.restriction_type;

/// The restriction type of an account.
class RestrictionType {
  static const String UNKNOWN_RESTRICTION_TYPE = 'unknown restriction type';

  /// Allows receiving transactions from an address.
  static const RestrictionType ALLOW_ADDRESS = RestrictionType._(0x01);

  /// Allows receiving transactions containing a mosaic id.
  static const RestrictionType ALLOW_MOSAIC = RestrictionType._(0x02);

  /// Allows sending transactions with a given transaction type.
  static const RestrictionType ALLOW_TRANSACTION = RestrictionType._(0x04);

  /// Property type sentinel.
  static const RestrictionType SENTINEL = RestrictionType._(0x05);

  /// Blocks receiving transactions from an address.
  static const RestrictionType BLOCK_ADDRESS = RestrictionType._(0x80 + 0x01);

  /// Blocks receiving transactions containing a mosaic id.
  static const RestrictionType BLOCK_MOSAIC = RestrictionType._(0x80 + 0x02);

  /// Blocks sending transactions with a given transaction type.
  static const RestrictionType BLOCK_TRANSACTION = RestrictionType._(0x80 + 0x04);

  /// Supported property types.
  static final List<RestrictionType> values = <RestrictionType>[
    ALLOW_ADDRESS,
    ALLOW_MOSAIC,
    ALLOW_TRANSACTION,
    SENTINEL,
    BLOCK_ADDRESS,
    BLOCK_MOSAIC,
    BLOCK_TRANSACTION
  ];

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const RestrictionType._(this.value);

  /// Returns a [RestrictionType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static RestrictionType fromInt(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_RESTRICTION_TYPE);
  }
}
