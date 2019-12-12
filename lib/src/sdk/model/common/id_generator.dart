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

library nem2_sdk_dart.sdk.model.common.id_generator;

import 'dart:convert' show utf8;
import 'dart:typed_data' show Uint8List;

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:nem2_sdk_dart/core.dart' show CryptoException, CryptoUtils, HexUtils, StringUtils;

import 'uint64.dart';

/// A utility class to generate Namespace and Mosaic IDs.
class IdGenerator {
  static const String PART_SEPARATOR = '.';
  static const int MOSAIC_NONCE_SIZE = 4;
  static const int NAMESPACE_MAX_DEPTH = 3;
  static final RegExp NAME_PATTERN = RegExp(r'^[a-z0-9][a-z0-9-_]*$');

  static final Uint64 NAMESPACE_BASE_ID = Uint64(0);

  /// Generates a namespaceId from the given [parentId] and [name].
  static Uint64 generateNamespaceId(final Uint64 parentId, final String name) {
    final Uint8List parentIdBytes = parentId.toBytes();
    final Uint8List nameBytes = utf8.encode(name);

    final Uint8List hash = _createSha3Hash([parentIdBytes, nameBytes]);

    // Convert to hex. Using Int64 to handle big numbers.
    final Int64 int64 = Int64.fromBytes(hash);

    Int64 result = int64 | 0x8000000000000000; // set the high bit of the hash
    // result = result.shiftRightUnsigned(0);
    final String hex = result.toHexString();

    return Uint64.fromHex(hex);
  }

  /// Generates a mosaicId from the given [nonce] and [ownerPublicId].
  static Uint64 generateMosaicId(final Uint8List nonce, final String ownerPublicId) {
    if (nonce == null || StringUtils.isEmpty(ownerPublicId)) {
      throw new ArgumentError('The nonce and/or ownerPublicId must not be null or empty.');
    }

    if (!HexUtils.isHex(ownerPublicId)) {
      throw new ArgumentError('Invalid ownerPublicId hex string.');
    }

    final Uint8List ownerBytes = HexUtils.getBytes(ownerPublicId);
    final Uint8List hash = _createSha3Hash([nonce, ownerBytes]);

    // Convert to hex. Using Int64 to handle big numbers.
    final Int64 int64 = Int64.fromBytes(hash);
    final Int64 result = int64 & 0x7FFFFFFFFFFFFFFF; // clear the high bit of the hash
    final String hex = result.toHexString();

    return Uint64.fromHex(hex);
  }

  /// Generates a namespaceId from a [namespaceFullName].
  static Uint64 generateNamespacePath(final String namespaceFullName) {
    try {
      final List<Uint64> namespacePath = generateNamespacePaths(namespaceFullName);
      return namespacePath.last;
    } catch (e) {
      rethrow;
    }
  }

  /// Generates a list of namespace paths from a unified [namespaceFullName].
  static List<Uint64> generateNamespacePaths(final String namespaceFullName) {
    final String cleanName = StringUtils.trim(namespaceFullName);
    if (StringUtils.isEmpty(cleanName)) {
      _throwInvalidFqn('having zero length', namespaceFullName);
    }

    final List<String> parts = cleanName.split(PART_SEPARATOR);
    if (parts.isEmpty) {
      _throwInvalidFqn('too few namespace parts', namespaceFullName);
    }
    if (parts.length > NAMESPACE_MAX_DEPTH) {
      _throwInvalidFqn('too many namespace parts', namespaceFullName);
    }

    Uint64 namespaceId = NAMESPACE_BASE_ID;
    final List<Uint64> paths = <Uint64>[];
    for (var part in parts) {
      if (!_isValidNamePart(part)) {
        _throwInvalidFqn('invalid namespace part name [$part]', namespaceFullName);
      }

      namespaceId = generateNamespaceId(namespaceId, part);
      paths.add(namespaceId);
    }

    return paths;
  }

  static Uint8List generateRandomMosaicNonce() {
    return CryptoUtils.getRandomBytes(IdGenerator.MOSAIC_NONCE_SIZE);
  }

  // ------------------------------ private / protected functions ------------------------------ //

  static void _throwInvalidFqn(final String reason, final String name) {
    throw new CryptoException('Fully qualified id is invalid due to $reason ($name)');
  }

  static bool _isValidNamePart(final String name) {
    final String cleanName = StringUtils.trim(name);
    return StringUtils.isNotEmpty(cleanName) && NAME_PATTERN.hasMatch(cleanName);
  }

  static Uint8List _createSha3Hash(final List<Uint8List> listOfBytes, [final int bitLength = 32]) {
    // Create a sha3-256 digest
    final digest = CryptoUtils.createSha3Digest(length: bitLength);

    // Add entries into digest
    for (var entry in listOfBytes) {
      digest.update(entry, 0, entry.length);
    }

    // Finalize
    final Uint8List result = new Uint8List(bitLength);
    digest.doFinal(result, 0);

    return result;
  }
}
