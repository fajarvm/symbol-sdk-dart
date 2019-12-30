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

library nem2_sdk_dart.test.sdk.model.transaction.deadline_test;

import 'package:nem2_sdk_dart/sdk.dart' show Deadline;
import 'package:test/test.dart';

void main() {
  group('Deadline', () {
    test('Valid constants', () {
      expect(Deadline.DEFAULT_DURATION, equals(const Duration(hours: 2)));
      expect(Deadline.TIMESTAMP_NEMESIS_BLOCK,
          equals(DateTime.fromMillisecondsSinceEpoch(1573430400000, isUtc: true)));
    });

    test('Can create a deadline with default value', () {
      final deadline = Deadline.create();
      final now = DateTime.now();

      expect(deadline.value.isAfter(now), isTrue);
      expect(deadline.value.isBefore(now), isFalse);
      // default deadline value is 2 hours from now
      expect(deadline.value.isBefore(now.add(const Duration(hours: 1))), isFalse);
      expect(deadline.value.isAfter(now.add(const Duration(hours: 3))), isFalse);
    });

    test('Can create deadline within accepted duration', () {
      // greater than 0
      expect(Deadline.create(const Duration(milliseconds: 100)).value, isNotNull);

      // less than 24 hours
      expect(Deadline.create(const Duration(hours: 24)).value, isNotNull);
    });

    test('Should correctly create deadline two hours from now', () {
      const twoHours = Duration(hours: 2);
      final deadline = Deadline.create();

      // avoid SYSTEM and UTC differences
      final networkTimestamp = DateTime.now();
      final localTimestamp = networkTimestamp.toLocal();
      final reproduceDate = localTimestamp.add(twoHours);
      expect(deadline.value.day, equals(reproduceDate.day));
      expect(deadline.value.month, equals(reproduceDate.month));
      expect(deadline.value.year, equals(reproduceDate.year));

      // now is before deadline local time
      expect(localTimestamp.isBefore(deadline.localDateTime), isTrue);

      // now + 2 hours and 2 seconds is after deadline local time
      expect(
          localTimestamp.add(const Duration(hours: 2, seconds: 2)).isAfter(deadline.localDateTime),
          isTrue);
    });

    test('Cannot create deadline outside the accepted duration', () {
      // less than 0
      expect(
          () => Deadline.create(const Duration(milliseconds: -100)),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message == 'deadline should be greater than 0')));

      // greater than 24 hours (24 hour + 1 minute)
      expect(
          () => Deadline.create(const Duration(minutes: (24 * 60) + 1)),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message == 'deadline should be less than 24 hours')));
    });
  });
}
