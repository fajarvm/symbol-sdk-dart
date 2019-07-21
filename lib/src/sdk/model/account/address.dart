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

library nem2_sdk_dart.sdk.model.account.address;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/core.dart' show ArrayUtils, Base32, Ed25519, HexUtils, SHA3DigestNist;
import 'package:pointycastle/export.dart' show RIPEMD160Digest;

import '../blockchain/network_type.dart';

/// The address structure describes an address with its network.
class Address {
  static const int RIPEMD_160_SIZE = 20;
  static const int ADDRESS_DECODED_SIZE = 25;
  static const int ADDRESS_ENCODED_SIZE = 40;
  static const int KEY_SIZE = 32;
  static const int CHECKSUM_SIZE = 4;
  static const int START_CHECKSUM_SIZE = 21; // ADDRESS_DECODED_SIZE - CHECKSUM_SIZE

  static const String PREFIX_MIJIN_TEST = 'S';
  static const String PREFIX_MIJIN = 'M';
  static const String PREFIX_TEST_NET = 'T';
  static const String PREFIX_MAIN_NET = 'N';
  static const String EMPTY_STRING = '';

  static final RegExp REGEX_DASH = new RegExp(r'-');
  static final RegExp REGEX_PRETTY = new RegExp('.{1,6}');

  /// The address.
  final String address;

  /// The network type of this address.
  final NetworkType networkType;

  // private constructor
  const Address._(this.address, this.networkType);

  /// Get the address in plain format.
  ///
  /// For example: SB3KUBHATFCPV7UZQLWAQ2EUR6SIHBSBEOEDDDF3.
  String get plain => address;

  /// Get address in pretty format.
  ///
  /// For example: SB3KUB-HATFCP-V7UZQL-WAQ2EU-R6SIHB-SBEOED-DDF3.
  String get pretty => prettify(address);

  @override
  bool operator ==(final other) =>
      identical(this, other) ||
      other is Address &&
          this.runtimeType == other.runtimeType &&
          this.networkType == other.networkType &&
          this.address == other.address;

  @override
  int get hashCode => networkType.hashCode ^ address.hashCode;

  /// Creates an [Address] from a given [publicKey] string for the given [networkType].
  static Address fromPublicKey(final String publicKey, final NetworkType networkType) {
    ArgumentError.checkNotNull(networkType);
    NetworkType.isValid(networkType.value, true);

    final Uint8List publicKeyByte = HexUtils.getBytes(publicKey);
    final Uint8List addressByte = publicKeyToAddress(publicKeyByte, networkType);
    final String addressString = addressToString(addressByte);

    return new Address._(addressString, networkType);
  }

  /// Creates an [Address] from a given string of [rawAddress].
  ///
  /// A raw address string looks like:
  /// SB3KUBHATFCPV7UZQLWAQ2EUR6SIHBSBEOEDDDF3 or SB3KUB-HATFCP-V7UZQL-WAQ2EU-R6SIHB-SBEOED-DDF3.
  static Address fromRawAddress(final String rawAddress) {
    final String networkIdentifier =
        rawAddress.trim().toUpperCase().replaceAll(REGEX_DASH, EMPTY_STRING);

    if (networkIdentifier.length != ADDRESS_ENCODED_SIZE) {
      throw new ArgumentError(
          'Address $networkIdentifier has to be $ADDRESS_ENCODED_SIZE characters long');
    }

    switch (networkIdentifier[0]) {
      case PREFIX_MIJIN_TEST:
        return new Address._(networkIdentifier, NetworkType.MIJIN_TEST);
      case PREFIX_MIJIN:
        return new Address._(networkIdentifier, NetworkType.MIJIN);
      case PREFIX_TEST_NET:
        return new Address._(networkIdentifier, NetworkType.TEST_NET);
      case PREFIX_MAIN_NET:
        return new Address._(networkIdentifier, NetworkType.MAIN_NET);
      default:
        throw new UnsupportedError('unknown address network type');
    }
  }

  /// Create an [Address] from the given [encoded] address.
  static Address fromEncoded(final String encoded) {
    final String rawAddress = addressToString(HexUtils.getBytes(encoded));
    return Address.fromRawAddress(rawAddress);
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
    // Step 1: create a SHA3-256 hash of the public key
    final SHA3DigestNist digest = Ed25519.createSha3Digest(length: Ed25519.KEY_SIZE);
    final Uint8List stepOne = new Uint8List(KEY_SIZE);
    digest.update(publicKey, 0, KEY_SIZE);
    digest.doFinal(stepOne, 0);

    // Step 2: perform a RIPEMD160 on previous step
    final RIPEMD160Digest rm160Digest = new RIPEMD160Digest();
    final Uint8List stepTwo = new Uint8List(RIPEMD_160_SIZE);
    rm160Digest.update(stepOne, 0, KEY_SIZE);
    rm160Digest.doFinal(stepTwo, 0);

    // Step 3: prepend network type
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

    // Step 7: return base 32 encoded address
    // String base32EncodedAddress = Base32.encode(stepSix);

    return stepSix;
  }

  /// Converts an [address] String into a more readable/pretty format.
  ///
  /// Before: SB3KUBHATFCPV7UZQLWAQ2EUR6SIHBSBEOEDDDF3
  /// After: SB3KUB-HATFCP-V7UZQL-WAQ2EU-R6SIHB-SBEOED-DDF3
  static String prettify(final String address) {
    if (address.length != ADDRESS_ENCODED_SIZE) {
      throw new ArgumentError('Address $address has to be $ADDRESS_ENCODED_SIZE characters long');
    }

    final StringBuffer sb = new StringBuffer();
    final Iterable<Match> matches = REGEX_PRETTY.allMatches(address);
    final String last = matches.last.group(0);

    for (var match in matches) {
      final String current = match.group(0);
      sb.write(current);
      if (current != last) {
        sb.write('-');
      }
    }

    return sb.toString();
  }

  /// Determines the validity of the given [decodedAddress].
  static bool isValidAddress(final Uint8List decodedAddress) {
    final SHA3DigestNist digest = Ed25519.createSha3Digest(length: Ed25519.KEY_SIZE);
    final Uint8List hash = digest.process(decodedAddress.sublist(0, START_CHECKSUM_SIZE));
    final Uint8List checksum = hash.buffer.asUint8List(0, CHECKSUM_SIZE);
    return ArrayUtils.deepEqual(checksum, decodedAddress.sublist(START_CHECKSUM_SIZE));
  }

  /// Determines the validity of the given [encodedAddress].
  static bool isValidEncodedAddress(final String encodedAddress) {
    if (ADDRESS_ENCODED_SIZE != encodedAddress.length) {
      return false;
    }

    try {
      final Uint8List decoded = stringToAddress(encodedAddress);
      return isValidAddress(decoded);
    } catch (e) {
      return false;
    }
  }

  @override
  String toString() {
    return 'Address{address= $address, networkType= $networkType}';
  }
}
