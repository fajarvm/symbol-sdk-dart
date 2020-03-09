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

library symbol_sdk_dart.sdk.model.receipt.receipt_version;

/// Receipt version enums.
class ReceiptVersion {
  /// Balance transfer receipt version.
  static const ReceiptVersion BALANCE_TRANSFER = ReceiptVersion._(1);

  /// Balance change receipt version.
  static const ReceiptVersion BALANCE_CHANGE = ReceiptVersion._(1);

  /// Artifact expiry receipt version.
  static const ReceiptVersion ARTIFACT_EXPIRY = ReceiptVersion._(1);

  /// Transaction statement receipt version.
  static const ReceiptVersion TRANSACTION_STATEMENT = ReceiptVersion._(1);

  /// Resolution statement receipt version.
  static const ReceiptVersion RESOLUTION_STATEMENT = ReceiptVersion._(1);

  /// Inflation receipt version.
  static const ReceiptVersion INFLATION_RECEIPT = ReceiptVersion._(1);

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const ReceiptVersion._(this.value);
}
