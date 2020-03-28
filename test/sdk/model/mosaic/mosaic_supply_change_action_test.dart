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

library symbol_sdk_dart.test.sdk.model.mosaic.mosaic_supply_change_action_test;

import 'package:symbol_sdk_dart/sdk.dart' show MosaicSupplyChangeAction;
import 'package:test/test.dart';

void main() {
  group('MosaicSupplyChangeAction', () {
    test('valid mosaic supply change actions', () {
      expect(MosaicSupplyChangeAction.DECREASE.value, 0);
      expect(MosaicSupplyChangeAction.INCREASE.value, 1);

      expect(MosaicSupplyChangeAction.DECREASE.toString(),
          equals('MosaicSupplyChangeAction{value: ${MosaicSupplyChangeAction.DECREASE.value}}'));
    });

    test('Can retrieve a valid mosaic supply type', () {
      expect(MosaicSupplyChangeAction.fromInt(0), MosaicSupplyChangeAction.DECREASE);
      expect(MosaicSupplyChangeAction.fromInt(1), MosaicSupplyChangeAction.INCREASE);
    });

    test('Trying to retrieve an invalid supply type will throw an error', () {
      String errorMessage = MosaicSupplyChangeAction.UNKNOWN_MOSAIC_SUPPLY_CHANGE_ACTION;
      expect(() => MosaicSupplyChangeAction.fromInt(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => MosaicSupplyChangeAction.fromInt(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => MosaicSupplyChangeAction.fromInt(2),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });
  });
}
