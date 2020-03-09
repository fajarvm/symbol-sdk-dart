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

library symbol_sdk_dart.sdk.model.transaction.transfer_transaction;

import 'dart:typed_data' show Uint8List;

import '../account/address.dart';
import '../account/public_account.dart';
import '../blockchain/network_type.dart';
import '../common/uint64.dart';
import '../message/message.dart';
import '../mosaic/mosaic.dart';
import '../namespace/namespace_id.dart';
import 'deadline.dart';
import 'transaction.dart';
import 'transaction_info.dart';
import 'transaction_type.dart';
import 'transaction_version.dart';

/// Transfer transaction object contain data about transfers of mosaics and message to another
/// account.
///
/// The recipient of this kind of transaction can either be an address or a namespaceId.
class TransferTransaction extends Transaction {
  /// The recipient address.
  final Address address;

  /// The recipient namespaceId.
  final NamespaceId namespaceId;

  /// A list of mosaics.
  final List<Mosaic> mosaics;

  /// The transaction message.
  final Message message;

  TransferTransaction(NetworkType networkType, TransactionVersion version, Deadline deadline,
      Uint64 fee, this.address, this.namespaceId, this.mosaics, this.message,
      [String signature, PublicAccount signer, TransactionInfo transactionInfo])
      : super(TransactionType.TRANSFER, networkType, version, deadline, fee, signature, signer,
            transactionInfo);

  /// Returns the string notation of the recipient.
  String get recipient => namespaceId != null ? namespaceId.toHex() : address.plain;

  /// Creates a transfer transaction object.
  static TransferTransaction create(
      final Deadline deadline,
      final Address recipientAddress,
      final NamespaceId recipientNamespaceId,
      final List<Mosaic> mosaics,
      final Message message,
      final NetworkType networkType) {
    return new TransferTransaction(networkType, TransactionVersion.TRANSFER, deadline, Uint64(0),
        recipientAddress, recipientNamespaceId, mosaics, message);
  }

  @override
  Uint8List generateEmbeddedBytes() {
    // TODO: implement
    return null;
  }

  @override
  Uint8List generateBytes() {
    // TODO: implement
    return null;
  }
}
