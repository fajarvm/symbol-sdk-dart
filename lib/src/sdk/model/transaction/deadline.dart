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

library nem2_sdk_dart.sdk.model.transaction.deadline;

/// The deadline of the transaction.
///
/// The deadline is given as the number of seconds elapsed since the creation of the nemesis block.
/// If a transaction does not get included in a block before the deadline is reached, it is deleted.
class Deadline {
  /// The timestamp of the nemesis block.
  ///
  /// The date is 2016/04/01 00:00:00 UTC (1459468800000 milliseconds since the epoch time).
  static final DateTime NEMESIS_BLOCK_DATETIME =
      new DateTime.fromMillisecondsSinceEpoch(1459468800000, isUtc: true);

  /// The default duration set when creating a new deadline without parameters.
  static final Duration DEFAULT_DURATION = new Duration(hours: 2);

  /// The deadline value.
  final DateTime value;

  // private constructor
  Deadline._(this.value);

  /// Create a new deadline.
  ///
  /// Default value of the duration is 2 hours. Accepted deadline is between 0 and 24 hours.
  static Deadline create([final Duration duration]) {
    if (duration == null) {
      return new Deadline._(new DateTime.now().add(DEFAULT_DURATION));
    }

    if (duration.inMilliseconds <= 0) {
      throw new ArgumentError('deadline should be greater than 0');
    }

    if (duration > new Duration(hours: 24)) {
      throw new ArgumentError('deadline should be less than 24 hours');
    }
    return new Deadline._(new DateTime.now().add(duration));
  }
}
