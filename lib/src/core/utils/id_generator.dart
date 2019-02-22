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

library nem2_sdk_dart.core.utils.id_generator;

import 'dart:convert' show utf8;
import 'dart:typed_data' show Uint8List;

import 'package:fixnum/fixnum.dart' show Int64;

import 'package:nem2_sdk_dart/core.dart' show CryptoException, Ed25519, SHA3DigestNist, Uint64;

import 'string_utils.dart';

/// A utility class to generate Namespace and Mosaic IDs.
class IdGenerator {
  static const String MOSAIC_SEPARATOR = ':';
  static const String PART_SEPARATOR = '.';
  static const int NAMESPACE_MAX_DEPTH = 3;
  static final RegExp NAME_PATTERN = RegExp(r'^[a-z0-9][a-z0-9-_]*$');

  static final Uint64 NAMESPACE_BASE_ID = Uint64(0);

  /// Generates an Id based on [parentId] and [name]
  static Uint64 generateId(final Uint64 parentId, final String name) {
    final Uint8List parentIdBytes = parentId.toBytes();
    final Uint8List nameBytes = utf8.encode(name);

    final SHA3DigestNist digest = Ed25519.createSha3Hasher(length: Ed25519.KEY_SIZE);
    digest.update(parentIdBytes, 0, parentIdBytes.length);
    digest.update(nameBytes, 0, nameBytes.length);
    final Uint8List result = new Uint8List(32);
    digest.doFinal(result, 0);

    final Int64 int64 = Int64.fromBytes(result);
    final String hex = int64.toHexString();

    return Uint64.fromHex(hex);
  }

  /// Generates a mosaicId from a [fullName]
  static Uint64 generateMosaicId(final String fullName) {
    if (StringUtils.isEmpty(fullName)) {
      _throwInvalidFqn('having zero length', fullName);
    }

    final String mosaicName = _extractMosaicName(fullName);
    final String namespaceName = _extractNamespaceName(fullName);
    final Uint64 namespaceId = generateNamespaceId(namespaceName);

    return generateId(namespaceId, mosaicName);
  }

  /// Generates a namespaceId from a [namespaceFullName]
  static Uint64 generateNamespaceId(final String namespaceFullName) {
    try {
      final List<Uint64> namespacePath = generateNamespacePath(namespaceFullName);
      return namespacePath.last;
    } catch (e) {
      rethrow;
    }
  }

  /// Generates a list of namespace paths from a unified [namespaceFullName]
  static List<Uint64> generateNamespacePath(final String namespaceFullName) {
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

      namespaceId = generateId(namespaceId, part);
      paths.add(namespaceId);
    }

    return paths;
  }

  // ------------------------------ private / protected functions ------------------------------ //

  static void _throwInvalidFqn(final String reason, final String name) {
    throw new CryptoException('Fully qualified id is invalid due to $reason ($name)');
  }

  static String _extractNamespaceName(final String fullName) {
    String namespaceName = StringUtils.trim(fullName);
    if (namespaceName.contains(MOSAIC_SEPARATOR)) {
      final List<String> parts = namespaceName.split(MOSAIC_SEPARATOR);
      if (parts.length > 2) {
        _throwInvalidFqn('too many namespace parts', fullName);
      } else {
        namespaceName = parts[0];
      }
    }

    return namespaceName;
  }

  static String _extractMosaicName(final String fullName) {
    final String cleanFullName = StringUtils.trim(fullName);
    final int separatorIndex = cleanFullName.lastIndexOf(MOSAIC_SEPARATOR);
    if (0 > separatorIndex) {
      _throwInvalidFqn('missing mosaic', fullName);
    }

    if (0 == separatorIndex) {
      _throwInvalidFqn('empty mosaic part', fullName);
    }

    final String mosaicName = cleanFullName.split(MOSAIC_SEPARATOR).last;
    if (!_isValidNamePart(mosaicName)) {
      _throwInvalidFqn('invalid mosaic part name [$mosaicName]', fullName);
    }

    return mosaicName;
  }

  static bool _isValidNamePart(final String name) {
    final String cleanName = StringUtils.trim(name);
    return StringUtils.isNotEmpty(cleanName) && NAME_PATTERN.hasMatch(cleanName);
  }
}
