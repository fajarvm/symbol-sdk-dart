part of nem2_sdk_dart.core.crypto;

/// Represents a public key
class PublicKey {
  final Uint8List _value;

  /// Creates a new public key based on the given Uint8List [value]
  PublicKey(this._value);

  /// Creates a public key based on the given [hexString]
  static PublicKey fromHexString(final String hexString) {
    try {
      final String paddedHexString = 0 == hexString.length % 2 ? hexString : "0" + hexString;
      return new PublicKey(hex.decode(paddedHexString));
    } catch (error) {
      throw new CryptoException(error.toString());
    }
  }

  /// Returns the raw public key value
  Uint8List getRaw() {
    return this._value;
  }

  @override
  int get hashCode => this._value.hashCode;

  @override
  bool operator ==(final o) {
    return (o is PublicKey) && (o.getRaw() == this._value);
  }

  @override
  String toString() {
    return hex.encode(getRaw());
  }
}
