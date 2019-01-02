part of nem2_sdk_dart.core.crypto;

abstract class KeyAnalyzer {
  /// Gets a value indicating whether or not the public key is compressed
  bool isKeyCompressed(final PublicKey publicKey);
}
