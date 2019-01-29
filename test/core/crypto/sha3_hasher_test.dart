library nem2_sdk_dart.test.core.crypto.sha3_hasher_test;

import "package:test/test.dart";
import "dart:typed_data" show Uint8List;

import "package:nem2_sdk_dart/src/core/crypto.dart" show Sha3Hasher;
import "package:nem2_sdk_dart/src/core/utils.dart" show HexUtils;

main() {
  const List<String> inputs = [
    '',
    'CC',
    '41FB',
    '1F877C',
    'C1ECFDFC',
    '9F2FCC7C90DE090D6B87CD7E9718C1EA6CB21118FC2D5DE9F97E5DB6AC1E9C10'
  ];

  group('test hash function', () {
    const List<String> expectedOutput = [
      'A7FFC6F8BF1ED76651C14756A061D662F580FF4DE43B49FA82D80A4B80F8434A',
      '677035391CD3701293D385F037BA32796252BB7CE180B00B582DD9B20AAAD7F0',
      '39F31B6E653DFCD9CAED2602FD87F61B6254F581312FB6EEEC4D7148FA2E72AA',
      'BC22345E4BD3F792A341CF18AC0789F1C9C966712A501B19D1B6632CCD408EC5',
      'C5859BE82560CC8789133F7C834A6EE628E351E504E601E8059A0667FF62C124',
      '2F1A5F7159E34EA19CDDC70EBF9B81F1A66DB40615D7EAD3CC1F1B954D82A3AF'
    ];

    test('Can hash test vectors (SHA3 256)', () {
      final int length = 32; // SHA3-256

      // sanity check
      expect(expectedOutput.length, equals(inputs.length));

//      for (int i = 0; i < inputs.length; i++) {
      final String inputHex = inputs[3];
      final Uint8List inputBuffer = HexUtils.getBytes(inputHex);
      final expectedHash = expectedOutput[3];

      Uint8List hash = new Uint8List(length);
      print('Before hash: ' + hash.toString());
      Sha3Hasher.hash(hash, inputBuffer, length: length);
      print('After hash: ' + hash.toString());

      final String hashString = HexUtils.getString(hash).toUpperCase();
      // TODO: Test failing. Fix needed
      expect(hashString, equals(expectedHash));
//      }
    });
  });
}
