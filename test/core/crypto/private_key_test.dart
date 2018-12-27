library nem2_sdk_dart.test.core.utils.private_key_test;

import "package:test/test.dart";
import "package:nem2_sdk_dart/src/core/crypto.dart";
import "package:pointycastle/src/utils.dart";

void main() {
  testCreatePrivateKey();
  testEquals();
  testHashCode();
  testToString();
}

// --------------------------------------------------- test cases --------------------------------------------------- //

void testCreatePrivateKey() {
  test("create private key from BigInt", () {
    final BigInt expectedOutput = BigInt.parse("2275");
    final PrivateKey key = new PrivateKey(expectedOutput);
    expect(key.getBytes(), equals([8, 227]));
    expect(key.getRaw(), equals(expectedOutput));
    expect(key.getRaw().isNegative, false);
  });

  test("create private key from a decimal string", () {
    final PrivateKey key = PrivateKey.fromDecimalString("2279");
    expect(key.getBytes(), equals([8, 231]));
    expect(key.getRaw(), equals(BigInt.parse("2279")));
    expect(key.getRaw().isNegative, false);
  });

  test("create private key from a negative decimal string", () {
    final PrivateKey key = PrivateKey.fromDecimalString("-2279");
    expect(key.getBytes(), equals([247, 25]));
    expect(key.getRaw(), equals(BigInt.parse("-2279")));
    expect(key.getRaw().isNegative, true);
  });

  test("create private key from a hex string", () {
    final PrivateKey key = PrivateKey.fromHexString("227F");
    expect(key.getBytes(), equals([0x22, 0x7F]));
    expect(key.getRaw(), equals(BigInt.tryParse("227F", radix: 16)));
    expect(key.getRaw().isNegative, false);
  });

  test("create private key from a hex string with odd length", () {
    final PrivateKey key = PrivateKey.fromHexString("ABC");
    expect(key.getBytes(), equals([0x0A, 0xBC]));
    expect(key.getRaw(), equals(decodeBigInt([0x0A, 0xBC])));
    expect(key.getRaw().isNegative, false);
  });

  // TODO: this test case needs to be completed. See TODO message below.
  test("create private key from a a negative hex string", () {
    final PrivateKey key = PrivateKey.fromHexString("8000");
    expect(key.getBytes(), equals([0x80, 0x00]));
    expect(key.getRaw(), equals(decodeBigInt([0x80, 0x00])));
    // TODO: check the negative sign.
    // expect(key.getRaw().isNegative, true); // it currently fails
    // Currently, the encode/decodeBigInt() util methods from PointyCastle doesn't support negative numbers.
    });

  test("cannot create private key from a malformed decimal string", () {
    expect(()=>PrivateKey.fromDecimalString("22A75"), throwsA(TypeMatcher<CryptoException>()));
  });

  test("cannot create private key from a malformed hex string", () {
    expect(()=>PrivateKey.fromHexString("22G75"), throwsA(TypeMatcher<CryptoException>()));
  });
}

void testEquals() {
  final BigInt bigInt = BigInt.parse("2275");
  final PrivateKey key = new PrivateKey(bigInt);

  test("equals only returns true for equivalent objects", (){
    expect(PrivateKey.fromDecimalString("2275"), equals(key));
    expect(PrivateKey.fromDecimalString("2276"), isNot(equals(key)));
    expect(PrivateKey.fromHexString("2276"), isNot(equals(key)));
    expect(null, isNot(equals(key)));
    expect(BigInt.parse("1235"), isNot(equals(key)));
  });
}

void testHashCode() {
  final BigInt bigInt = BigInt.parse("2275");
  final PrivateKey key = new PrivateKey(bigInt);
  final int hashCode = key.hashCode;
  test("hash codes are equal for equivalent objects", (){
    expect(PrivateKey.fromDecimalString("2275").hashCode, equals(hashCode));
    expect(PrivateKey.fromDecimalString("2276").hashCode, isNot(equals(hashCode)));
    expect(PrivateKey.fromHexString("2276").hashCode, isNot(equals(hashCode)));
  });
}

void testToString() {
  test("toString() returns hex representation", (){
    expect(PrivateKey.fromHexString("2275").toString(), equals("2275"));
    expect(PrivateKey.fromDecimalString("2275").toString(), equals("08e3"));
  });
}
