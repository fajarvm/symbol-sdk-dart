library nem2_sdk_dart.sdk.model.mosaic.mosaic_id;

import 'package:fixnum/fixnum.dart' show Int64;

import 'package:nem2_sdk_dart/core.dart' show IdGenerator, StringUtils;

/// The mosaic id structure describes mosaic id
class MosaicId {
  /// Mosaic integer id
  final Int64 id;

  /// Mosaic full name with namespace name (Example: nem:xem)
  final String fullName;

  const MosaicId._(this.id, this.fullName);

  /// Create a MosaicId from integer [id] or a namespace-mosaic [fullName].
  factory MosaicId({final Int64 id, final String fullName = null}) {
    final String fullMosaicName = StringUtils.trim(fullName);
    if (id == null && StringUtils.isEmpty(fullMosaicName)) {
      throw new ArgumentError('Missing argument. Either Id or fullName is required.');
    }

    if (StringUtils.isNotEmpty(fullMosaicName)) {
      final Int64 mosaicId = IdGenerator.generateMosaicId(fullMosaicName);
      return new MosaicId._(mosaicId, fullMosaicName);
    }

    return new MosaicId._(id, null);
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
    return 'Id:${this.id},FullName:${this.fullName}';
  }
}
