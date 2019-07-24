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

library nem2_sdk_dart.test.sdk.model.account.restriction_modificatoin_type_test;

import 'package:nem2_sdk_dart/sdk.dart' show RestrictionModificationType;
import 'package:test/test.dart';

void main() {
  group('RestrictionModificationType', () {
    test('valid types', () {
      expect(RestrictionModificationType.ADD.value, 0x00);
      expect(RestrictionModificationType.DEL.value, 0x01);
    });

    test('Can retrieve a valid restriction modification type', () {
      // Account filters
      expect(RestrictionModificationType.fromInt(0x00), RestrictionModificationType.ADD);
      expect(RestrictionModificationType.fromInt(0x01), RestrictionModificationType.DEL);
    });

    test('Trying to retrieve an invalid restriction type will throw an error', () {
      String errorMessage = RestrictionModificationType.UNKNOWN_RESTRICTION_MODIFICATION_TYPE;
      expect(errorMessage, equals('unknown restriction modification type'));

      expect(() => RestrictionModificationType.fromInt(null),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => RestrictionModificationType.fromInt(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
      expect(() => RestrictionModificationType.fromInt(2),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });
  });
}
