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

library nem2_sdk_dart.test.sdk.model.transaction.id_generator_test;

import 'dart:typed_data' show Uint8List;

import 'package:test/test.dart';

import 'package:fixnum/fixnum.dart' show Int64;

import 'package:nem2_sdk_dart/core.dart' show CryptoException, HexUtils;
import 'package:nem2_sdk_dart/sdk.dart' show IdGenerator, Uint64;

void main() {
  final NEM_ID = Uint64.fromHex('84B3552D375FFA4B'); // 9562080086528621131
  final XEM_ID = Uint64.fromHex('D525AD41D95FCF29'); // 15358872602548358953

  final TEST_MOSAICS = [
    {
      'publicKey': '4AFF7B4BA8C1C26A7917575993346627CB6C80DE62CD92F7F9AEDB7064A3DE62',
      'nonce': 'B76FE378',
      'expectedMosaicId': '3AD842A8C0AFC518'
    },
    {
      'publicKey': '3811EDF245F1D30171FF1474B24C4366FECA365A8457AAFA084F3DE4AEA0BA60',
      'nonce': '21832A2A',
      'expectedMosaicId': '24C54740A9F3893F'
    },
    {
      'publicKey': '3104D468D20491EC12C988C50CAD9282256052907415359201C46CBD7A0BCD75',
      'nonce': '2ADBB332',
      'expectedMosaicId': '43908F2DEEA04245'
    },
    {
      'publicKey': '6648E16513F351E9907B0EA34377E25F579BE640D4698B28E06585A21E94CFE2',
      'nonce': 'B9175E0F',
      'expectedMosaicId': '183172772BD29E78'
    },
    {
      'publicKey': '1C05C40D38463FE725CF0584A3A69E3B0D6B780196A88C50624E49B921EE1404',
      'nonce': 'F6077DDD',
      'expectedMosaicId': '423DB0B12F787422'
    },
    {
      'publicKey': '37926B3509987093C776C8EA3E7F978E3A78142B5C96B9434C3376177DC65EFD',
      'nonce': '08190C6D',
      'expectedMosaicId': '1F07D26B6CD352D5'
    },
    {
      'publicKey': 'FDC6B0D415D90536263431F05C46AC492D0BD9B3CFA1B79D5A35E0F371655C0C',
      'nonce': '81662AA5',
      'expectedMosaicId': '74511F54940729CB'
    },
    {
      'publicKey': '2D4EA99965477AEB3BC162C09C24C8DA4DABE408956C2F69642554EA48AAE1B2',
      'nonce': 'EA16BF58',
      'expectedMosaicId': '4C55843B6EB4A5BD'
    },
    {
      'publicKey': '68EB2F91E74D005A7C22D6132926AEF9BFD90A3ACA3C7F989E579A93EFF24D51',
      'nonce': 'E5F87A8B',
      'expectedMosaicId': '4D89DE2B6967666A'
    },
    {
      'publicKey': '3B082C0074F65D1E205643CDE72C6B0A3D0579C7ACC4D6A7E23A6EC46363B90F',
      'nonce': '1E6BB49F',
      'expectedMosaicId': '0A96B3A44615B62F'
    },
    {
      'publicKey': '81245CA233B729FAD1752662EADFD73C5033E3B918CE854E01F6EB51E98CD9F1',
      'nonce': 'B82965E3',
      'expectedMosaicId': '1D6D8E655A77C4E6'
    },
    {
      'publicKey': 'D3A2C1BFD5D48239001174BFF62A83A52BC9A535B8CDBDF289203146661D8AC4',
      'nonce': 'F37FB460',
      'expectedMosaicId': '268A3CC23ADCDA2D'
    },
    {
      'publicKey': '4C4CA89B7A31C42A7AB963B8AB9D85628BBB94735C999B2BD462001A002DBDF3',
      'nonce': 'FF6323B0',
      'expectedMosaicId': '51202B5C51F6A5A9'
    },
    {
      'publicKey': '2F95D9DCD4F18206A54FA95BD138DA1C038CA82546525A8FCC330185DA0647DC',
      'nonce': '99674492',
      'expectedMosaicId': '5CE4E38B09F1423D'
    },
    {
      'publicKey': 'A7892491F714B8A7469F763F695BDB0B3BF28D1CC6831D17E91F550A2D48BD12',
      'nonce': '55141880',
      'expectedMosaicId': '5EFD001B3350C9CB'
    },
    {
      'publicKey': '68BBDDF5C08F54278DA516F0E4A5CCF795C10E2DE26CAF127FF4357DA7ACF686',
      'nonce': '11FA5BAF',
      'expectedMosaicId': '179F0CDD6D2CCA7B'
    },
    {
      'publicKey': '014F6EF90792F814F6830D64017107534F5B718E2DD43C25ACAABBE347DEC81E',
      'nonce': '6CFBF7B3',
      'expectedMosaicId': '53095813DEB3D108'
    },
    {
      'publicKey': '95A6344597E0412C51B3559F58F564F9C2DE3101E5CC1DD8B115A93CE7040A71',
      'nonce': '905EADFE',
      'expectedMosaicId': '3551C4B12DDF067D'
    },
    {
      'publicKey': '0D7DDFEB652E8B65915EA734420A1233A233119BF1B0D41E1D5118CDD44447EE',
      'nonce': '61F5B671',
      'expectedMosaicId': '696E2FB0682D3199'
    },
    {
      'publicKey': 'FFD781A20B01D0C999AABC337B8BAE82D1E7929A9DD77CC1A71E4B99C0749684',
      'nonce': 'D8542F1A',
      'expectedMosaicId': '6C55E05D11D19FBD'
    }
  ];

  group('generateMosaicId', () {
    test('Can generate correct well known mosaic', () {
      // Test vector
      final mosaicInfo = {
        'nonce': 'B76FE378',
        'publicKey': '4AFF7B4BA8C1C26A7917575993346627CB6C80DE62CD92F7F9AEDB7064A3DE62',
        'expectedMosaicId': '3AD842A8C0AFC518' // mosaicId: Int64.fromInts(0x3AD842A8, 0xC0AFC518)
      };

      final List<int> nonce = HexUtils.getBytes(mosaicInfo['nonce']).toList();
      final nonceBytes = Uint8List.fromList(nonce.reversed.toList()); // Little-endian
      final publicKey = mosaicInfo['publicKey'];
      final mosaicId = IdGenerator.generateMosaicId(nonceBytes, publicKey);

      // Assert
      final expectedHex = mosaicInfo['expectedMosaicId'];
      expect(mosaicId.toHexString().toUpperCase(), equals(expectedHex));

      final idInt64 = Int64.fromInts(0x3AD842A8, 0xC0AFC518);
      final expectedId = Uint64.fromHex(idInt64.toHexString());
      expect(mosaicId.value, equals(expectedId.value));
    });

    test('Can generate correct mosaicId given a nonce and a public key', () {
      for (var testVector in TEST_MOSAICS) {
        final List<int> nonce = HexUtils.getBytes(testVector['nonce']).toList();
        final nonceBytes = Uint8List.fromList(nonce.reversed.toList()); // Little-endian
        final mosaicId = IdGenerator.generateMosaicId(nonceBytes, testVector['publicKey']);

        final expectedHex = testVector['expectedMosaicId'];
        expect(mosaicId.toHexString().toUpperCase(), equals(expectedHex));
      }
    });

    test('Cannot generate mosaicId from invalid inputs', () {
      final Uint8List nonce = IdGenerator.generateRandomMosaicNonce();

      expect(
          () => IdGenerator.generateMosaicId(null, null),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'The nonce and/or ownerPublicId must not be null or empty.')));

      expect(
          () => IdGenerator.generateMosaicId(null, ''),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'The nonce and/or ownerPublicId must not be null or empty.')));

      expect(
          () => IdGenerator.generateMosaicId(nonce, ''),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == 'The nonce and/or ownerPublicId must not be null or empty.')));

      expect(
          () => IdGenerator.generateMosaicId(nonce, 'abcdefg'),
          throwsA(predicate(
              (e) => e is ArgumentError && e.message == 'Invalid ownerPublicId hex string.')));
    });
  });

  group('generateNamespaceId', () {
    test('Can generate correct well known namespace', () {
      final namespaceId = IdGenerator.generateNamespaceId(IdGenerator.NAMESPACE_BASE_ID, 'nem');

      expect(namespaceId, equals(NEM_ID));
    });

    test('Can generate multilevel namespaces', () {
      final ids = <Uint64>[];
      ids.add(IdGenerator.generateNamespaceId(IdGenerator.NAMESPACE_BASE_ID, 'foo'));
      ids.add(IdGenerator.generateNamespaceId(ids[0], 'bar'));
      ids.add(IdGenerator.generateNamespaceId(ids[1], 'baz'));

      final namespaces = IdGenerator.generateNamespacePaths('foo.bar.baz');

      expect(ids.length, equals(namespaces.length));
      expect(ids[0].toHexString(), equals(namespaces[0].toHexString()));
      expect(ids[1].toHexString(), equals(namespaces[1].toHexString()));
      expect(ids[2].toHexString(), equals(namespaces[2].toHexString()));
    });
  });

  group('generateNameSpacePath', () {
    test('Can generate a correct well known namespace root path', () {
      final List<Uint64> ids = IdGenerator.generateNamespacePaths('nem');

      expect(ids.length, equals(1));
      expect(ids[0], equals(NEM_ID));
    });

    test('Can generate correct well known namespace path with child', () {
      final List<Uint64> ids = IdGenerator.generateNamespacePaths('nem.xem');

      expect(ids.length, equals(2));
      expect(ids[0], equals(NEM_ID));
      expect(ids[1], equals(XEM_ID));
    });

    test('Can generate namespace path with enough parts', () {
      final List<Uint64> ids = IdGenerator.generateNamespacePaths('a.b.c');

      expect(ids.length, equals(3));
    });

    test('Cannot generate namespace path with too many parts', () {
      expect(
          () => IdGenerator.generateNamespacePaths('a.b.c.d'),
          throwsA(predicate((e) =>
              e is CryptoException &&
              e.message ==
                  'Fully qualified id is invalid due to too many namespace parts (a.b.c.d)')));

      expect(
          () => IdGenerator.generateNamespacePaths('a.b.c.d.e'),
          throwsA(predicate((e) =>
              e is CryptoException &&
              e.message ==
                  'Fully qualified id is invalid due to too many namespace parts (a.b.c.d.e)')));
    });

    test('Cannot generate invalid namespaces', () {
      final List<String> invalidNames = [
        '',
        'alpha.bet@.zeta',
        'a!pha.beta.zeta',
        'alpha.beta.ze^a',
        '.',
        '.a',
        'a..a',
        'A'
      ];

      for (var name in invalidNames) {
        expect(
            () => IdGenerator.generateNamespacePaths(name),
            throwsA(predicate((e) =>
                e is CryptoException && e.message.contains('Fully qualified id is invalid'))));
      }
    });
  });
}
