part of nem2_sdk_dart.core.crypto;

/// Static class that exposes crypto engines.
class CryptoEngines {
  static final CryptoEngine ED25519_ENGINE = null; // TODO: new Ed25519CryptoEngine();
  static final CryptoEngine DEFAULT_ENGINE = ED25519_ENGINE;

  /// Gets the default crypto engine.
  static CryptoEngine defaultEngine() {
    return DEFAULT_ENGINE;
  }

  /// Gets the ED25519 crypto engine.
  static CryptoEngine ed25519Engine() {
    return ED25519_ENGINE;
  }
}
