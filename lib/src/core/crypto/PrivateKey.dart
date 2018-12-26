part of nem2_sdk_dart.core.crypto;

/**
 * Represents a private key
 */
class PrivateKey {
  final BigInt _value;

  /// Creates a new private key based on the given BigInt [value]
  PrivateKey(final this._value);

  /// Creates a new private key from the given [hexString]
  ///
  /// Throws an
  static PrivateKey fromHexString(final String hexString) {
//    try {
//      HexCodec hexCodec = new HexCodec();
//      Uint8List bytes = hexCodec.decode(hexString);
//      return new PrivateKey(new BigInt.from(bytes));
//    } catch(error) {
//      //
//    }
    return null;
  }
}
