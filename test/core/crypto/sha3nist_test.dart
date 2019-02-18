library nem2_sdk_dart.test.core.crypto.sha3nist_test;

import 'dart:typed_data' show Uint8List;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/src/core/crypto.dart' show SHA3DigestNist;
import 'package:nem2_sdk_dart/src/core/utils.dart' show HexUtils;

main() {
  const List<String> inputs = [
    '',
    'CC',
    '41FB',
    '1F877C',
    'C1ECFDFC',
    '9F2FCC7C90DE090D6B87CD7E9718C1EA6CB21118FC2D5DE9F97E5DB6AC1E9C10'
  ];

  group('Test hasher (SHA3 256)', () {
    // Test vectors are taken from :
    // https://github.com/gvanas/KeccakCodePackage/blob/master/TestVectors/ShortMsgKAT_SHA3-256.txt
    const List<String> expectedOutput = [
      'A7FFC6F8BF1ED76651C14756A061D662F580FF4DE43B49FA82D80A4B80F8434A',
      '677035391CD3701293D385F037BA32796252BB7CE180B00B582DD9B20AAAD7F0',
      '39F31B6E653DFCD9CAED2602FD87F61B6254F581312FB6EEEC4D7148FA2E72AA',
      'BC22345E4BD3F792A341CF18AC0789F1C9C966712A501B19D1B6632CCD408EC5',
      'C5859BE82560CC8789133F7C834A6EE628E351E504E601E8059A0667FF62C124',
      '2F1A5F7159E34EA19CDDC70EBF9B81F1A66DB40615D7EAD3CC1F1B954D82A3AF'
    ];

    test('SHA3 256 can hash test vectors', () {
      // sanity check
      expect(expectedOutput.length, equals(inputs.length));

      for (int i = 0; i < inputs.length; i++) {
        final String inputHex = inputs[i];
        final Uint8List inputBuffer = HexUtils.getBytes(inputHex);
        final expectedHash = expectedOutput[i];

        final SHA3DigestNist hasher = new SHA3DigestNist(256); // SHA3-256
        Uint8List hash = hasher.process(inputBuffer);

        final String hashString = HexUtils.getString(hash).toUpperCase();
        expect(hashString, equals(expectedHash));
      }
    });

    test('SHA3 256 can hash test vectors in two parts', () {
      // sanity check
      expect(expectedOutput.length, equals(inputs.length));

      for (int i = 0; i < inputs.length; i++) {
        final String inputHex = inputs[i];
        final Uint8List inputBuffer = HexUtils.getBytes(inputHex);
        final expectedHash = expectedOutput[i];

        final SHA3DigestNist hasher = new SHA3DigestNist(256); // SHA3-256
        hasher.reset();

        // hash the input in two parts
        Uint8List firstPart = inputBuffer.sublist(0, inputBuffer.length ~/ 2);
        Uint8List secondPart = inputBuffer.sublist(inputBuffer.length ~/ 2);
        hasher.update(firstPart, 0, firstPart.length);
        hasher.update(secondPart, 0, secondPart.length);

        Uint8List hash = new Uint8List(32);
        hasher.doFinal(hash, 0);

        final String hashString = HexUtils.getString(hash).toUpperCase();
        expect(hashString, equals(expectedHash));
      }
    });

    test('SHA3 256 can reuse after reset', () {
      String inputHex = inputs[3];
      String expectedHash = expectedOutput[3];

      final SHA3DigestNist hasher = new SHA3DigestNist(256); // SHA3-256
      hasher.reset();
      Uint8List data = HexUtils.getBytes('ABCD');
      hasher.update(data, 0, data.length);

      // reset
      hasher.reset();

      // update with test vector
      Uint8List inputBytes = HexUtils.getBytes(inputHex);
      hasher.update(inputBytes, 0, inputBytes.length);

      Uint8List hash = new Uint8List(32);
      hasher.doFinal(hash, 0);

      expect(HexUtils.getString(hash).toUpperCase(), equals(expectedHash));
    });
  });

  group('Test hasher (SHA3 512)', () {
    // Test vectors are taken from:
    // https://github.com/gvanas/KeccakCodePackage/blob/master/TestVectors/ShortMsgKAT_SHA3-512.txt
    const List<String> expectedOutput = [
      'A69F73CCA23A9AC5C8B567DC185A756E97C982164FE25859E0D1DCC1475C80A615B2123AF1F5F94C11E3E9402C3AC558F500199D95B6D3E301758586281DCD26',
      '3939FCC8B57B63612542DA31A834E5DCC36E2EE0F652AC72E02624FA2E5ADEECC7DD6BB3580224B4D6138706FC6E80597B528051230B00621CC2B22999EAA205',
      'AA092865A40694D91754DBC767B5202C546E226877147A95CB8B4C8F8709FE8CD6905256B089DA37896EA5CA19D2CD9AB94C7192FC39F7CD4D598975A3013C69',
      'CB20DCF54955F8091111688BECCEF48C1A2F0D0608C3A575163751F002DB30F40F2F671834B22D208591CFAF1F5ECFE43C49863A53B3225BDFD7C6591BA7658B',
      'D4B4BDFEF56B821D36F4F70AB0D231B8D0C9134638FD54C46309D14FADA92A2840186EED5415AD7CF3969BDFBF2DAF8CCA76ABFE549BE6578C6F4143617A4F1A',
      'B087C90421AEBF87911647DE9D465CBDA166B672EC47CCD4054A7135A1EF885E7903B52C3F2C3FE722B1C169297A91B82428956A02C631A2240F12162C7BC726'
    ];

    test('SHA3 512 can hash test vectors', () {
      // sanity check
      expect(expectedOutput.length, equals(inputs.length));

      for (int i = 0; i < inputs.length; i++) {
        final String inputHex = inputs[i];
        final Uint8List inputBuffer = HexUtils.getBytes(inputHex);
        final expectedHash = expectedOutput[i];

        final SHA3DigestNist hasher = new SHA3DigestNist(512); // SHA3-512
        Uint8List hash = hasher.process(inputBuffer);

        final String hashString = HexUtils.getString(hash).toUpperCase();
        expect(hashString, equals(expectedHash));
      }
    });

    test('SHA3 512 can hash test vectors in two parts', () {
      // sanity check
      expect(expectedOutput.length, equals(inputs.length));

      for (int i = 0; i < inputs.length; i++) {
        final String inputHex = inputs[i];
        final Uint8List inputBuffer = HexUtils.getBytes(inputHex);
        final expectedHash = expectedOutput[i];

        final SHA3DigestNist hasher = new SHA3DigestNist(512); // SHA3-512
        hasher.reset();

        // hash the input in two parts
        Uint8List firstPart = inputBuffer.sublist(0, inputBuffer.length ~/ 2);
        Uint8List secondPart = inputBuffer.sublist(inputBuffer.length ~/ 2);
        hasher.update(firstPart, 0, firstPart.length);
        hasher.update(secondPart, 0, secondPart.length);

        Uint8List hash = new Uint8List(64);
        hasher.doFinal(hash, 0);

        final String hashString = HexUtils.getString(hash).toUpperCase();
        expect(hashString, equals(expectedHash));
      }
    });

    test('SHA3 512 can reuse after reset', () {
      String inputHex = inputs[3];
      String expectedHash = expectedOutput[3];

      final SHA3DigestNist hasher = new SHA3DigestNist(512); // SHA3-512
      hasher.reset();
      Uint8List data = HexUtils.getBytes('ABCD');
      hasher.update(data, 0, data.length);

      // reset
      hasher.reset();

      // update with test vector
      Uint8List inputBytes = HexUtils.getBytes(inputHex);
      hasher.update(inputBytes, 0, inputBytes.length);

      Uint8List hash = new Uint8List(64);
      hasher.doFinal(hash, 0);

      expect(HexUtils.getString(hash).toUpperCase(), equals(expectedHash));
    });
  });
}
