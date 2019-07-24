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

library nem2_sdk_dart.test.sdk.model.node.node_time_test;

import 'package:nem2_sdk_dart/sdk.dart';
import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show NodeTime;

void main() {
  group('NodeTime', () {
    test('Can create a new NodeTime object', () {
      Uint64 send = Uint64.fromBigInt(BigInt.from(1234567890));
      Uint64 receive = Uint64.fromBigInt(BigInt.from(987654321));
      NodeTime nodeTime = new NodeTime(send, receive);
      expect(nodeTime.sendTimeStamp.value.toInt(), equals(1234567890));
      expect(nodeTime.receiveTimeStamp.value.toInt(), equals(987654321));
    });
  });
}
