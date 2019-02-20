library nem2_sdk_dart.core.crypto.uint64;

import 'dart:typed_data' show Uint8List;

import 'package:nem2_sdk_dart/core.dart' show ArrayUtils, HexUtils;

/// Represents a 64-bit unsigned integer.
///
/// The value is stored as Dart's native big number data type `BigInt` as it will be translated
/// correctly into JavaScript (supported by dart2js).
/// Value range is 0 through 18446744073709551615.
class Uint64 implements Comparable<Uint64> {
  /// The accepted min value of 64-bit signed integer
  static const int MIN_VALUE_SIGNED = 0;

  /// The maximum value of 64-bit signed integer
  static const int MAX_VALUE_SIGNED = 2147483648 * 2147483648 - 1 + 2147483648 * 2147483648;

  /// The accepted minimum value of 64-bit unsigned integer.
  static final BigInt MIN_VALUE = BigInt.zero;

  /// The maximum value of 64-bit unsigned integer.
  static final BigInt MAX_VALUE = BigInt.parse('FFFFFFFFFFFFFFFF', radix: 16);

  /// The internal storage of the value.
  final BigInt _value;

  /// Get the value of this Uint64 as BigInt.
  BigInt get value => _value;

  @override
  int get hashCode {
    return this._value.hashCode;
  }

  const Uint64._(this._value);

  factory Uint64([final int value = 0]) {
    if (MIN_VALUE_SIGNED > value) {
      throw new ArgumentError('Value must be above ${MIN_VALUE}');
    }

    final BigInt bigValue = BigInt.from(value);
    _checkValue(bigValue);

    return new Uint64._(bigValue);
  }

  /// Creates a [Uint64] from a [bigInt].
  static Uint64 fromBigInt(final BigInt bigInt) {
    _checkValue(bigInt);
    return new Uint64._(bigInt);
  }

  /// Creates a [Uint64] from a uint8list [bytes] (64-bit).
  static Uint64 fromBytes(final Uint8List bytes) {
    return fromHex(HexUtils.bytesToHex(bytes));
  }

  /// Creates a [Uint64] from a [hexString].
  static Uint64 fromHex(final String hexString) {
    return fromBigInt(BigInt.parse(hexString, radix: 16));
  }

  @override
  bool operator ==(other) {
    return other is Uint64 && this._value == other.value;
  }

  @override
  int compareTo(Uint64 other) {
    return this._value.compareTo(other.value);
  }

  bool isZero() {
    return BigInt.zero == this._value && ArrayUtils.isZero(toBytes());
  }

  @override
  String toString() {
    return this._value.toString();
  }

  String toHexString() {
    String hexString = this._value.toRadixString(16);
    if (hexString.length != 16) {
      return new List.filled(16 - hexString.length, '0').join() + hexString;
    }
    return hexString;
  }

  Uint8List toBytes() {
    return HexUtils.getBytes(toHexString());
  }

  static void _checkValue(final BigInt value) {
    if (value < MIN_VALUE || value > MAX_VALUE) {
      throw new ArgumentError('Value out of range');
    }
  }
}
