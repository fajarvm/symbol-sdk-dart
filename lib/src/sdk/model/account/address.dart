library nem2_sdk_dart.sdk.model.account.address;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/src/sdk/model/blockchain/network_type.dart';
import 'package:nem2_sdk_dart/src/core/utils.dart' show Base32, HexUtils;

/// The address structure describes an address with its network.
class Address {
  static const int RIPEMD_160 = 20;
  static const int ADDRESS_DECODED_SIZE = 25;
  static const int ADDRESS_ENCODED_SIZE = 40;
  static const int KEY_SIZE = 32;
  static const int CHECKSUM = 32;

  // final NetworkType _networkType;
  final String _address;

  Address(this._address);

  /// Converts a [decodedAddress] to an encoded address [String].
  static String addressToString(decodedAddress) {
    final String hexStringAddress = HexUtils.getString(decodedAddress);
    if (ADDRESS_ENCODED_SIZE != decodedAddress.length) {
      throw ArgumentError(
          "The Address ${hexStringAddress} does not represent a valid decoded address");
    }

    return Base32.encode(decodedAddress);
  }

  /// Converts a [publicKey to a decoded address for a specific [networkType]
  static Uint8List publicKeyToAddress(
      final Uint8List publicKey, final NetworkType networkType) {
    return null;
  }

  /// Create an address from a given [rawAddress]
  static Address createFromRawAddress(final String rawAddress) {
    return null;
  }
}
