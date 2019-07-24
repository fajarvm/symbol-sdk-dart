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

library nem2_sdk_dart.sdk.model.account.restriction_modification_type;

/// The type of modification to a restriction type.
class RestrictionModificationType {
  static const String UNKNOWN_RESTRICTION_MODIFICATION_TYPE =
      'unknown restriction modification type';

  /// Addition.
  static const RestrictionModificationType ADD = RestrictionModificationType._(0x00);

  /// Deletion.
  static const RestrictionModificationType DEL = RestrictionModificationType._(0x01);

  static final List<RestrictionModificationType> values = <RestrictionModificationType>[ADD, DEL];

  /// The int value of this type.
  final int value;

  // constant constructor: makes this class available on runtime.
  // emulates an enum class with a value.
  const RestrictionModificationType._(this.value);

  /// Returns a [RestrictionModificationType] for the given int value.
  ///
  /// Throws an error when the type is unknown.
  static RestrictionModificationType fromInt(final int value) {
    for (var type in values) {
      if (type.value == value) {
        return type;
      }
    }

    throw new ArgumentError(UNKNOWN_RESTRICTION_MODIFICATION_TYPE);
  }
}
