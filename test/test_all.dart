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

import 'package:test/test.dart';

import 'core/crypto_test.dart' as crypto_test;
import 'core/utils_test.dart' as utils_test;

import 'sdk/model_test.dart' as model_test;

void main() {
  // core tests
  group('Core:', () {
    crypto_test.main();
    utils_test.main();
  });

  // sdk tests
  group('SDK:', () {
    model_test.main();
  });
}
