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

library nem2_sdk_dart.sdk.model.receipt.receipt;

import 'receipt_type.dart';
import 'receipt_version.dart';

/// An abstract transaction class that serves as the base class of all receipts.
class Receipt {
  final ReceiptType type;
  final ReceiptVersion version;
  final int size;

  Receipt(this.type, this.version, this.size);
}
