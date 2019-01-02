part of nem2_sdk_dart.core.crypto;

abstract class KeyGenerator {
  /// Creates a random key pair
  KeyPair generateKeyPair();

  /// Derives a public key from the given private key
  PublicKey derivePublicKey(final PrivateKey privateKey);
}
