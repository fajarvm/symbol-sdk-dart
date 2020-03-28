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

library symbol_sdk_dart.test.sdk.model.account.activity_bucket_test;

import 'package:symbol_sdk_dart/sdk.dart' show ActivityBucket;
import 'package:test/test.dart';

void main() {
  group('ActivityBucket', () {
    test('can create an ActivityBucket object', () {
      const startHeight = '1000';
      const totalFeesPaid = 100;
      const beneficiaryCount = 1;
      const rawScore = 20;
      final activityBucket = ActivityBucket(startHeight, totalFeesPaid, beneficiaryCount, rawScore);

      expect(activityBucket.startHeight, equals(startHeight));
      expect(activityBucket.totalFeesPaid, equals(totalFeesPaid));
      expect(activityBucket.beneficiaryCount, equals(beneficiaryCount));
      expect(activityBucket.rawScore, equals(rawScore));

      const toString = 'ActivityBucket{'
          'startHeight: $startHeight, '
          'totalFeesPaid: $totalFeesPaid, '
          'beneficiaryCount: $beneficiaryCount, '
          'rawScore: $rawScore'
          '}';
      expect(activityBucket.toString(), equals(toString));
    });
  });
}
