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

library symbol_sdk_dart.test.sdk.model.receipt.receipt_source_test;

import 'package:symbol_sdk_dart/sdk.dart' show ReceiptSource;
import 'package:test/test.dart';

void main() {
  group('ReceiptSource', () {
    // setup
    ReceiptSource receiptSource = new ReceiptSource(1, 2);

    test('Can create a receipt source object', () {
      expect(receiptSource.primaryId, 1);
      expect(receiptSource.secondaryId, 2);
    });

    test('serialize()', () {
      final serialized = receiptSource.serialize();
      expect(serialized, isNotNull);
      expect(serialized.lengthInBytes, 8);
    });
  });
}
