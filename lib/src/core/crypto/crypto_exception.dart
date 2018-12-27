part of nem2_sdk_dart.core.crypto;

/**
 * Exception that is used when a cryptographic operation fails.
 */
class CryptoException implements Exception {
  String message;

  CryptoException([this.message = ""]);

  String toString() => "CryptoException: $message";
}