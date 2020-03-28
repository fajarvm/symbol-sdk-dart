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

library symbol_sdk_dart.test.sdk.model.account.account_info_test;

import 'package:symbol_sdk_dart/sdk.dart'
    show
        AccountInfo,
        AccountType,
        ActivityBucket,
        Address,
        Mosaic,
        MosaicId,
        NetworkType,
        PublicAccount,
        Uint64;
import 'package:test/test.dart';

void main() {
  group('AccountInfo', () {
    test('Can create an AccountInfo object', () {
      // Prepare
      const encodedAddress = '9050B9837EFAB4BBE8A4B9BB32D812F9885C00D8FC1650E142';
      final address = Address.fromEncoded(encodedAddress);
      final addressHeight = Uint64(1, 0);
      final importance = Uint64(405653170, 0);
      final importanceHeight = Uint64(6462, 0);
      final accountType = AccountType.MAIN;
      const linkedAccountKey = encodedAddress;
      final activityBucket = [ActivityBucket('1000', 100, 1, 20)];
      const publicKey = '846B4439154579A5903B1459C9CF69CB8153F6D0110A7A0ED61DE29AE4810BF2';
      final publicKeyHeight = Uint64(13, 0);

      final XEM_ID = Uint64(3646934825, 3576016193);
      final amount = Uint64(1830592442, 94387);
      final mosaics = <Mosaic>[Mosaic(MosaicId.fromId(XEM_ID), amount)];

      // Create
      final accountInfo = new AccountInfo(address, addressHeight, publicKey, publicKeyHeight,
          accountType, linkedAccountKey, activityBucket, mosaics, importance, importanceHeight);

      // Assert
      expect(accountInfo.address.plain, equals('SBILTA367K2LX2FEXG5TFWAS7GEFYAGY7QLFBYKC'));
      expect(accountInfo.addressHeight.value.toInt(), 1);
      expect(accountInfo.publicKey, equals(publicKey));
      expect(accountInfo.publicKeyHeight.value.toInt(), 13);
      expect(accountInfo.accountType, AccountType.MAIN);
      expect(accountInfo.linkedAccountKey, equals(linkedAccountKey));
      expect(accountInfo.importance.value.toInt(), 405653170);
      expect(accountInfo.importanceHeight.value.toInt(), 6462);
      final PublicAccount expected = PublicAccount.fromPublicKey(publicKey, NetworkType.MIJIN_TEST);
      expect(accountInfo.publicAccount, equals(expected));
      expect(accountInfo.activityBucket, equals(activityBucket));
      expect(accountInfo.mosaics, equals(mosaics));

      // toString()
      final toString = 'AccountInfo{'
          'address: $address, '
          'addressHeight: $addressHeight, '
          'publicKey: $publicKey, '
          'publicKeyHeight: $publicKeyHeight, '
          'accountType: $accountType, '
          'linkedAccountKey: $linkedAccountKey, '
          'activityBucket: $activityBucket, '
          'mosaics: $mosaics, '
          'importance: $importance, '
          'importanceHeight: $importanceHeight'
          '}';
      expect(accountInfo.toString(), equals(toString));
    });
  });
}
