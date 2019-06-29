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

library nem2_sdk_dart.sdk.infrastructure.amount_dto;

import 'data_input.dart';
import 'data_stream.dart';

class AmountDTO {
  final int _amount;
  final int _size = 8;

  AmountDTO(this._amount);

  int get size => _size;

  int get amount => _amount;

  static AmountDTO fromStream(final DataInput stream) {
    return new AmountDTO(stream.readLong());
  }

  static AmountDTO loadFromBinary(final DataInput stream) {
    return fromStream(stream);
  }

  List<int> serialize() {
    DataOutputStream outputStream = new DataOutputStream();
    outputStream.writeLong(_amount);
    return outputStream.bytes;
  }
}
