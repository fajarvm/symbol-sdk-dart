part of nem2_sdk_dart.core.crypto;

/// Represents a private key
class PrivateKey {
  final BigInt _value;

  /// Creates a private key based on the given BigInt [value]
  PrivateKey(this._value);

  /// Creates a private key based on the given [hexString]
  static PrivateKey fromHexString(final String hexString) {
    try {
      Uint8List bytes = HexUtils.getBytes(hexString);
      final BigInt bigIntFromByes = ByteUtils.toBigInt(bytes);
      return new PrivateKey(bigIntFromByes);
    } catch (error) {
      throw new CryptoException(error.toString());
    }
  }

  /// Creates a private key based on the given [decimalString]
  static PrivateKey fromDecimalString(final String decimalString) {
    try {
      return new PrivateKey(BigInt.parse(decimalString, radix: 10));
    } catch (error) {
      throw new CryptoException(error.toString());
    }
  }

  /// Returns the raw private key value
  BigInt getRaw() {
    return this._value;
  }

  /// Returns the bytes value of this [PrivateKey]
  Uint8List getBytes() {
    return ByteUtils.bigIntToBytes(this._value);
  }

  @override
  int get hashCode => this._value.hashCode;

  @override
  bool operator ==(final o) {
    return (o is PrivateKey) && (o.getRaw() == this._value);
  }

  @override
  String toString() {
    return hex.encode(getBytes().toList());
  }
}
