import "package:test/test.dart";
import "package:nem2_sdk_dart/src/core/utils.dart";


final HexCodec hexCodec = new HexCodec();

Map<String, List<int>> testCases = {
  "": const [],
  "0001020304050607": const [0, 1, 2, 3, 4, 5, 6, 7],
  "f0f1f2f3f4f5f6f7": const [0xf0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7],
  "6e656d": const [0x6e, 0x65, 0x6d],
};

void main() {
  /// test converting an array of bytes into a String
  test("encoding lowercase", () {
    testCases.forEach((hexString, bytes) {
      expect(hexCodec.encoder.convert(bytes), equals(hexString));
    });
  });

  test("encoding uppercase", () {
    testCases.forEach((hexString, bytes) {
      expect(const HexEncoder(toLowerCase: false).convert(bytes), equals(hexString.toUpperCase()));
    });
  });

  /// test converting a hex String into a byte array
  test("decoding lowercase", () {
    testCases.forEach((hexString, bytes) {
      expect(hexCodec.decoder.convert(hexString), orderedEquals(bytes));
    });
  });

  /// test converting invalid input
  test("invalid input", (){
    /// a byte array's size cannot exceed 8
    expect(()=> hexCodec.encode(const [256]), throwsFormatException);
    /// invalid hex string input
    expect(()=> hexCodec.decode("NEM"), throwsFormatException);
  });
}