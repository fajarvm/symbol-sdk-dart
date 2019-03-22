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
  // The number of bits used to represent a byte value in two's complement binary form.
  static const int _BYTE_SIZE = 8;

  /// The name of this schema attribute
  final String _name;

  SchemaAttribute(this._name);

  /// Returns this schema attribute name
  String get name => _name;

  /// Serialize catbuffer bytes at a certain position.
  Uint8List serialize(final Uint8List buffer, final int position, [final int innerObjectPosition]) {
    throw new UnsupportedError('Unimplemented method');
  }

  // ------------------------------ private / protected functions ------------------------------ //

  Uint8List findParam(int innerObjectPosition, int position, Uint8List buffer, int typeSize) {
    int offset = __offset(innerObjectPosition, position, buffer);
    if (offset == 0) {
      return new Uint8List.fromList([0]);
    }

    return Uint8List.fromList(
        buffer.sublist(offset + innerObjectPosition, offset + innerObjectPosition + typeSize));
  }

  Uint8List findVector(int innerObjectPosition, int position, Uint8List buffer, int typeSize) {
    int offset = __offset(innerObjectPosition, position, buffer);
    int offsetLong = offset + innerObjectPosition;
    int vecStart = __vector(offsetLong, buffer);
    int vecLength = __vector_length(offsetLong, buffer) * typeSize;
    if (offset == 0) {
      return new Uint8List.fromList([0]);
    }

    return Uint8List.fromList(buffer.sublist(vecStart, vecStart + vecLength));
  }

  int findObjectStartPosition(int innerObjectPosition, int position, Uint8List buffer) {
    int offset = __offset(innerObjectPosition, position, buffer);
    return __indirect(offset + innerObjectPosition, buffer);
  }

  int findArrayLength(int innerObjectPosition, int position, Uint8List buffer) {
    int offset = __offset(innerObjectPosition, position, buffer);
    return offset == 0 ? 0 : __vector_length(innerObjectPosition + offset, buffer);
  }

  int findObjectArrayElementStartPosition(
      int innerObjectPosition, int position, Uint8List buffer, int startPosition) {
    int offset = __offset(innerObjectPosition, position, buffer);
    int vector = __vector(innerObjectPosition + offset, buffer);
    return __indirect(vector + startPosition * 4, buffer);
  }

  int readInt32(int offset, Uint8List buffer) {
    int value = (buffer[offset + 3] << (_BYTE_SIZE * 3));
    value |= (buffer[offset + 2] & 0xFF) << (_BYTE_SIZE * 2);
    value |= (buffer[offset + 1] & 0xFF) << (_BYTE_SIZE);
    value |= (buffer[offset] & 0xFF);
    return value;
  }

  int readInt16(int offset, Uint8List buffer) {
    int value = (buffer[offset + 1] & 0xFF) << (_BYTE_SIZE);
    value |= (buffer[offset] & 0xFF);
    return value;
  }

  int __offset(int innerObjectPosition, int position, Uint8List buffer) {
    int vtable = innerObjectPosition - readInt32(innerObjectPosition, buffer);
    return position < readInt16(vtable, buffer) ? readInt16(vtable + position, buffer) : 0;
  }

  int __vector_length(int offset, Uint8List buffer) {
    return readInt32(offset + readInt32(offset, buffer), buffer);
  }

  int __indirect(int offset, Uint8List buffer) {
    return offset + readInt32(offset, buffer);
  }

  int __vector(int offset, Uint8List buffer) {
    return offset + readInt32(offset, buffer) + 4;
  }
}
