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

library nem2_sdk_dart.sdk.model.transaction.transfer_transaction;

import 'package:nem2_sdk_dart/sdk.dart';

import '../account/address.dart';
import '../account/public_account.dart';
import '../common/uint64.dart';
import '../mosaic/mosaic.dart';
import '../namespace/namespace_id.dart';
import 'deadline.dart';
import 'messages/message.dart';
import 'transaction.dart';
import 'transaction_info.dart';
import 'transaction_type.dart';
import 'transaction_version.dart';
import 'verifiable_transaction.dart';

/// Transfer transactions contain data about transfers of mosaics and message to another account.
///
/// The recipient of this kind of transaction can either be an address or a namespaceId.
class TransferTransaction extends Transaction {
  /// The recipient address.
  final Address recipientAddress;

  /// The recipient namespaceId.
  final NamespaceId recipientNamespaceId;

  /// A list of mosaics.
  final List<Mosaic> mosaics;

  /// The transaction message.
  final Message message;

  TransferTransaction(NetworkType networkType, TransactionVersion version, Deadline deadline, Uint64 fee,
      this.recipientAddress, this.recipientNamespaceId, this.mosaics, this.message,
      [String signature, PublicAccount signer, TransactionInfo transactionInfo])
      : super(TransactionType.TRANSFER, networkType, version, deadline, fee, signature, signer,
            transactionInfo);

  /// Returns the string notation of the recipient.
  String get recipientString =>
      recipientNamespaceId != null ? recipientNamespaceId.toHex() : recipientAddress.plain;

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
  VerifiableTransaction buildTransaction() {
    // TODO: implement
    return null;
  }
}
