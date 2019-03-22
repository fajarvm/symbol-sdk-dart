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

import 'package:test/test.dart';

import 'schema/constants_test.dart' as constants_test;
import 'schema/schema_attribute_test.dart' as schema_attribute_test;
import 'schema/schema_test.dart' as schema_test;

void main() {
  group('Schema:', () {
    constants_test.main();
    schema_attribute_test.main();
    schema_test.main();
  });
}
