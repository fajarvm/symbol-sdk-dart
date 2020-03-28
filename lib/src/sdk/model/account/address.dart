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

library symbol_sdk_dart.sdk.model.account.address;

import 'dart:typed_data' show Uint8List;

import 'package:symbol_sdk_dart/core.dart' show ByteUtils, HexUtils, RawAddress;

import '../network/network_type.dart';

/// The address structure describes an address with its network.
class Address {
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

  /// Get the address in an encoded format.
  ///
  /// For example: 9085215E4620D383C2DF70235B9EF7607F6A28EF6D16FD7B9C
  String get encoded => ByteUtils.bytesToHex(RawAddress.stringToAddress(address)).toUpperCase();

  /// Get the address in a plain format.
  ///
  /// For example: SB3KUBHATFCPV7UZQLWAQ2EUR6SIHBSBEOEDDDF3.
  String get plain => address;

  /// Get address in a pretty format.
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
    NetworkType.isValid(networkType, true);

    final Uint8List publicKeyByte = HexUtils.getBytes(publicKey);
    final Uint8List addressByte = RawAddress.publicKeyToAddress(publicKeyByte, networkType);
    final String addressString = RawAddress.addressToString(addressByte);

    return new Address._(addressString, networkType);
  }

  /// Creates an [Address] from a given [rawAddress] string.
  ///
  /// A raw address string looks like:
  /// SB3KUBHATFCPV7UZQLWAQ2EUR6SIHBSBEOEDDDF3 or SB3KUB-HATFCP-V7UZQL-WAQ2EU-R6SIHB-SBEOED-DDF3.
  static Address fromRawAddress(final String rawAddress) {
    final String networkIdentifier =
        rawAddress.trim().toUpperCase().replaceAll(REGEX_DASH, EMPTY_STRING);

    if (networkIdentifier.length != RawAddress.ADDRESS_ENCODED_SIZE) {
      throw new ArgumentError(
          'Address $networkIdentifier has to be ${RawAddress.ADDRESS_ENCODED_SIZE} characters long');
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
    final String rawAddress = RawAddress.addressToString(HexUtils.getBytes(encoded));
    return Address.fromRawAddress(rawAddress);
  }

  /// Converts an [address] String into a more readable/pretty format.
  ///
  /// Before: SB3KUBHATFCPV7UZQLWAQ2EUR6SIHBSBEOEDDDF3
  /// After: SB3KUB-HATFCP-V7UZQL-WAQ2EU-R6SIHB-SBEOED-DDF3
  static String prettify(final String address) {
    if (address.length != RawAddress.ADDRESS_ENCODED_SIZE) {
      throw new ArgumentError(
          'Address $address has to be ${RawAddress.ADDRESS_ENCODED_SIZE} characters long');
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

  /// Determines the validity of the given [rawAddress] for a specific [networkType].
  ///
  /// An example of a raw address string is: SCHCZBZ6QVJAHGJTKYVPW5FBSO2IXXJQBPV5XE6P
  static bool isValidRawAddress(final String rawAddress, final NetworkType networkType) {
    try {
      final Uint8List decoded = RawAddress.stringToAddress(rawAddress);
      return RawAddress.isValidAddress(decoded, networkType);
    } catch (e) {
      return false;
    }
  }

  /// Determines the validity of the given [encodedAddress] for a specific [networkType].
  ///
  /// An example of an encoded address string is: 9085215E4620D383C2DF70235B9EF7607F6A28EF6D16FD7B9C
  static bool isValidEncodedAddress(final String encodedAddress, final NetworkType networkType) {
    try {
      final Uint8List decoded = HexUtils.getBytes(encodedAddress);
      return RawAddress.isValidAddress(decoded, networkType);
    } catch (e) {
      return false;
    }
  }

  @override
  String toString() {
    return 'Address{address= $address, networkType= $networkType}';
  }
}
