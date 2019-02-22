//
// Copyright (c) 2019 Fajar van Megen
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

library nem2_sdk_dart.test.sdk.model.account.public_account_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show NetworkType, PublicAccount;

void main() {
  group('PublicAccount', () {
    const publicKey = 'b4f12e7c9f6946091e2cb8b6d3a12b50d17ccbbf646386ea27ce2946a7423dcf';

    test('can create a public account from a public key', () {
      final publicAccount = PublicAccount.fromPublicKey(publicKey, NetworkType.MIJIN_TEST);

      expect(publicAccount.publicKey, equals(publicKey));
      expect(publicAccount.plainAddress, equals('SARNASAS2BIAB6LMFA3FPMGBPGIJGK6IJETM3ZSP'));
    });
  });

  group('Signature verifiication', () {
    test('can verify a signature', () {
      final publicAccount = PublicAccount.fromPublicKey(
          '1464953393CE96A08ABA6184601FD08864E910696B060FF7064474726E666CA8',
          NetworkType.MIJIN_TEST);
      const data = 'I am so so so awesome as always';
      const signature =
          '2092660F5BD4AE832B2E290F34A76B41506EE473B02FD7FD468B32C80C945CF60A0D60D005FA9B2DB3AD3212F8028C1449D3DCF81C9FAB3EB4975A7409D8D802';

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
