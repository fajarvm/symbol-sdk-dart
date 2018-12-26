import "package:test/test.dart";
import "package:nem2_sdk_dart/src/core/utils.dart";

import "dart:typed_data" show Uint8List;

final HexCodec hexCodec = new HexCodec();

void main() {
  testGetBytes();
  testGetString();
}

// --------------------------------------------------- test cases --------------------------------------------------- //

void testGetBytes() {
  /// test converting a valid hex string into a byte array
  assertGetBytesConversion("4e454d465457", Uint8List.fromList([0x4e, 0x45, 0x4d, 0x46, 0x54, 0x57]));

  /// with allowReturnNull parameter
  assertGetBytesConversion("4e454d465457", Uint8List.fromList([0x4e, 0x45, 0x4d, 0x46, 0x54, 0x57]),
      allowReturnNull: true);

  /// test converting a valid hex string with odd length into a byte array
  assertGetBytesConversion("e454d465457", Uint8List.fromList([0x0e, 0x45, 0x4d, 0x46, 0x54, 0x57]));

  /// with allowReturnNull parameter
  assertGetBytesConversion("e454d465457", Uint8List.fromList([0x0e, 0x45, 0x4d, 0x46, 0x54, 0x57]),
      allowReturnNull: true);

  /// test converting a valid hex string with leading zero into a byte array
  assertGetBytesConversion("00000d465457", Uint8List.fromList([0x00, 0x00, 0x0d, 0x46, 0x54, 0x57]));

  /// with allowReturnNull parameter
  assertGetBytesConversion("00000d465457", Uint8List.fromList([0x00, 0x00, 0x0d, 0x46, 0x54, 0x57]),
      allowReturnNull: true);

  /// cannot convert malformed hex string. Expect null as the output
  assertGetBytesConversion("4e454g465457", null, allowReturnNull: true);
}

void testGetString() {
  /// test converting a byte array into a string
  assertGetStringConversion(Uint8List.fromList([0x4e, 0x45, 0x4d, 0x46, 0x54, 0x57]), "4e454d465457");

  /// test converting a byte array with leading zeroes into a string
  assertGetStringConversion(Uint8List.fromList([0x00, 0x00, 0x0d, 0x46, 0x54, 0x57]), "00000d465457");
}

// ------------------------------------------- private/protected methods ------------------------------------------- //

void assertGetBytesConversion(final String input, final Uint8List expectedOutput, {final bool allowReturnNull: false}) {
  final Uint8List output = hexCodec.getBytes(input, returnNull: allowReturnNull);
  test("assertGetBytesConversion", () {
    expect(output, equals(expectedOutput));
  });
}

void assertGetStringConversion(final Uint8List input, final String expectedOutput) {
  final String output = hexCodec.getString(input);
  test("assertGetStringConversion", () {
    expect(output, equals(expectedOutput));
  });
}
