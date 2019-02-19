library nem2_sdk_dart.sdk.model.mosaic.mosaic_id;

class MosaicId {
  final BigInt _id;
  final String _fullName;
  final String _mosaicName;
  final String _hexId;

  const MosaicId._(this._id, this._fullName, this._mosaicName, this._hexId);

  factory MosaicId(
      {final BigInt id = null,
      final String fullName = null,
      final String mosaicName = null,
      final String hexId = null}) {
    if (id != null) {
      return new MosaicId._(id, null, null, null);
    }

    return new MosaicId._(id, fullName, mosaicName, hexId);
  }

  static MosaicId fromMosaicIdentifier(final String identifier) {
    return new MosaicId(fullName: identifier);
  }
}
