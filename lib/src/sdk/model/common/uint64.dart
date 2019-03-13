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

library nem2_sdk_dart.sdk.model.common.uint64;

import 'dart:typed_data' show Uint8List;

import 'package:fixnum/fixnum.dart' show Int64;

import 'package:nem2_sdk_dart/core.dart' show ArrayUtils, StringUtils;

// Developer note:
// When compiled to JavaScript (via dart2js), integers are therefore restricted to 53 significant
// bits because all JavaScript numbers are double-precision floating point values.
//
// For big numbers, choose either BigInt (Dart's native data type) or Int64 from fixnum package.
// Please refer to this Dart language documentation page for information regarding big numbers
// and their known issues.
// See: https://github.com/dart-lang/sdk/blob/master/docs/language/informal/int64.md

/// Represents a 64-bit unsigned integer.
///
/// The value is stored as Dart's native big number data type `BigInt` as it will be translated
/// correctly into JavaScript (supported by dart2js).
/// Value range is 0 through 18446744073709551615.
class Uint64 implements Comparable<Uint64> {
  /// The accepted min value of 64-bit signed integer.
  static const int MIN_VALUE_SIGNED = 0;

  /// The maximum value of 64-bit signed integer. Equals to 9223372036854775807.
  static const int MAX_VALUE_SIGNED = 2147483648 * 2147483648 - 1 + 2147483648 * 2147483648;

  /// The accepted minimum value of 64-bit unsigned integer.
  static final BigInt MIN_VALUE = BigInt.zero;

  /// The maximum value of 64-bit unsigned integer. Equals to 18446744073709551615.
  static final BigInt MAX_VALUE = BigInt.parse('FFFFFFFFFFFFFFFF', radix: 16);

  /// The internal storage of the value.
  final BigInt _value;

  /// Get the value of this Uint64 as BigInt.
  BigInt get value => _value;

  @override
  int get hashCode => _value.hashCode;

  const Uint64._(this._value);

  factory Uint64([final int value = 0]) {
    if (MIN_VALUE_SIGNED > value) {
      throw new ArgumentError('Value must be above $MIN_VALUE');
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
    final Int64 int64 = Int64.fromBytes(bytes);
    return fromHex(int64.toHexString());
  }

  /// Creates a [Uint64] from a [hex].
  static Uint64 fromHex(final String hex) {
    final BigInt bigInt = BigInt.parse(hex, radix: 16);
    return fromBigInt(bigInt);
  }

  @override
  bool operator ==(final other) => other is Uint64 && _value == other.value;

  @override
  int compareTo(final Uint64 other) => _value.compareTo(other.value);

  bool isZero() => BigInt.zero == _value && ArrayUtils.isZero(toBytes());

  @override
  String toString() => _value.toString();

  /// Converts to hex string representation. Fills with leading 0 to reach 16 characters length.
  String toHex() {
    final String hex = _value.toRadixString(16);
    if (hex.length != 16) {
      return StringUtils.padLeft(hex, 16, '0');
    }
    return hex;
  }

  /// Converts to 64-bit byte array.
  Uint8List toBytes() {
    final String hex = toHex();
    final Int64 int64 = Int64.parseHex(hex);

    return Uint8List.fromList(int64.toBytes());
  }

  // ------------------------------ private / protected functions ------------------------------ //

  static void _checkValue(final BigInt value) {
    if (value < MIN_VALUE || value > MAX_VALUE) {
      throw new ArgumentError('Value out of range');
    }
  }
}
