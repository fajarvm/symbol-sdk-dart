library nem2_sdk_dart.test.core.utils.hex_utils_test;

import "dart:typed_data" show Uint8List;

import "package:test/test.dart";

import "package:nem2_sdk_dart/src/core/utils.dart" show HexUtils;

main() {
  test("getBytes() can convert valid string to byte array", () {
    final List<int> actual = HexUtils.getBytes("4e454d465457");
    final Uint8List expectedOutput =
        Uint8List.fromList([0x4e, 0x45, 0x4d, 0x46, 0x54, 0x57]);
    expect(actual, equals(expectedOutput));
  });

  test("getBytes() can convert valid string with odd length to byte array", () {
    final List<int> actual = HexUtils.getBytes("e454d465457");
    final Uint8List expectedOutput =
        Uint8List.fromList([0x0e, 0x45, 0x4d, 0x46, 0x54, 0x57]);
    expect(actual, equals(expectedOutput));
  });

  test("getBytes() can convert valid string with leading zeros to byte array",
      () {
    final List<int> actual = HexUtils.getBytes("00000d465457");
    final Uint8List expectedOutput =
        Uint8List.fromList([0x00, 0x00, 0x0d, 0x46, 0x54, 0x57]);
    expect(actual, equals(expectedOutput));
  });

  test("tryGetBytes() can convert valid string to byte array", () {
    final List<int> actual = HexUtils.tryGetBytes("4e454d465457");
    final Uint8List expectedOutput =
        Uint8List.fromList([0x4e, 0x45, 0x4d, 0x46, 0x54, 0x57]);
    expect(actual, equals(expectedOutput));
  });

  test("tryGetBytes() can convert valid string with odd length to byte array",
      () {
    final List<int> actual = HexUtils.tryGetBytes("e454d465457");
    final Uint8List expectedOutput =
        Uint8List.fromList([0x0e, 0x45, 0x4d, 0x46, 0x54, 0x57]);
    expect(actual, equals(expectedOutput));
  });

  test(
      "tryGetBytes() can convert valid string with leading zeros to byte array",
      () {
    final List<int> actual = HexUtils.tryGetBytes("00000d465457");
    final Uint8List expectedOutput =
        Uint8List.fromList([0x00, 0x00, 0x0d, 0x46, 0x54, 0x57]);
    expect(actual, equals(expectedOutput));
  });

  test("tryGetBytes() cannot convert malformed string to byte array", () {
    final List<int> actual = HexUtils.tryGetBytes("4e454g465457");
    expect(actual, equals(null));
  });

  test("getString() can convert bytes to string", () {
    final String actual =
        HexUtils.getString([0x4e, 0x45, 0x4d, 0x46, 0x54, 0x57]);
    final String expectedOutput = "4e454d465457";
    expect(actual, equals(expectedOutput));
  });

  test("getString() can convert bytes with leading zeros to string", () {
    final String actual =
        HexUtils.getString([0x00, 0x00, 0x0d, 0x46, 0x54, 0x57]);
    final String expectedOutput = "00000d465457";
    expect(actual, equals(expectedOutput));
  });
}
