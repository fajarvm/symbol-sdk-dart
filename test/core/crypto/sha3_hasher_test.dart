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

library symbol_sdk_dart.test.core.crypto.sha3_hasher_test;

import 'dart:typed_data';

import 'package:pointycastle/export.dart' show Digest;
import 'package:symbol_sdk_dart/core.dart' show HexUtils, SHA3Hasher;
import 'package:test/test.dart';

void main() {
  group('SHA3Hasher', () {
    group('create()', () {
      test('SHA3 (non-Keccak) - 256', () {
        final Digest hasher = SHA3Hasher.create(SHA3Hasher.HASH_SIZE_32_BYTES);
        expect(hasher.algorithmName, equals('SHA-3/256'));
      });

      test('SHA3 (non-Keccak) - 512', () {
        final Digest hasher = SHA3Hasher.create(SHA3Hasher.HASH_SIZE_64_BYTES);
        expect(hasher.algorithmName, equals('SHA-3/512'));
      });
    });

    group('hash()', () {
      test('SHA3 (NIST) - 256', () {
        addSha3Test(SHA3Hasher.HASH_SIZE_32_BYTES, '',
            'A7FFC6F8BF1ED76651C14756A061D662F580FF4DE43B49FA82D80A4B80F8434A');
        addSha3Test(SHA3Hasher.HASH_SIZE_32_BYTES, 'CC',
            '677035391CD3701293D385F037BA32796252BB7CE180B00B582DD9B20AAAD7F0');
        addSha3Test(SHA3Hasher.HASH_SIZE_32_BYTES, '41FB',
            '39F31B6E653DFCD9CAED2602FD87F61B6254F581312FB6EEEC4D7148FA2E72AA');
        addSha3Test(SHA3Hasher.HASH_SIZE_32_BYTES, '1F877C',
            'BC22345E4BD3F792A341CF18AC0789F1C9C966712A501B19D1B6632CCD408EC5');
        addSha3Test(SHA3Hasher.HASH_SIZE_32_BYTES, 'C1ECFDFC',
            'C5859BE82560CC8789133F7C834A6EE628E351E504E601E8059A0667FF62C124');
        addSha3Test(
            SHA3Hasher.HASH_SIZE_32_BYTES,
            '9F2FCC7C90DE090D6B87CD7E9718C1EA6CB21118FC2D5DE9F97E5DB6AC1E9C10',
            '2F1A5F7159E34EA19CDDC70EBF9B81F1A66DB40615D7EAD3CC1F1B954D82A3AF');
      });

      test('SHA3 (NIST) - 512', () {
        addSha3Test(
            SHA3Hasher.HASH_SIZE_64_BYTES,
            '',
            'A69F73CCA23A9AC5C8B567DC185A756E97C982164FE25859E0D1DCC1475C80A615'
                'B2123AF1F5F94C11E3E9402C3AC558F500199D95B6D3E301758586281DCD26');
        addSha3Test(
            SHA3Hasher.HASH_SIZE_64_BYTES,
            'CC',
            '3939FCC8B57B63612542DA31A834E5DCC36E2EE0F652AC72E02624FA2E5ADEECC7'
                'DD6BB3580224B4D6138706FC6E80597B528051230B00621CC2B22999EAA205');
        addSha3Test(
            SHA3Hasher.HASH_SIZE_64_BYTES,
            '41FB',
            'AA092865A40694D91754DBC767B5202C546E226877147A95CB8B4C8F8709FE8CD69'
                '05256B089DA37896EA5CA19D2CD9AB94C7192FC39F7CD4D598975A3013C69');
        addSha3Test(
            SHA3Hasher.HASH_SIZE_64_BYTES,
            '1F877C',
            'CB20DCF54955F8091111688BECCEF48C1A2F0D0608C3A575163751F002DB30F40F2'
                'F671834B22D208591CFAF1F5ECFE43C49863A53B3225BDFD7C6591BA7658B');
        addSha3Test(
            SHA3Hasher.HASH_SIZE_64_BYTES,
            'C1ECFDFC',
            'D4B4BDFEF56B821D36F4F70AB0D231B8D0C9134638FD54C46309D14FADA92A28401'
                '86EED5415AD7CF3969BDFBF2DAF8CCA76ABFE549BE6578C6F4143617A4F1A');
        addSha3Test(
            SHA3Hasher.HASH_SIZE_64_BYTES,
            '9F2FCC7C90DE090D6B87CD7E9718C1EA6CB21118FC2D5DE9F97E5DB6AC1E9C10',
            'B087C90421AEBF87911647DE9D465CBDA166B672EC47CCD4054A7135A1EF885E7903'
                'B52C3F2C3FE722B1C169297A91B82428956A02C631A2240F12162C7BC726');
      });
    });

    test('should throw an exception when trying to retrieve an invalid hasher', () {
      // SHA3
      expect(() => SHA3Hasher.create(null),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Invalid'))));
      expect(() => SHA3Hasher.create(-1),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Invalid'))));
      expect(() => SHA3Hasher.create(0),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Invalid'))));
      expect(() => SHA3Hasher.create(33),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Invalid'))));
      expect(() => SHA3Hasher.create(65),
          throwsA(predicate((e) => e is ArgumentError && e.message.contains('Invalid'))));
    });
  });
}

void addSha3Test(int length, String input, String expectedOutput) {
  Uint8List inputBytes = HexUtils.getBytes(input);
  Uint8List outputBytes = SHA3Hasher.hash(inputBytes, length);
  expect(HexUtils.getString(outputBytes).toUpperCase(), equals(expectedOutput));
}
