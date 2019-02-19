library nem2_sdk_dart.sdk.model.account.account_info;

import 'dart:typed_data' show Uint8List;

import 'address.dart';

import '../mosaic/mosaic.dart';

/// The account info structure describes basic information for an account.
class AccountInfo {
  final Address _address;
  final BigInt _addressHeight;
  final String _publicKey;
  final BigInt _publicKeyHeight;
  final BigInt _importance;
  final BigInt _importanceHeight;
  final List<Mosaic> _mosaics;

  const AccountInfo._(this._address, this._addressHeight, this._publicKey, this._publicKeyHeight,
      this._importance, this._importanceHeight, this._mosaics);

  factory AccountInfo(
      final Address address,
      final BigInt addressHeight,
      final String publicKey,
      final BigInt publicKeyHeight,
      final BigInt importance,
      final BigInt importanceHeight,
      final List<Mosaic> mosaics) {
    return new AccountInfo._(
        address, addressHeight, publicKey, publicKeyHeight, importance, importanceHeight, mosaics);
  }
}
