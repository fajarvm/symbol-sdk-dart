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

library symbol_sdk_dart.sdk.model.receipt.resolution_type;

/// Resolution type enums.
class ResolutionType {
  static const String UNKNOWN_RESOLUTION_TYPE = 'unknown resolution type';

  /// Address resolution type.
  static const ResolutionType ADDRESS = ResolutionType._(0);

  /// Mosaic resolution type.
  static const ResolutionType MOSAIC = ResolutionType._(1);

  /// All supported types.
  static final List<ResolutionType> values = <ResolutionType>[ADDRESS, MOSAIC];

  /// The int value of this type.
  final int value;

  /// Returns true of this type is an address resolution type.
  bool get isAddress => ADDRESS == this;

  /// Returns true of this type is a mosaic resolution type.
  bool get isMosaic => MOSAIC == this;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const ResolutionType._(this.value);

  /// Returns a [ResolutionType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static ResolutionType fromInt(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_RESOLUTION_TYPE);
  }

  @override
  String toString() {
    return 'ResolutionType{value: $value}';
  }
}
