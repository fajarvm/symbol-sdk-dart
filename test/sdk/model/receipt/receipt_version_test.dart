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

library nem2_sdk_dart.test.sdk.model.receipt.receipt_version_test;

import 'package:nem2_sdk_dart/sdk.dart' show ReceiptVersion;
import 'package:test/test.dart';

void main() {
  group('ReceiptVersion', () {
    test('All types', () {
      expect(ReceiptVersion.BALANCE_TRANSFER.value, 1);
      expect(ReceiptVersion.BALANCE_CHANGE.value, 1);
      expect(ReceiptVersion.ARTIFACT_EXPIRY.value, 1);
      expect(ReceiptVersion.TRANSACTION_STATEMENT.value, 1);
      expect(ReceiptVersion.RESOLUTION_STATEMENT.value, 1);
      expect(ReceiptVersion.INFLATION_RECEIPT.value, 1);
    });
  });
}
