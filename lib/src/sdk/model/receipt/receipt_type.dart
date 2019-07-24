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

library nem2_sdk_dart.sdk.model.receipt.receipt_type;

/// Receipt type enums.
class ReceiptType {
  static const String UNKNOWN_RECEIPT_TYPE = 'unknown receipt type';

  /// The recipient, account and amount of fees received for harvesting a block. It is recorded
  /// when a block is harvested.
  static const ReceiptType HARVEST_FEE = ReceiptType._(0x2143);

  /// The unresolved and resolved alias. It is recorded when a transaction indicates a valid
  /// address alias instead of an address.
  static const ReceiptType ADDRESS_ALIAS_RESOLUTION = ReceiptType._(0xF143);

  /// The unresolved and resolved alias. It is recorded when a transaction indicates a valid mosaic
  /// alias instead of a mosaicId.
  static const ReceiptType MOSAIC_ALIAS_RESOLUTION = ReceiptType._(0xF243);

  /// TA collection of state changes for a given source. It is recorded when a state change receipt
  /// is issued.
  static const ReceiptType TRANSACTION_GROUP = ReceiptType._(0xE143);

  /// The mosaicId expiring in this block. It is recorded when a mosaic expires.
  static const ReceiptType MOSAIC_EXPIRED = ReceiptType._(0x414D);

  /// The sender and recipient of the levied mosaic, the mosaicId and amount. It is recorded when a
  /// transaction has a levied mosaic.
  static const ReceiptType MOSAIC_LEVY = ReceiptType._(0x124D);

  /// The sender and recipient of the mosaicId and amount representing the cost of registering the
  /// mosaic. It is recorded when a mosaic is registered.
  static const ReceiptType MOSAIC_RENTAL_FEE = ReceiptType._(0x134D);

  /// The namespaceId expiring in this block. It is recorded when a namespace expires.
  static const ReceiptType NAMESPACE_EXPIRED = ReceiptType._(0x414E);

  /// The sender and recipient of the mosaicId and amount representing the cost of extending the
  /// namespace. It is recorded when a namespace is registered or its duration is extended.
  static const ReceiptType NAMESPACE_RENTAL_FEE = ReceiptType._(0x124E);

  /// The lockhash sender, mosaicId and amount locked. It is recorded when a valid
  /// HashLockTransaction is announced.
  static const ReceiptType LOCKHASH_CREATED = ReceiptType._(0x3148);

  /// The haslock sender, mosaicId and amount locked that is returned. It is recorded when an
  /// aggregate bonded transaction linked to the hash completes.
  static const ReceiptType LOCKHASH_COMPLETED = ReceiptType._(0x2248);

  /// The account receiving the locked mosaic, the mosaicId and the amount. It is recorded when a
  /// lock hash expires.
  static const ReceiptType LOCKHASH_EXPIRED = ReceiptType._(0x2348);

  /// The secretlock sender, mosaicId and amount locked. It is recorded when a valid
  /// SecretLockTransaction is announced.
  static const ReceiptType LOCKSECRET_CREATED = ReceiptType._(0x3152);

  /// The secretlock sender, mosaicId and amount locked. It is recorded when a secretlock is
  /// proved.
  static const ReceiptType LOCKSECRET_COMPLETED = ReceiptType._(0x2252);

  /// The account receiving the locked mosaic, the mosaicId and the amount. It is recorded when a
  /// secretlock expires.
  static const ReceiptType LOCKSECRET_EXPIRED = ReceiptType._(0x2352);

  /// The amount of native currency mosaics created. The receipt is recorded when the network has
  /// inflation configured, and a new block triggers the creation of currency mosaics.
  static const ReceiptType INFLATION = ReceiptType._(0x5143);

  /// All supported receipt types.
  static final List<ReceiptType> values = <ReceiptType>[
    HARVEST_FEE,
    ADDRESS_ALIAS_RESOLUTION,
    MOSAIC_ALIAS_RESOLUTION,
    TRANSACTION_GROUP,
    MOSAIC_EXPIRED,
    MOSAIC_LEVY,
    MOSAIC_RENTAL_FEE,
    NAMESPACE_EXPIRED,
    NAMESPACE_RENTAL_FEE,
    LOCKHASH_CREATED,
    LOCKHASH_COMPLETED,
    LOCKHASH_EXPIRED,
    LOCKSECRET_COMPLETED,
    LOCKSECRET_CREATED,
    LOCKSECRET_EXPIRED,
    INFLATION
  ];

  /// Artifact expiry type set.
  static final List<ReceiptType> ArtifactExpiry = <ReceiptType>[
    MOSAIC_EXPIRED,
    NAMESPACE_EXPIRED,
  ];

  /// Balance change type set.
  static final List<ReceiptType> BalanceChange = <ReceiptType>[
    HARVEST_FEE,
    LOCKHASH_COMPLETED,
    LOCKHASH_CREATED,
    LOCKHASH_CREATED,
    LOCKHASH_EXPIRED,
    LOCKSECRET_COMPLETED,
    LOCKSECRET_CREATED,
    LOCKSECRET_EXPIRED
  ];

  /// Balance transfer type set.
  static final List<ReceiptType> BalanceTransfer = <ReceiptType>[
    MOSAIC_RENTAL_FEE,
    NAMESPACE_RENTAL_FEE
  ];

  /// Resolution statement type set.
  static final List<ReceiptType> ResolutionStatement = <ReceiptType>[
    ADDRESS_ALIAS_RESOLUTION,
    MOSAIC_ALIAS_RESOLUTION
  ];

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const ReceiptType._(this.value);

  /// Returns a [ReceiptType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static ReceiptType fromInt(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_RECEIPT_TYPE);
  }
}
