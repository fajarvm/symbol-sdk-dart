part of nem2_sdk_dart.core.crypto;

/// Represents a key pair
class KeyPair {
  final PrivateKey _privateKey;
  final PublicKey _publicKey;

  KeyPair._(this._privateKey, this._publicKey,
      {CryptoEngine cryptoEngine = null});

  /// Factory method to create a key pair
  ///
  /// The key pair is crated based on the provided [privateKey], [publicKey], and the [cryptoEngine].
  /// A default [cryptoEngine] will be created when it's not provided.
  /// When provided with a [privateKey], the [cryptoEngine] can derive a [publicKey] from it.
  /// When provided with an empty [privateKey], the key pair will be created around a public key.
  factory KeyPair(
      {PrivateKey privateKey = null,
      PublicKey publicKey = null,
      CryptoEngine cryptoEngine = null}) {
    final CryptoEngine engine =
        cryptoEngine == null ? CryptoEngines.defaultEngine() : cryptoEngine;
    final KeyGenerator generator = engine.createKeyGenerator();

    if (privateKey == null && publicKey == null) {
      final KeyPair pair = generator.generateKeyPair();
      return new KeyPair._(pair.privateKey, pair.publicKey,
          cryptoEngine: engine);
    }

    if (privateKey == null && publicKey != null) {
      if (engine.createKeyAnalyzer().isKeyCompressed(publicKey)) {
        throw new ArgumentError("publicKey must be in compressed form");
      }

      return new KeyPair._(null, publicKey, cryptoEngine: engine);
    }

    if (publicKey == null && privateKey != null) {
      return new KeyPair._(privateKey, generator.derivePublicKey(privateKey),
          cryptoEngine: engine);
    }

    /// unreachable code
    throw new StateError("Illegal state");
  }

  /// Gets the public key
  PublicKey get publicKey => _publicKey;

  /// Gets the private key
  PrivateKey get privateKey => _privateKey;

  /// Creates a random key pair that is compatible with the specified engine.
  static KeyPair random(final CryptoEngine engine) {
    final KeyPair pair = engine.createKeyGenerator().generateKeyPair();
    return new KeyPair._(pair.privateKey, pair.publicKey, cryptoEngine: engine);
  }

  /// Returns true if the current key pair has a private key. False if otherwise.
  bool hasPrivateKey() {
    return null != this._privateKey;
  }
}
