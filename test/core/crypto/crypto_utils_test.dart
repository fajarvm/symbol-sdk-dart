library symbol_sdk_dart.test.crypto.crypto_utils_test;

import 'dart:typed_data' show Int64List, Uint8List;

import 'package:symbol_sdk_dart/core.dart'
    show ArrayUtils, ByteUtils, CryptoUtils, CatapultNacl, HexUtils, KeyPair;
import 'package:test/test.dart';

void main() {
  // ---------------------------
  // ---- Prep Scalar Mult -----
  // ---------------------------
  group('prepareScalarMult()', () {
    test('should return clamped value', () {
      final KeyPair keyPair = KeyPair.random();

      final Uint8List d = CryptoUtils.prepareForScalarMult(keyPair.privateKey);

      expect(d[31] & 0x40, equals(0x40));
      expect(d[31] & 0x80, equals(0x0));
      expect(d[0] & 0x7, equals(0x0));
    });

    test('should prepare for scalar mult', () {
      const input = ['227F', 'AAAA', 'BBADABA123'];

      const expected = [
        'f0579208310ff67d48adf7b23a10ff8d18197423d786281c637ffe88d1ba5d5a',
        '207d1de947c444ad18c08a4158b4e56b4a5c8efabac9278ca7591e9b2ade7969',
        '5046fc7086d31b6110b15e892902c7ef8abbe00b1407626fa5a73961d4e70f58'
      ];

      for (int i = 0; i < input.length; i++) {
        Uint8List secret = ByteUtils.hexToBytes(input[i]);
        Uint8List byte = CryptoUtils.prepareForScalarMult(secret);
        String actual = ByteUtils.bytesToHex(byte);

        expect(actual, equals(expected[i].toUpperCase()));
      }
    });
  });

  // ---------------------------
  // ---- Derive Shared Key ----
  // ---------------------------
  group('derived shared key', () {
    test('Catapult shared key hash test', () {
      var sharedSecret = HexUtils.utf8ToByte('string-or-buffer');
      var sharedKey = CryptoUtils.sha256ForSharedKey(sharedSecret);

      // Assert
      var actual = ByteUtils.bytesToHex(sharedKey);
      const expected = 'E618ACB2558E1721492E4AE3BED3F4D86F26C2B0CE6AD939943A6A540855D23F';
      expect(actual.toUpperCase(), equals(expected));
    });

    test('fails if public key has the wrong size', () {
      // Prepare: create a public key that is too long
      final KeyPair keyPair = KeyPair.random();
      final Uint8List publicKey = CryptoUtils.getRandomBytes(CryptoUtils.KEY_SIZE + 1);

      // Assert
      expect(
          () => CryptoUtils.deriveSharedKey(keyPair.privateKey, publicKey),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'Public key has unexpected size: ${publicKey.length}')));
    });

    test('derives same shared key for both partners', () {
      // Prepare:
      final KeyPair keyPair1 = KeyPair.random();
      final KeyPair keyPair2 = KeyPair.random();

      var sharedKey1 = CryptoUtils.deriveSharedKey(keyPair1.privateKey, keyPair2.publicKey);
      var sharedKey2 = CryptoUtils.deriveSharedKey(keyPair2.privateKey, keyPair1.publicKey);

      // Assert
      expect(ArrayUtils.deepEqual(sharedKey1, sharedKey2), isTrue);
    });

    test('derives different shared keys for different partners', () {
      // Prepare:
      final KeyPair keyPair = KeyPair.random();
      final Uint8List publicKey1 = KeyPair.randomPublicKey();
      final Uint8List publicKey2 = KeyPair.randomPublicKey();

      final Uint8List sharedKey1 = CryptoUtils.deriveSharedKey(keyPair.privateKey, publicKey1);
      final Uint8List sharedKey2 = CryptoUtils.deriveSharedKey(keyPair.privateKey, publicKey2);

      // Assert
      expect(ArrayUtils.deepEqual(sharedKey1, sharedKey2), isFalse);
    });

    group('Test Vectors Catapult', () {
      // @see https://github.com/nemtech/test-vectors/blob/master/3.test-derive.json

      test('derive shared key using SHA3', () {
        var Private_Key = [
          '00137C7C32881D1FFF2E905F5B7034BCBCDB806D232F351DB48A7816285C548F',
          'E8857F8E488D4E6D4B71BCD44BB4CFF49208C32651E1F6500C3B58CAFEB8DEF6',
          'D7F67B5F52CBCD1A1367E0376A8EB1012B634ACFCF35E8322BAE8B22BB9E8DEA',
          'D026DDB445FB3BBF3020E4B55ED7B5F9B7FD1278C34978CA1A6ED6B358DADBAE',
          'C522B38C391D1C3FA539CC58802BC66AC34BB3C73ACCD7F41B47F539BEDCD016',
        ];

        var Public_Keys = [
          'FDEE3C7A41F4717D18B5BFFD685C3C43DFFDC3F8E168AA1B237E1EBF8E9BC869',
          '0531061660549384490453BC61FB7AFDA69D49E961489A4847D8D5AF1749C65B',
          '9A6C6AA5C83019DFF2BC89F4D28D5163F72724F765AA450CB68F9EB6CBFBE20B',
          '4C29246B32541F0469028BDFE0E24A3322163CFB086A17537CA6C1A5858DE222',
          'DA64508E86229035B35D9363A2A3583B0E59D50A25472CED4320B149166F91B0',
        ];

        var Expected_ScalarMulResult = [
          'EAFB74D6778DCF4A55B1758432A13767719FD8AD66A32FF2E3256CEFA4DD7334',
          '03351F60B934BC9635D397A76CA47C25A4B3B78925785931A04F30460F102CE6',
          'C1EFCCDF3DC7E0A898B18D7C13D4433E59F6D5D404B6BB714942822250C0778C',
          '750AA2E689A89D9A25D0C1F4F41BF470CF598126BD958FAB2245DBEB84B5E65F',
          '7247B4916097994EF458A899F7163718A55A4D6CF2C26BA2EFD37A9791DB9EB4',
        ];

        var Expected_Derived_Key = [
          '59BE24D6DB8381DA153CB653134EF7352FA9FDDFD2A9B3727924F7761390C6C1',
          '52C7F2DCD494A14ED50720BAE0CE6792D9E22D450CF492682801294ECAF35932',
          'C8B57A0B117548273422A55801A963F86A4404AE23F3E4986EF655F40927691F',
          '3E8A0DAB3B19B68C176FC349BFE6476A33CCDE7A09292040D98F88DE222495A9',
          'A3B157EFB3B5163CDF24841F11ECB55DEC18567345D0FCB46B072C2399CD364A',
        ];

        for (int i = 0; i < Private_Key.length; i++) {
          // Arrange:
          Uint8List privateKey = HexUtils.getBytes(Private_Key[i]);
          Uint8List publicKey = HexUtils.getBytes(Public_Keys[i]);

          // Act:
          String sharedKey =
              ByteUtils.bytesToHex(CryptoUtils.deriveSharedKey(privateKey, publicKey));
          String sharedSecret =
              ByteUtils.bytesToHex(CryptoUtils.deriveSharedSecret(privateKey, publicKey));

          // Assert:
          expect(sharedSecret.toUpperCase(), equals(Expected_ScalarMulResult[i]));
          expect(sharedKey.toUpperCase(), equals(Expected_Derived_Key[i]));
        }
      });
    });
  });
}

Int64List gf([final Int64List init]) {
  return CatapultNacl.gf(init);
}
