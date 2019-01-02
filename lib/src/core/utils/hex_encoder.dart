part of nem2_sdk_dart.core.utils;

/// A utility class that provides functions for converting hex strings
/// to and from bytes.
class hex_encoder {

  /// Converts a hex string to a byte array.
  static Uint8List getBytes(final String hexString) {
    try {
      return getBytesInternal(hexString);
    } catch (e) {
      throw new ArgumentError(e);
    }
  }

  // -------------------- private / protected functions -------------------- //

  static Uint8List getBytesInternal(final String hexString) {
  final Hex codec = new Hex();
  final String paddedHexString = 0 == hexString.length() % 2 ? hexString : "0" + hexString;
  final byte[] encodedBytes = StringEncoder.getBytes(paddedHexString);
  return codec.decode(encodedBytes);
}
}
