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

library nem2_sdk_dart.sdk.model.common.id;

import 'uint64.dart';

/// An abstract class identifier used to define mosaicId and namespaceId.
abstract class Id {
  /// 64-bit unsigned integer id.
  final Uint64 id;

  Id(this.id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Id && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => 'Id'.hashCode ^ id.hashCode;

  String toHex() {
    return this.id.toHex();
  }
}
