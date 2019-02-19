library nem2_sdk_dart.core.utils.id_generator;

import 'dart:typed_data' show Uint8List;
import 'dart:convert' show utf8;

import 'package:fixnum/fixnum.dart' show Int64;

import 'package:nem2_sdk_dart/src/core/crypto.dart' show CryptoException, Ed25519, SHA3DigestNist;

import 'string_utils.dart';

/// A utility class to generate Namespace and Mosaic IDs.
///
/// Developer note:
/// For big numbers, choose either BigInt (Dart's native data type) or Int64 from fixnum package.
/// Please refer to this Dart language documentation page for information regarding big numbers
/// and their known issues.
/// See: https://github.com/dart-lang/sdk/blob/master/docs/language/informal/int64.md
class IdGenerator {
  static const String MOSAIC_SEPARATOR = ':';
  static const String PART_SEPARATOR = '.';
  static const int NAMESPACE_MAX_DEPTH = 3;
  static final Int64 NAMESPACE_BASE_ID = Int64(0);
  static final RegExp NAME_PATTERN = new RegExp(r"^[a-z0-9][a-z0-9-_]*$");

  /// Generates an Id based on [parentId] and [name]
  static Int64 generateId(final Int64 parentId, final String name) {
    final Uint8List parentIdBytes = Uint8List.fromList(parentId.toBytes());
    final Uint8List nameBytes = utf8.encode(name);

    final SHA3DigestNist digest = Ed25519.createSha3Hasher(length: Ed25519.KEY_SIZE);
    digest.update(parentIdBytes, 0, parentIdBytes.length);
    digest.update(nameBytes, 0, nameBytes.length);
    final result = new Uint8List(32);
    digest.doFinal(result, 0);

    return Int64.fromBytes(result);
  }

  /// Generates a mosaicId from a [fullName]
  static Int64 generateMosaicId(final String fullName) {
    if (StringUtils.isEmpty(fullName)) {
      _throwInvalidFqn('having zero length', fullName);
    }

    final String mosaicName = _extractMosaicName(fullName);
    final String namespaceName = _extractNamespaceName(fullName);
    final Int64 namespaceId = generateNamespaceId(namespaceName);

    return generateId(namespaceId, mosaicName);
  }

  /// Generates a namespaceId from a [namespaceFullName]
  static Int64 generateNamespaceId(final String namespaceFullName) {
    try {
      final List<Int64> namespacePath = generateNamespacePath(namespaceFullName);
      return namespacePath.last;
    } catch (e) {
      throw e;
    }
  }

  /// Generates a list of namespace paths from a unified [namespaceFullName]
  static List<Int64> generateNamespacePath(final String namespaceFullName) {
    final String cleanName = StringUtils.trim(namespaceFullName);
    if (0 >= cleanName.length) {
      _throwInvalidFqn('having zero length', namespaceFullName);
    }

    final List<String> parts = cleanName.split(PART_SEPARATOR);
    if (parts.length <= 0) {
      _throwInvalidFqn('too few namespace parts', namespaceFullName);
    }
    if (parts.length > NAMESPACE_MAX_DEPTH) {
      _throwInvalidFqn('too many namespace parts', namespaceFullName);
    }

    Int64 namespaceId = NAMESPACE_BASE_ID;
    List<Int64> paths = new List<Int64>();
    for (var part in parts) {
      if (!NAME_PATTERN.hasMatch(part)) {
        _throwInvalidFqn('invalid namespace part name [${part}]', namespaceFullName);
      }

      namespaceId = generateId(namespaceId, part);
      paths.add(namespaceId);
    }

    return paths;
  }

  // ------------------------------ private / protected functions ------------------------------ //

  static void _throwInvalidFqn(final String reason, final String name) {
    throw new CryptoException('Fully qualified id is invalid due to ${reason} (${name})');
  }

  static String _extractNamespaceName(final String fullName) {
    String namespaceName = StringUtils.trim(fullName);
    if (namespaceName.contains(MOSAIC_SEPARATOR)) {
      List<String> parts = namespaceName.split(MOSAIC_SEPARATOR);
      if (parts.length > 2) {
        _throwInvalidFqn('too many namespace parts', fullName);
      } else {
        namespaceName = parts[0];
      }
    }

    return namespaceName;
  }

  static String _extractMosaicName(final String fullName) {
    String mosaicName = StringUtils.trim(fullName);
    final int separatorIndex = mosaicName.lastIndexOf(MOSAIC_SEPARATOR);
    if (0 > separatorIndex) {
      _throwInvalidFqn('missing mosaic', fullName);
    }

    if (0 == separatorIndex) {
      _throwInvalidFqn('empty mosaic part', fullName);
    }

    return mosaicName.split(MOSAIC_SEPARATOR).last;
  }
}
