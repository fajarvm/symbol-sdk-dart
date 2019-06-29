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
library nem2_sdk_dart.sdk.infrastructure.uint64_dto;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/sdk.dart' show Uint64;

import 'data_stream.dart';

class Uint64DTO {
  final Uint64 _uint64;

  Uint64DTO._(this._uint64);

  factory Uint64DTO(final int value) {
    return new Uint64DTO._(Uint64.fromBigInt(BigInt.from(value)));
  }

  BigInt get value => this._uint64.value;

  /// The size in bytes.
  int get size => 8;

  /// Creates an instance of Uint64DTO from a byte stream.
  static Uint64DTO fromStream(final DataInputStream stream) {
    return new Uint64DTO(stream.readLong());
  }

  /// Serializes Uint64DTO to bytes.
  Uint8List serialize() {
    DataOutputStream dataOutputStream = new DataOutputStream();
    dataOutputStream.write(_uint64.toBytes());
    return dataOutputStream.bytes;
  }

  @override
  String toString() {
    return 'Uint64DTO{_uint64: $_uint64}';
  }
}
