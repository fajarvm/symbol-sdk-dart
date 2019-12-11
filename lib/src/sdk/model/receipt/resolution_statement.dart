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

library nem2_sdk_dart.sdk.model.receipt.resolution_statement;

import '../account/address.dart';
import '../common/uint64.dart';
import '../mosaic/mosaic_id.dart';
import 'resolution_entry.dart';
import 'resolution_type.dart';

///  When a transaction includes an alias, a so called resolution statement reflects the
///  resolved value for that block:
/// - Address Resolution: An account alias was used in the block.
/// - Mosaic Resolution: A mosaic alias was used in the block.
class ResolutionStatement<T> {
  /// The type of this resolution.
  final ResolutionType resolutionType;

  /// The block height.
  final Uint64 height;

  /// The unresolved object. It must be either an [Address] or a [MosaicId].
  final T unresolved;

  /// Returns a list of resolution entry.
  final List<ResolutionEntry> resolutionEntries;

  // private constructor
  ResolutionStatement._(this.resolutionType, this.height, this.unresolved, this.resolutionEntries);

  factory ResolutionStatement(
      ResolutionType resolutionType, Uint64 height, T unresolved, List<ResolutionEntry> entries) {
    ArgumentError.checkNotNull(resolutionType);
    ArgumentError.checkNotNull(unresolved);

    if (!_isValid(resolutionType, unresolved, entries)) {
      throw new ArgumentError('Invalid ResolutionStatement: ['
          'resolutionType="$resolutionType",'
          'unresolvedObject="$unresolved",'
          'resolutionEntries="$entries",'
          ']');
    }
    return ResolutionStatement._(resolutionType, height, unresolved, entries);
  }

  /// Validates an unresolved object against a list of resolution entry.
  ///
  /// The [unresolved] object must either be an [Address] or a [MosaicId].
  static bool _isValid(
      ResolutionType resolutionType, dynamic unresolved, List<ResolutionEntry> entries) {
    final bool isUnresolvedAddress = unresolved is Address ? true : false;
    final bool isUnresolvedMosaic = unresolved is MosaicId ? true : false;

    if (!isUnresolvedAddress && !isUnresolvedMosaic) {
      return false;
    }

    if (ResolutionType.ADDRESS == resolutionType && !isUnresolvedAddress) {
      return false;
    }

    if (ResolutionType.MOSAIC == resolutionType && !isUnresolvedMosaic) {
      return false;
    }

    for (var entry in entries) {
      if (isUnresolvedAddress && entry.resolved is Address) {
        // OK. Match found.
        return true;
      }
      if (isUnresolvedMosaic && entry.resolved is MosaicId) {
        // OK. Match found.
        return true;
      }
    }

    // No match found.
    return false;
  }
}
