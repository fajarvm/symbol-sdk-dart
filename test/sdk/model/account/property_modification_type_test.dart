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

library nem2_sdk_dart.test.sdk.model.account.property_modificatoin_type_test;

import 'package:nem2_sdk_dart/sdk.dart' show PropertyModificationType;
import 'package:test/test.dart';

void main() {
  group('PropertyModificationType', () {
    test('valid transaction types', () {
      expect(PropertyModificationType.ADD.value, 0x00);
      expect(PropertyModificationType.DEL.value, 0x01);
    });

    test('Can retrieve a valid transaction types', () {
      // Account filters
      expect(PropertyModificationType.getType(0x00), PropertyModificationType.ADD);
      expect(PropertyModificationType.getType(0x01), PropertyModificationType.DEL);
    });

    test('Trying to retrieve an invalid property type will throw an error', () {
      String errorMessage = PropertyModificationType.UNKNOWN_PROPERTY_MODIFICATION_TYPE;
      expect(() => PropertyModificationType.getType(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => PropertyModificationType.getType(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => PropertyModificationType.getType(2),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });
  });
}
