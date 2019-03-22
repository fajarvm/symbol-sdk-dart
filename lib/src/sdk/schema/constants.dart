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

library nem2_sdk_dart.sdk.model.schema.constants;

class Constants {
  static const String _UNKNOWN_SCHEMA_CONSTANT = 'unknown schema constant';

  /// The number of bytes in an `byte`.
  static const int SIZEOF_BYTE = 1;

  /// The number of bytes in an `short`.
  static const int SIZEOF_SHORT = 2;

  /// The number of bytes in an `int`.
  static const int SIZEOF_INT = 4;

  /// The number of bytes in an `float`.
  static const int SIZEOF_FLOAT = 4;

  /// The number of bytes in an `long`.
  static const int SIZEOF_LONG = 8;

  /// The number of bytes in an `double`.
  static const int SIZEOF_DOUBLE = 8;

  /// The number of bytes in an file identifier.
  static const int FILE_IDENTIFIER_LENGTH = 4;

  static final Constants _singleton = new Constants._();

  Constants._();

  factory Constants() {
    return _singleton;
  }

  static int getValue(final int constant) {
    switch (constant) {
      case SIZEOF_BYTE:
        return Constants.SIZEOF_BYTE;
      case SIZEOF_SHORT:
        return Constants.SIZEOF_SHORT;
      case SIZEOF_INT:
        return Constants.SIZEOF_INT;
      case SIZEOF_FLOAT:
        return Constants.SIZEOF_FLOAT;
      case SIZEOF_DOUBLE:
        return Constants.SIZEOF_DOUBLE;
      case FILE_IDENTIFIER_LENGTH:
        return Constants.FILE_IDENTIFIER_LENGTH;
      default:
        throw new ArgumentError(_UNKNOWN_SCHEMA_CONSTANT);
    }
  }
}
