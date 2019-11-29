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

library nem2_sdk_dart.test.sdk.model.account.address_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/core.dart' show RawAddress;
import 'package:nem2_sdk_dart/sdk.dart' show Account, Address, NetworkType;

void main() {
  group('sanity test', () {
    test('valid constants', () {
      expect(Address.PREFIX_MIJIN_TEST, equals('S'));
      expect(Address.PREFIX_MIJIN, equals('M'));
      expect(Address.PREFIX_TEST_NET, equals('T'));
      expect(Address.PREFIX_MAIN_NET, equals('N'));
      expect(Address.EMPTY_STRING, equals(''));

      expect(Address.REGEX_DASH.hasMatch('-'), isTrue);
      expect(Address.REGEX_PRETTY.hasMatch('ABCFDG-HIJKLMN'), isTrue);
    });

    test('can compare two addresses', () {
      const publicKey = 'b4f12e7c9f6946091e2cb8b6d3a12b50d17ccbbf646386ea27ce2946a7423dcf';
      final address1 = Address.fromPublicKey(publicKey, NetworkType.MIJIN_TEST);
      final address2 = Address.fromPublicKey(publicKey, NetworkType.MIJIN_TEST);

      expect(address1.hashCode, isNotNull);
      expect(address2.hashCode, isNotNull);
      expect(address1 == address2, isTrue);
      expect(address1.toString(),
          equals('Address{address= ${address1.plain}, networkType= ${address1.networkType}}'));
    });
  });

  group('fromPublicKey', () {
    test('can create from public key for the designated network type', () {
      const publicKey = 'c2f93346e27ce6ad1a9f8f5e3066f8326593a406bdf357acb041e2f9ab402efe';
      final address1 = Address.fromPublicKey(publicKey, NetworkType.MIJIN);
      expect(address1.plain, equals('MCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPR72DYSX'));
      expect(address1.pretty, equals('MCTVW2-3D2MN5-VE4AQ4-TZIDZE-NGNOZX-PRPR72-DYSX'));
      expect(address1.networkType, equals(NetworkType.MIJIN));
      expect(address1.hashCode, isNotNull);

      final address2 = Address.fromPublicKey(publicKey, NetworkType.MIJIN_TEST);
      expect(address2.plain, equals('SCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPRLIKCF2'));
      expect(address2.pretty, equals('SCTVW2-3D2MN5-VE4AQ4-TZIDZE-NGNOZX-PRPRLI-KCF2'));
      expect(address2.networkType, equals(NetworkType.MIJIN_TEST));
      expect(address2.hashCode, isNotNull);

      // Different sign schema
      final address3 = Address.fromPublicKey(publicKey, NetworkType.MAIN_NET);
      expect(address3.plain == 'NDD2CT6LQLIYQ56KIXI3ENTM6EK3D44P5JFXJ4R4', isFalse);
      expect(address3.networkType, equals(NetworkType.MAIN_NET));
      expect(address3.hashCode, isNotNull);

      final address4 = Address.fromPublicKey(publicKey, NetworkType.TEST_NET);
      expect(address4.plain == 'TDD2CT6LQLIYQ56KIXI3ENTM6EK3D44P5KZPFMK2', isFalse);
      expect(address4.networkType, equals(NetworkType.TEST_NET));
      expect(address4.hashCode, isNotNull);
    });

    test('can create from public key using NIS1 Schema', () {
      const NIS_PublicKey = 'c5f54ba980fcbb657dbaaa42700539b207873e134d2375efeab5f1ab52f87844';

      final address1 = Address.fromPublicKey(NIS_PublicKey, NetworkType.MAIN_NET);
      expect(address1.plain, equals('NDD2CT6LQLIYQ56KIXI3ENTM6EK3D44P5JFXJ4R4'));
      expect(address1.pretty, equals('NDD2CT-6LQLIY-Q56KIX-I3ENTM-6EK3D4-4P5JFX-J4R4'));
      expect(address1.networkType, equals(NetworkType.MAIN_NET));
      expect(address1.hashCode, isNotNull);

      final address2 = Address.fromPublicKey(NIS_PublicKey, NetworkType.TEST_NET);
      expect(address2.plain, equals('TDD2CT6LQLIYQ56KIXI3ENTM6EK3D44P5KZPFMK2'));
      expect(address2.pretty, equals('TDD2CT-6LQLIY-Q56KIX-I3ENTM-6EK3D4-4P5KZP-FMK2'));
      expect(address2.networkType, equals(NetworkType.TEST_NET));
      expect(address2.hashCode, isNotNull);
    });

    test('cannot create for an invalid network type', () {
      String errorMessage = NetworkType.UNKNOWN_NETWORK_TYPE;
      expect(errorMessage, 'network type is unknown');
      expect(() => Address.fromPublicKey(null, new MockNetworkType(-1)),
          throwsA(predicate((e) => e is ArgumentError && e.message == errorMessage)));
    });
  });

  group('fromRawAddress', () {
    test('can create from raw address and also determines its network type', () {
      final address1 = Address.fromRawAddress('MCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPR72DYSX');
      expect(address1.plain, equals('MCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPR72DYSX'));
      expect(address1.networkType, equals(NetworkType.MIJIN));

      final address2 = Address.fromRawAddress('SCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPRLIKCF2');
      expect(address2.plain, equals('SCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPRLIKCF2'));
      expect(address2.networkType, equals(NetworkType.MIJIN_TEST));

      final address3 = Address.fromRawAddress('NCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPQUJ2ZML');
      expect(address3.plain, equals('NCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPQUJ2ZML'));
      expect(address3.networkType, equals(NetworkType.MAIN_NET));

      final address4 = Address.fromRawAddress('TCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPSDRSFRF');
      expect(address4.plain, equals('TCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPSDRSFRF'));
      expect(address4.networkType, equals(NetworkType.TEST_NET));
    });

    test('cannot create from an invalid raw address', () {
      const address = 'TCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPSDRSFRFT';
      expect(
          () => Address.fromRawAddress(address),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message ==
                  'Address $address has to be ${RawAddress.ADDRESS_ENCODED_SIZE} characters long')));
      expect(
          () => Address.fromRawAddress('ZCTVW23D2MN5VE4AQ4TZIDZENGNOZXPRPSDRSFRF'),
          throwsA(predicate(
              (e) => e is UnsupportedError && e.message == 'unknown address network type')));
    });
  });

  group('fromEncoded', () {
    test('can create from encoded address string', () {
      const encodedString = '9050B9837EFAB4BBE8A4B9BB32D812F9885C00D8FC1650E142';
      final address = Address.fromEncoded(encodedString);

      expect(address.plain, equals('SBILTA367K2LX2FEXG5TFWAS7GEFYAGY7QLFBYKC'));
    });
  });

  group('prettify', () {
    test('can convert an address into a pretty format address', () {
      const expected = 'NAR3W7B4BCOZSZMFIZRYB3N5YGOUSWIYJCJ6HDFG';

      expect(Address.prettify(expected), equals('NAR3W7-B4BCOZ-SZMFIZ-RYB3N5-YGOUSW-IYJCJ6-HDFG'));
    });

    test('cannot convert from an invalid address', () {
      const address = 'NOT-A-VALID-ADDRESS';
      expect(
          () => Address.prettify(address),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message ==
                  'Address $address has to be ${RawAddress.ADDRESS_ENCODED_SIZE} characters long')));
    });
  });

  group('isValidRawAddress', () {
    test('returns true for valid address when generated', () {
      expect(
          Address.isValidRawAddress(
              Account.generate(NetworkType.MIJIN_TEST).plainAddress, NetworkType.MIJIN_TEST),
          isTrue);
      expect(
          Address.isValidRawAddress(
              Account.generate(NetworkType.MAIN_NET).plainAddress, NetworkType.MAIN_NET),
          isTrue);
      expect(
          Address.isValidRawAddress(
              Account.generate(NetworkType.MIJIN).plainAddress, NetworkType.MIJIN),
          isTrue);
      expect(
          Address.isValidRawAddress(
              Account.generate(NetworkType.TEST_NET).plainAddress, NetworkType.TEST_NET),
          isTrue);
    });

    test('returns true for a valid address', () {
      const rawAddress = 'SCHCZBZ6QVJAHGJTKYVPW5FBSO2IXXJQBPV5XE6P';

      expect(Address.isValidRawAddress(rawAddress, NetworkType.MIJIN_TEST), isTrue);
    });

    test('returns false for an address with invalid checksum', () {
      const rawAddress = 'SCHCZBZ6QVJAHGJTKYAPW5FBSO2IXXJQBPV5XE6P';

      expect(Address.isValidRawAddress(rawAddress, NetworkType.MIJIN_TEST), isFalse);
    });

    test('returns false for an address with invalid hash', () {
      const rawAddress = 'SCHCZBZ6QVJAHGJTKYVPW5FBSO2IXXJQBPV5XE7P';

      expect(Address.isValidRawAddress(rawAddress, NetworkType.MIJIN_TEST), isFalse);
    });

    test('returns false for an address with invalid prefix', () {
      const rawAddress = 'ACHCZBZ6QVJAHGJTKYVPW5FBSO2IXXJQBPV5XE6P';

      expect(Address.isValidRawAddress(rawAddress, NetworkType.MIJIN_TEST), isFalse);
    });
  });

  group('isValidEncodedAddress', () {
    test('returns true for valid address when generated', () {
      expect(
          Address.isValidEncodedAddress(
              Account.generate(NetworkType.MIJIN_TEST).encodedAddress, NetworkType.MIJIN_TEST),
          isTrue);
      expect(
          Address.isValidEncodedAddress(
              Account.generate(NetworkType.MAIN_NET).encodedAddress, NetworkType.MAIN_NET),
          isTrue);
      expect(
          Address.isValidEncodedAddress(
              Account.generate(NetworkType.MIJIN).encodedAddress, NetworkType.MIJIN),
          isTrue);
      expect(
          Address.isValidEncodedAddress(
              Account.generate(NetworkType.TEST_NET).encodedAddress, NetworkType.TEST_NET),
          isTrue);
    });

    test('returns true for valid encoded address', () {
      const encoded = '9085215E4620D383C2DF70235B9EF7507F6A28EF6D16FD7B9C';

      expect(Address.isValidEncodedAddress(encoded, NetworkType.MIJIN_TEST), isTrue);
    });

    test('returns false for invalid hex encoded address', () {
      const encoded = 'Z085215E4620D383C2DF70235B9EF7507F6A28EF6D16FD7B9C';

      expect(Address.isValidEncodedAddress(encoded, NetworkType.MIJIN_TEST), isFalse);
    });

    test('returns false for invalid encoded address', () {
      const encoded = '9085215E4620D383C2DF70235B9EF7507F6A28EF6D16FD7B9D';

      expect(Address.isValidEncodedAddress(encoded, NetworkType.MIJIN_TEST), isFalse);
    });

    test('returns false for an encoded address with invalid length', () {
      const encoded = '9085215E4620D383C2DF70235B9EF7607F6A28EF6D16FD7B9C';

      expect(Address.isValidEncodedAddress(encoded, NetworkType.MIJIN_TEST), isFalse);
    });

    test('white spaces invalidates the encoded address', () {
      const encoded = '9085215E4620D383C2DF70235B9EF7507F6A28EF6D16FD7B9C';

      expect(Address.isValidEncodedAddress('  \t   $encoded', NetworkType.MIJIN_TEST), isFalse);
      expect(Address.isValidEncodedAddress('$encoded   \t   ', NetworkType.MIJIN_TEST), isFalse);
      expect(Address.isValidEncodedAddress('   \t   $encoded   \t   ', NetworkType.MIJIN_TEST),
          isFalse);
    });
  });
}

class MockNetworkType implements NetworkType {
  final int _value;

  MockNetworkType(this._value);

  @override
  int get value => this._value;
}
