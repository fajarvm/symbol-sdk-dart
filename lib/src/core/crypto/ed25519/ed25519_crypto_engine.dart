part of nem2_sdk_dart.core.crypto.ed25519;

/// Class that wraps the Ed25519 specific implementation.
class Ed25519CryptoEngine implements CryptoEngine {
  @override
  Curve getCurve() {
    return null;
  }

  @override
  DsaSigner createDsaSigner(final KeyPair keypair) {
    return null;
  }

  @override
  KeyGenerator createKeyGenerator() {
    return null;
  }

  @override
  BlockCipher createBlockCipher(
      final KeyPair senderKeyPair, final KeyPair recipientKeyPair) {
    return null;
  }

  @override
  KeyAnalyzer createKeyAnalyzer() {
    return null;
  }
}
