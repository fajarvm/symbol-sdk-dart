library nem2_sdk_dart.sdk.model.mosaic.mosaic;

import 'mosaic_id.dart';

/// A mosaic describes an instance of a mosaic definition.
/// Mosaics can be transferred by means of a transfer transaction.
class Mosaic {
  final MosaicId _id;
  final BigInt _amount;

  const Mosaic._(this._id, this._amount);

  factory Mosaic(final BigInt id, final BigInt amount) {
    MosaicId mosaicId = new MosaicId();
    return new Mosaic._(mosaicId, amount);
  }

//  toDto() {
//    return {
//      amount: this._amount.
//    };
//  }
}
