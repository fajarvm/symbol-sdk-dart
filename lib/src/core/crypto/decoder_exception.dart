part of nem2_sdk_dart.core.crypto;

class DecoderException implements Exception {
  String message;

  DecoderException([this.message = ""]);

  String toString() => "DecoderException: $message";
}