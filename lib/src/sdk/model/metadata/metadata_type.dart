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

library nem2_sdk_dart.sdk.model.metadata.metadata_type;

/// The metadata type.
class MetadataType {
  static const String UNKNOWN_METADATA_TYPE = 'unknown metadata type';

  /// Persistent harvesting delegation.
  static const MetadataType ACCOUNT = MetadataType._(0);

  static const MetadataType MOSAIC = MetadataType._(1);

  static const MetadataType NAMESPACE = MetadataType._(2);

  static final List<MetadataType> values = <MetadataType>[ACCOUNT, MOSAIC, NAMESPACE];

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const MetadataType._(this.value);

  /// Returns a [MetadataType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static MetadataType getType(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_METADATA_TYPE);
  }

  @override
  String toString() {
    return 'MetadataType{value: $value}';
  }
}
