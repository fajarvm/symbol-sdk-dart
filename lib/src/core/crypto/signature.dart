part of nem2_sdk_dart.core.crypto;

class Signature {
  static final BigInt MAXIMUM_VALUE = (BigInt.one << 256) - BigInt.one;

  final Uint8List _r;
  final Uint8List _s;

  Signature._(this._r, this._s);

  factory Signature(
      {final BigInt rBigInt = null,
      final BigInt sBigInt = null,
      final Uint8List bytes = null,
      final Uint8List rBytes = null,
      final Uint8List sBytes = null}) {
    /// Using bytes arguments
    if (bytes != null) {
      if (bytes.length != 64) {
        throw new ArgumentError(
            "binary signature representation must be 64 bytes");
      }

      final Uint8List r = bytes.take(32);
      final Uint8List s = bytes.skip(32).take(32);

      return new Signature._(r, s);
    }

    if (rBytes != null && sBytes != null) {
      if (rBytes.length != 32 || sBytes.length != 32) {
        throw new ArgumentError(
            "binary signature representation of r and s must both have 32 bytes length");
      }

      return new Signature._(rBytes, sBytes);
    }

    /// Using BigInt arguments
    if (rBigInt != null && sBigInt != null) {
      if (0 < rBigInt.compareTo(MAXIMUM_VALUE) ||
          0 < sBigInt.compareTo(MAXIMUM_VALUE)) {
        throw new ArgumentError("BigInt r and s must fit into 32 bytes");
      }

      final Uint8List r = ArrayUtils.toByteArray(rBigInt, 32);
      final Uint8List s = ArrayUtils.toByteArray(sBigInt, 32);

      return new Signature._(r, s);
    }

    throw new ArgumentError("Cannot create a Signature. Missing arguments.");
  }
}
