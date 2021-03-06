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

library symbol_sdk_dart.sdk.model.common.uint64;

import 'dart:typed_data' show Uint8List;

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:symbol_sdk_dart/core.dart' show ArrayUtils, StringUtils;

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
/// This class uses Dart's native number type [BigInt] and has a value check for big integers.
/// [BigInt] will be translated correctly into JavaScript (supported by dart2js).
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

  /// The value of Uint64 is stored as BigInt.
  final BigInt value;

  /// Tries to compact a this value into a simple numeric.
  int get compact {
    final intArray = this.toIntArray();
    final int low = intArray[0];
    final int high = intArray[1];

    // don't compact if the value is >= 2^53
    if (0x00200000 <= high) {
      return this.value.toInt();
    }

    // multiply because javascript bit operations operate on 32bit values
    return (high * 0x100000000) + low;
  }

  @override
  int get hashCode => value.hashCode;

  const Uint64._(this.value);

  factory Uint64([final int value = 0, final int value2 = 0]) {
    if (MIN_VALUE_SIGNED > value || MIN_VALUE_SIGNED > value2) {
      throw new ArgumentError('Value must be above $MIN_VALUE');
    }

    // check if user is trying to create using an array of (32-bit) int
    if (MIN_VALUE_SIGNED < value2) {
      return Uint64.fromInts(value, value2);
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

  /// Creates a [Uint64] from a pair of 32-bit integers.
  static Uint64 fromInts(final int lower, final int higher) {
    final Int64 int64 = Int64.fromInts(higher, lower);
    return fromHex(int64.toHexString());
  }

  @override
  bool operator ==(final other) => other is Uint64 && this.value == other.value;

  /// Addition operator.
  Uint64 operator +(final Uint64 other) {
    return Uint64.fromBigInt(this.value + other.value);
  }

  /// Subtraction operator.
  Uint64 operator -(final Uint64 other) {
    return Uint64.fromBigInt(this.value - other.value);
  }

  @override
  int compareTo(final Uint64 other) => this.value.compareTo(other.value);

  bool isZero() => BigInt.zero == value && ArrayUtils.isZero(toBytes());

  @override
  String toString() => value.toString();

  /// Converts to hex string representation. Fills with leading 0 to reach 16 characters length.
  String toHex() {
    final String hex = value.toRadixString(16);
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

  /// Converts to a pair of 32-bit integers ([lower, higher]).
  List<int> toIntArray() {
    Uint8List bytes = toBytes();

    int higher = bytes[7] & 0xff;
    higher <<= 8;
    higher |= bytes[6] & 0xff;
    higher <<= 8;
    higher |= bytes[5] & 0xff;
    higher <<= 8;
    higher |= bytes[4] & 0xff;

    int lower = bytes[3] & 0xff;
    lower <<= 8;
    lower |= bytes[2] & 0xff;
    lower <<= 8;
    lower |= bytes[1] & 0xff;
    lower <<= 8;
    lower |= bytes[0] & 0xff;

    return [lower, higher];
  }

  // ------------------------------ private / protected functions ------------------------------ //

  static void _checkValue(final BigInt value) {
    if (value < MIN_VALUE || value > MAX_VALUE) {
      throw new ArgumentError('Value out of range');
    }
  }
}
