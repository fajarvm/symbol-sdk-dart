//
// Copyright (c) 2020 Fajar van Megen
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

library symbol_sdk_dart.test.sdk.model.account.public_account_test;

import 'package:symbol_sdk_dart/sdk.dart' show Address, NetworkType, PublicAccount;
import 'package:test/test.dart';

void main() {
  group('PublicAccount', () {
    const publicKey = 'b4f12e7c9f6946091e2cb8b6d3a12b50d17ccbbf646386ea27ce2946a7423dcf';

    test('can create using constructor', () {
      final address = Address.fromPublicKey(publicKey, NetworkType.MIJIN_TEST);
      final publicAccount = new PublicAccount(address: address, publicKey: publicKey);

      expect(publicAccount.address, equals(address));
      expect(publicAccount.plainAddress, equals('SARNASAS2BIAB6LMFA3FPMGBPGIJGK6IJETM3ZSP'));
      expect(publicAccount.hashCode, isNotNull);

      expect(publicAccount.toString(),
          equals('PublicAccount{address= ${publicAccount.plainAddress}, publicKey= $publicKey}'));
    });

    test('can create a public account from a public key', () {
      final publicAccount = PublicAccount.fromPublicKey(publicKey, NetworkType.MIJIN_TEST);

      expect(publicAccount.publicKey, equals(publicKey));
      expect(publicAccount.plainAddress, equals('SARNASAS2BIAB6LMFA3FPMGBPGIJGK6IJETM3ZSP'));
    });

    test('cannot create using invalid parameters', () {
      expect(() => PublicAccount.fromPublicKey(null, NetworkType.MIJIN_TEST),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'Must not be null')));
      expect(
          () => PublicAccount.fromPublicKey(
              'b4f12e7c9f6946091e2cb8b6d3a12b50d17ccbbf646386ea27ce2946a7423dc',
              NetworkType.MIJIN_TEST),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'Not a valid public key')));
      expect(
          () => PublicAccount.fromPublicKey(
              'b4f12e7c9f6946091e2cb8b6d3a12b50d17ccbbf646386ea27ce2946a7423dcff',
              NetworkType.MIJIN_TEST),
          throwsA(predicate((e) => e is ArgumentError && e.message == 'Not a valid public key')));
    });
  });

  group('Signature verifiication', () {
    test('can verify a signature', () {
      final publicAccount = PublicAccount.fromPublicKey(
          '16FB59F907524009730BCB9F860C8C5A1109A9E8F194275DA0B9F5A2085E2D02',
          NetworkType.MIJIN_TEST);
      const data = 'ff60983e0c5d21d2fb83c67598d560f3cf0e28ae667b5616aaa58a059666cd8cf826b026243c92cf';
      const signature =
          '2E32A8A934C2B8BC54A1594643A866CCDB3166BD41B6DE3E0C9FC779E7F3F421A0BCC798408ACCC92F47A3A45EF237D5CB7473D768991EE79AC659E1DA8CBB0C';

      expect(publicAccount.verifySignature(data, signature), isTrue);
    });

    test('throw error if signature is null', () {
      final publicAccount = PublicAccount.fromPublicKey(
          '22816F825B4CACEA334723D51297D8582332D8B875A5829908AAE85831ABB508',
          NetworkType.MIJIN_TEST);

      assertSignatureVerificationError(
          publicAccount, 'some data', null, 'Missing signature argument');
    });

    test('throw error if signature has an invalid length', () {
      final publicAccount = PublicAccount.fromPublicKey(
          '22816F825B4CACEA334723D51297D8582332D8B875A5829908AAE85831ABB508',
          NetworkType.MIJIN_TEST);
      const data = 'I am so so so awesome as always';
      const signature =
          'B01DCA6484026C2ECDF3C822E64DEAAFC15EBCCE337EEE209C28513CB5351CDED8863A8E7B855CD471B55C91FAE611C5486';

      assertSignatureVerificationError(
          publicAccount, data, signature, 'Signature length is incorrect');
    });

    test('throw error if signature is not a valid hexadecimal', () {
      final publicAccount = PublicAccount.fromPublicKey(
          '22816F825B4CACEA334723D51297D8582332D8B875A5829908AAE85831ABB508',
          NetworkType.MIJIN_TEST);
      const data = 'I am so so so awesome as always';
      const signature =
          'B01DCA6484026C2ECDF3C822E64DEAAFC15EBCCE337EEE209C28513CB5351CDED8863A8E7B855CD471B55C91FAE611C548625C9A5916A555A24F72F35a1wwwww';

      assertSignatureVerificationError(
          publicAccount, data, signature, 'Signature must be hexadecimal');
    });

    test('returns false when incorrect public key is provided', () {
      final publicAccount = PublicAccount.fromPublicKey(
          '12816F825B4CACEA334723D51297D8582332D8B875A5829908AAE85831ABB509',
          NetworkType.MIJIN_TEST);
      const data = 'I am so so so awesome as always';
      const signature =
          'B01DCA6484026C2ECDF3C822E64DEAAFC15EBCCE337EEE209C28513CB5351CDED8863A8E7B855CD471B55C91FAE611C548625C9A5916A555A24F72F3526FA508';

      expect(publicAccount.verifySignature(data, signature), isFalse);
    });

    test('returns false when data does not correspond with the provided signature', () {
      final publicAccount = PublicAccount.fromPublicKey(
          '22816F825B4CACEA334723D51297D8582332D8B875A5829908AAE85831ABB508',
          NetworkType.MIJIN_TEST);
      const data = 'I am awesome as always';
      const signature =
          'B01DCA6484026C2ECDF3C822E64DEAAFC15EBCCE337EEE209C28513CB5351CDED8863A8E7B855CD471B55C91FAE611C548625C9A5916A555A24F72F3526FA508';

      expect(publicAccount.verifySignature(data, signature), isFalse);
    });

    test('returns false when signature does not correspond with the provided data', () {
      final publicAccount = PublicAccount.fromPublicKey(
          '22816F825B4CACEA334723D51297D8582332D8B875A5829908AAE85831ABB508',
          NetworkType.MIJIN_TEST);
      const data = 'I am so so so awesome as always';
      const signature =
          'A01DCA6484026C2ECDF3C822E64DEAAFC15EBCCE337EEE209C28513CB5351CDED8863A8E7B855CD471B55C91FAE611C548625C9A5916A555A24F72F3526FA509';

      expect(publicAccount.verifySignature(data, signature), isFalse);
    });
  });
}

void assertSignatureVerificationError(final PublicAccount publicAccount, final String data,
    final String signature, final String message) {
  expect(() => publicAccount.verifySignature(data, signature),
      throwsA(predicate((e) => e is ArgumentError && e.message == message)));
}
