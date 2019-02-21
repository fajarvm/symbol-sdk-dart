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

library nem2_sdk_dart.test.sdk.model.account.account_info_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show Uint64;
import 'package:nem2_sdk_dart/sdk.dart'
    show AccountInfo, Address, Mosaic, MosaicId, NetworkType, PublicAccount;

main() {
  group('AccountInfo', () {
    test('Can create an AccountInfo', () {
      // Prepare
      final String encodedAddress = '9050B9837EFAB4BBE8A4B9BB32D812F9885C00D8FC1650E142';
      final String publicKey = '846B4439154579A5903B1459C9CF69CB8153F6D0110A7A0ED61DE29AE4810BF2';
      final Address address = Address.fromEncoded(encodedAddress);
      final Uint64 addressHeight = Uint64(12345);
      final Uint64 importance = Uint64(9000);
      final Uint64 importanceHeight = Uint64(50);
      final Uint64 publicKeyHeight = Uint64(100);

      final Uint64 XEM_ID = Uint64.fromHex('D525AD41D95FCF29');
      final List<Mosaic> mosaics = [new Mosaic(MosaicId.fromId(XEM_ID), Uint64(987654321))];

      // Create
      final AccountInfo accountInfo = new AccountInfo(address, addressHeight, publicKey,
          publicKeyHeight, importance, importanceHeight, mosaics);

      // Assert
      expect(accountInfo.address.plain, equals('SBILTA367K2LX2FEXG5TFWAS7GEFYAGY7QLFBYKC'));
      expect(accountInfo.addressHeight.value.toInt(), 12345);
      expect(accountInfo.publicKey, equals(publicKey));
      expect(accountInfo.publicKeyHeight.value.toInt(), 100);
      expect(accountInfo.importance.value.toInt(), 9000);
      expect(accountInfo.importanceHeight.value.toInt(), 50);
      final PublicAccount expected = PublicAccount.fromPublicKey(publicKey, NetworkType.MIJIN_TEST);
      expect(accountInfo.publicAccount, equals(expected));
    });
  });
}
