library nem2_sdk_dart.sdk.model.mosaic.mosaic;

import 'mosaic_id.dart';

import 'package:nem2_sdk_dart/core.dart' show Uint64;

/// A mosaic describes an instance of a mosaic definition.
/// Mosaics can be transferred by means of a transfer transaction.
class Mosaic {
  final MosaicId id;
  final Uint64 amount;

  const Mosaic._(this.id, this.amount);

  /// Creates a new Mosaic with the given [id] with the given [amount].
  ///
  /// The quantity is always given in smallest units for the mosaic. For example, if it has a
  /// divisibility of 3 the quantity is given in millis.
  factory Mosaic(final MosaicId id, final Uint64 amount) {
    if (id == null) {
      throw new ArgumentError('MosaicId must not be null');
    }

    return new Mosaic._(id, amount);
  }
}
