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

library nem2_sdk_dart.core.crypto.raw_address;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/nem2_sdk_dart.dart' show NetworkType;
import 'package:nem2_sdk_dart/src/core/utils.dart';
import 'package:pointycastle/export.dart' show Digest;

import 'crypto_utils.dart';
import 'sha3_hasher.dart';
import 'sign_schema.dart';

/// Utility class that knows how to create an address based on a public key. It supports the
/// different hashes algorithms defined in [SignSchema]
class RawAddress {
  static const int RIPEMD_160_SIZE = 20;
  static const int ADDRESS_DECODED_SIZE = 25;
  static const int ADDRESS_ENCODED_SIZE = 40;
  static const int KEY_SIZE = 32;
  static const int CHECKSUM_SIZE = 4;
  static const int START_CHECKSUM_SIZE = 21; // ADDRESS_DECODED_SIZE - CHECKSUM_SIZE

  // private constructor
  const RawAddress._();

  /// Format an [namespaceId] alias for a specific [networkType] into a valid recipient.
  static Uint8List aliasToRecipient(final Uint8List namespaceId, final NetworkType networkType) {
    // network type byte
    final Uint8List networkByte = Uint8List.fromList([networkType.value | 0x01]);

    // 0x91 | namespaceId on 8 bytes | 16 bytes 0-pad = 25 bytes
    final padded = Uint8List(1 + 8 + 16);
    padded.setAll(0, networkByte);
    padded.setAll(1, namespaceId.reversed);
    padded.setAll(9, HexUtils.getBytes(''.padRight(16, '00')));
    return padded;
  }

  /// Converts a `Base32` [encodedAddress] string to decoded address bytes.
  static Uint8List stringToAddress(final String encodedAddress) {
    if (ADDRESS_ENCODED_SIZE != encodedAddress.length) {
      throw ArgumentError(
          'The encoded address $encodedAddress does not represent a valid encoded address');
    }

    return Base32.decode(encodedAddress);
  }

  /// Converts a [decodedAddress] bytes to a `Base32` encoded address string.
  static String addressToString(final Uint8List decodedAddress) {
    final String hexAddress = HexUtils.getString(decodedAddress);
    if (ADDRESS_DECODED_SIZE != decodedAddress.length) {
      throw ArgumentError('The Address $hexAddress does not represent a valid decoded address');
    }

    return Base32.encode(decodedAddress);
  }

  /// Converts a [publicKey] to decoded address byte for a specific [networkType].
  static Uint8List publicKeyToAddress(final Uint8List publicKey, final NetworkType networkType) {
    final SignSchema signSchema = NetworkType.resolveSignSchema(networkType, true);

    // Step 1: SHA3 hash of the public key
    final Digest digest = SHA3Hasher.create(signSchema, hashSize: SignSchema.HASH_SIZE_32_BYTES);
    final Uint8List stepOne = new Uint8List(KEY_SIZE);
    digest.update(publicKey, 0, KEY_SIZE);
    digest.doFinal(stepOne, 0);

    // Step 2: RIPEMD160 hash of (1)
    final Digest rm160Digest = CryptoUtils.createRipemd160Digest();
    final Uint8List stepTwo = new Uint8List(RIPEMD_160_SIZE);
    rm160Digest.update(stepOne, 0, KEY_SIZE);
    rm160Digest.doFinal(stepTwo, 0);

    // Step 3: prepend network type in front of (2)
    final Uint8List decodedAddress = new Uint8List(ADDRESS_DECODED_SIZE);
    decodedAddress[0] = networkType.value;
    ArrayUtils.copy(decodedAddress, stepTwo, numOfElements: RIPEMD_160_SIZE, destOffset: 1);

    // Step 4: perform SHA3-256 on previous step
    final Uint8List stepFour = new Uint8List(KEY_SIZE);
    const int rm160Length = RIPEMD_160_SIZE + 1;
    digest.update(decodedAddress, 0, rm160Length);
    digest.doFinal(stepFour, 0);

    // Step 5: retrieve checksum
    final Uint8List stepFive = new Uint8List(CHECKSUM_SIZE);
    ArrayUtils.copy(stepFive, stepFour, numOfElements: CHECKSUM_SIZE);

    // Step 6: append stepFive to result of stepThree
    final Uint8List stepSix = new Uint8List(ADDRESS_DECODED_SIZE);
    ArrayUtils.copy(stepSix, decodedAddress, numOfElements: rm160Length);
    ArrayUtils.copy(stepSix, stepFive, numOfElements: CHECKSUM_SIZE, destOffset: rm160Length);

    // enable step 7 if the base32 string format is wanted
    // Step 7: return base 32 encoded address
    // String base32EncodedAddress = Base32.encode(stepSix);

    return stepSix;
  }

  /// Determines the validity of the given [decodedAddress] for a specific [networkType].
  static bool isValidAddress(final Uint8List decodedAddress, final NetworkType networkType) {
    final SignSchema signSchema = NetworkType.resolveSignSchema(networkType, true);
    final Digest digest = SHA3Hasher.create(signSchema, hashSize: SignSchema.HASH_SIZE_32_BYTES);
    final Uint8List hash = digest.process(decodedAddress.sublist(0, START_CHECKSUM_SIZE));
    final Uint8List checksum = hash.buffer.asUint8List(0, CHECKSUM_SIZE);
    return ArrayUtils.deepEqual(checksum, decodedAddress.sublist(START_CHECKSUM_SIZE));
  }
}
