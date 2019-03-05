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

library nem2_sdk_dart.sdk.model.schema.schema_attribute;

import 'dart:typed_data' show Uint8List;

abstract class SchemaAttribute {
  final String _name;

  SchemaAttribute(this._name);

  String get name => _name;

  /// Serialize flatbuffer bytes at a certain position.
  Uint8List serialize(final Uint8List buffer, final int position, [final int innerObjectPosition]) {
    throw new UnsupportedError('Unimplemented method');
  }

  // TODO: Complete.
}
