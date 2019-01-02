library nem2_sdk_dart.test.core.crypto.public_key_test;

import "dart:typed_data" show Uint8List;

import "package:test/test.dart";
import "package:nem2_sdk_dart/src/core/crypto.dart";

final Uint8List TEST_BYTES = Uint8List.fromList([0x22, 0xAB, 0x71]);
final Uint8List MODIFIED_TEST_BYTES = Uint8List.fromList([0x22, 0xAB, 0x72]);

void main() {
  testCreatePublicKey();
  testEquals();
  testHashCode();
  testToString();
}

void testCreatePublicKey() {
  test("create public key from bytes", () {
    final PublicKey key = new PublicKey(TEST_BYTES);
    expect(key.getRaw(), equals(TEST_BYTES));
  });

  test("create public key from hex string", () {
    final PublicKey key = PublicKey.fromHexString("227F");
    expect(key.getRaw(), equals(Uint8List.fromList([0x22, 0x7F])));
  });

  test("cannot create public key from malformed hex string", () {
    expect(() => PublicKey.fromHexString("22G75"),
        throwsA(TypeMatcher<CryptoException>()));
  });
}

void testEquals() {
  final PublicKey key = new PublicKey(TEST_BYTES);

  test("equals only returns true for equivalent objects", () {
    expect(new PublicKey(TEST_BYTES), equals(key));
    expect(new PublicKey(MODIFIED_TEST_BYTES), isNot(equals(key)));
    expect(null, isNot(equals(key)));
    expect(TEST_BYTES, isNot(equals(key)));
  });
}

void testHashCode() {
  final PublicKey key = new PublicKey(TEST_BYTES);
  final int hashCode = key.hashCode;

  test("hash codes are equal for equivalent objects", () {
    expect(new PublicKey(TEST_BYTES).hashCode, equals(hashCode));
    expect(
        new PublicKey(MODIFIED_TEST_BYTES).hashCode, isNot(equals(hashCode)));
  });
}

void testToString() {
  test("toString() returns hex representation", () {
    expect(PublicKey(TEST_BYTES).toString(), equals("22ab71"));
  });
}
