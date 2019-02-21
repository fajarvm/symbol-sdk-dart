library nem2_sdk_dart.sdk.model.mosaic.mosaic_id;

import 'package:nem2_sdk_dart/core.dart' show IdGenerator, StringUtils, Uint64;

/// The mosaic id structure describes mosaic id
class MosaicId {
  /// Mosaic 64-bit unsigned integer id
  final Uint64 id;

  /// Mosaic full name with namespace name (Example: nem:xem)
  final String fullName;

  const MosaicId._(this.id, this.fullName);

  /// Create a MosaicId from a 64-bit unsigned integer [id] OR a [fullName] string of the
  /// namespace-mosaic.
  ///
  /// The [fullName] argument will be used when both the [id] and the [fullName] are provided.
  factory MosaicId({final Uint64 id = null, final String fullName = null}) {
    final String fullMosaicName = StringUtils.trim(fullName);
    if (id == null && StringUtils.isEmpty(fullMosaicName)) {
      throw new ArgumentError('Missing argument. Either id or fullName is required.');
    }

    if (StringUtils.isNotEmpty(fullMosaicName)) {
      final Uint64 mosaicId = IdGenerator.generateMosaicId(fullMosaicName);
      return new MosaicId._(mosaicId, fullMosaicName);
    }

    return new MosaicId._(id, null);
  }

  /// Creates a new [MosaicId] from an [id].
  static MosaicId fromId(final Uint64 id) {
    if (id == null || id.isZero()) {
      throw new ArgumentError('The id must not be null or empty');
    }

    return new MosaicId(id: id);
  }

  /// Creates a new [MosaicId] from a [bigInt].
  static MosaicId fromBigInt(final BigInt bigInt) {
    if (bigInt == null) {
      throw new ArgumentError('The bigInt must not be null');
    }
    return new MosaicId(id: Uint64.fromBigInt(bigInt));
  }

  /// Creates a new [MosaicId] from a [fullName].
  static MosaicId fromFullName(final String fullName) {
    if (StringUtils.isEmpty(fullName)) {
      throw new ArgumentError('The fullName must not be null or empty');
    }

    return new MosaicId(fullName: fullName);
  }

  /// Creates a new [MosaicId] from a [hexString].
  static MosaicId fromHex(final String hexString) {
    if (StringUtils.isEmpty(hexString)) {
      throw new ArgumentError('The hexString must not be null or empty');
    }
    return new MosaicId(id: Uint64.fromHex(hexString));
  }

  @override
  int get hashCode {
    return this.id.hashCode + this.fullName.hashCode;
  }

  @override
  bool operator ==(other) {
    return other is MosaicId && this.id == other.id && this.fullName == other.fullName;
  }

  @override
  String toString() {
    return 'Id:${this.id}, FullName:${this.fullName}';
  }
}
