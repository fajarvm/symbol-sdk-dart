part of nem2_sdk_dart.core.crypto;

/// Represents a cryptographic engine that is a factory of crypto-providers
abstract class CryptoEngine {
  /// Returns the underlying curve
  Curve getCurve();

  /// Creates a DSA signer
  DsaSigner createDsaSigner(final KeyPair keypair);

  /// Creates a key generator
  KeyGenerator createKeyGenerator();

  /// Creates a block cipher
  ///
  /// Both the sender's private key [senderKeyPair] and the recipient's private key [recipientKeyPair] are required for encryption.
  BlockCipher createBlockCipher(final KeyPair senderKeyPair, final KeyPair recipientKeyPair);

  /// Creates a key analyzer
  KeyAnalyzer createKeyAnalyzer();
}
