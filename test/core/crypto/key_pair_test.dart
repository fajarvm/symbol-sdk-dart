library nem2_sdk_dart.test.core.crypto.key_pair_test;

import "package:test/test.dart";

import "package:nem2_sdk_dart/src/core/crypto.dart" show KeyPair;
import "package:nem2_sdk_dart/src/core/utils.dart" show HexUtils;

import 'dart:convert' show utf8;
import 'package:convert/convert.dart' show hex;
import 'package:nem2_sdk_dart/src/core/crypto/tweetnacl.dart' as TweetNacl;
import 'dart:typed_data' show Uint8List;

main() {
  group('construction', () {
    test('can extract from private key test vectors', () {
//      final String privateKey = "A4FFE914472C9CA8CA13F2D7ABEA187C981E7678FDBFA8E2A372D4FA08903CAB";
      final String privateKey = "787225aaff3d2c71f4ffa32d4f19ec4922f3cd869747f267378f81f8e3fcb12d";
//      final KeyPair keyPair = KeyPair.createFromPrivateKeyString(privateKey);

      Uint8List seed = HexUtils.getBytes(privateKey);
//      Uint8List seed = hex.decode(privateKey);
//      final TweetNacl.NaclKeyPair kp = TweetNacl.Signature.keyPair_fromSeed(seed);

      Uint8List pk = new Uint8List(32);
      TweetNacl.TweetNaclFast.crypto_sign_keypair(pk, seed, true);

      // TODO: Test failing. Fix needed
//      final String expected = "65730A6AF4E5728A3E9233A26D83057A5470F11517E50EC0932B3D3434F12EEF";
      final String expected = "1026D70E1954775749C6811084D6450A3184D977383F0E4282CD47118AF37755";
      final String actual = HexUtils.getString(pk);
      // Address: (S/M/N/T C7FLL-6X3XTN-ARV35L-2A3OL4-JSTXIH-OTWLBB-FXUM
      expect(actual, equals(expected));
    });
  });
}
