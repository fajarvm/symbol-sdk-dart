part of nem2_sdk_dart.core.utils;

/**
 * A Hex [Codec] for converting hex strings to and from bytes.
 */
class HexCodec extends Codec<List<int>, String> {
  static const String DIGITS_LOWER = "0123456789abcdef";
  static const String DIGITS_UPPER = "0123456789ABCDEF";

  const HexCodec();

  @override
  Converter<String, List<int>> get decoder => const HexDecoder();

  @override
  Converter<List<int>, String> get encoder => const HexEncoder();
}

/**
 * Converts a String into an array of bytes
 */
class HexDecoder extends Converter<String, List<int>> {
  const HexDecoder();

  @override
  List<int> convert(String hexString) {
    if (hexString == null) {
      throw new ArgumentError("Input string cannot be null");
    }

    String cleanInput = StringUtils.removeAllWhitespaces(hexString.toLowerCase());
    if ((cleanInput.length % 2) != 0) {
      cleanInput = "0" + cleanInput;
    }

    // fill byte array with value
    Uint8List bytes = new Uint8List(cleanInput.length ~/ 2);
    for (var i = 0; i < bytes.length; ++i) {
      int firstDigit = HexCodec.DIGITS_LOWER.indexOf(cleanInput[i * 2]);
      int secondDigit = HexCodec.DIGITS_LOWER.indexOf(cleanInput[i * 2 + 1]);
      if (firstDigit == -1 || secondDigit == -1) {
        throw new FormatException("Invalid input. Invalid character in hexString: $hexString");
      }

      bytes[i] = (firstDigit << 4) + secondDigit;
    }

    return bytes;
  }
}

/**
 * Converts an array of bytes into a String
 */
class HexEncoder extends Converter<List<int>, String> {
  final bool toLowerCase;

  const HexEncoder({bool this.toLowerCase: true});

  @override
  String convert(List<int> bytes) {
    final StringBuffer sb = new StringBuffer();

    for (var byte in bytes) {
      if (byte & 0xff != byte) {
        throw new FormatException("Invalid input. Byte expected.");
      }

      sb.write('${(byte < 16 ? '0' : '')}${byte.toRadixString(16)}');
    }

    if (!toLowerCase) {
      return sb.toString().toUpperCase();
    } else {
      return sb.toString();
    }
  }
}
