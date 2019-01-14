library nem2_sdk_dart.core.crypto.nacl_catapult;

import 'dart:typed_data';
import 'dart:convert';
import 'dart:math';
import 'dart:core';

import 'package:convert/convert.dart';
import 'package:fixnum/fixnum.dart';

import 'package:pointycastle/export.dart' show FortunaRandom, HMac, SHA3Digest;

class NaclCatapult {
  static int crypto_secretbox_KEYBYTES = 32,
      crypto_secretbox_NONCEBYTES = 24,
      crypto_secretbox_ZEROBYTES = 32,
      crypto_secretbox_BOXZEROBYTES = 16,
      crypto_scalarmult_BYTES = 32,
      crypto_scalarmult_SCALARBYTES = 32,
      crypto_box_PUBLICKEYBYTES = 32,
      crypto_box_SECRETKEYBYTES = 32,
      crypto_box_BEFORENMBYTES = 32,
      crypto_box_NONCEBYTES = crypto_secretbox_NONCEBYTES,
      crypto_box_ZEROBYTES = crypto_secretbox_ZEROBYTES,
      crypto_box_BOXZEROBYTES = crypto_secretbox_BOXZEROBYTES,
      crypto_sign_BYTES = 64,
      crypto_sign_PUBLICKEYBYTES = 32,
      crypto_sign_SECRETKEYBYTES = 64,
      crypto_sign_SEEDBYTES = 32,
      crypto_hash_BYTES = 64;

  final Uint8List _0 = new Uint8List(16);
  final Uint8List _9 = new Uint8List(32);

  final FortunaRandom _secureRandom;

  NaclCatapult._(this._secureRandom) {
    // init
    this._9[0] = 9;
  }

  factory NaclCatapult() {
    return new NaclCatapult._(new FortunaRandom());
  }

  Int64List gf0 = gf();
  Int64List gf1 = gf(init: [1].toList());
  Int64List _121665 = gf(init: [0xdb41, 1].toList());
  Int64List D = gf(
      init: [
    0x78a3,
    0x1359,
    0x4dca,
    0x75eb,
    0xd8ab,
    0x4141,
    0x0a4d,
    0x0070,
    0xe898,
    0x7779,
    0x4079,
    0x8cc7,
    0xfe73,
    0x2b6f,
    0x6cee,
    0x5203
  ].toList());
  Int64List D2 = gf(
      init: [
    0xf159,
    0x26b2,
    0x9b94,
    0xebd6,
    0xb156,
    0x8283,
    0x149a,
    0x00e0,
    0xd130,
    0xeef3,
    0x80f2,
    0x198e,
    0xfce7,
    0x56df,
    0xd9dc,
    0x2406
  ].toList());
  Int64List X = gf(
      init: [
    0xd51a,
    0x8f25,
    0x2d60,
    0xc956,
    0xa7b2,
    0x9525,
    0xc760,
    0x692c,
    0xdc5c,
    0xfdd6,
    0xe231,
    0xc0a4,
    0x53fe,
    0xcd6e,
    0x36d3,
    0x2169
  ].toList());
  Int64List Y = gf(
      init: [
    0x6658,
    0x6666,
    0x6666,
    0x6666,
    0x6666,
    0x6666,
    0x6666,
    0x6666,
    0x6666,
    0x6666,
    0x6666,
    0x6666,
    0x6666,
    0x6666,
    0x6666,
    0x6666
  ].toList());
  Int64List I = gf(
      init: [
    0xa0b0,
    0x4a0e,
    0x1b27,
    0xc4ee,
    0xe478,
    0xad2f,
    0x1806,
    0x2f43,
    0xd7a7,
    0x3dfb,
    0x0099,
    0x2b4d,
    0xdf0b,
    0x4fc1,
    0x2480,
    0x2b83
  ].toList());

  static Int64List gf({final Int64List init = null}) {
    final Int64List r = new Int64List(16);
    if (init == null) {
      return r;
    }

    for (int i = 0; i < init.length; i++) {
      r[i] = init[i];
    }

    return r;
  }

  static void ts64(Uint8List x, final int i, Int32 h, Int32 l) {
    x[i] = ((h >> 24) & 0xff).toInt();
    x[i + 1] = ((h >> 16) & 0xff).toInt();
    x[i + 2] = ((h >> 8) & 0xff).toInt();
    x[i + 3] = (h & 0xff).toInt();
    x[i + 4] = ((l >> 24) & 0xff).toInt();
    x[i + 5] = ((l >> 16) & 0xff).toInt();
    x[i + 6] = ((l >> 8) & 0xff).toInt();
    x[i + 7] = (l & 0xff).toInt();
  }

  static int vn(Uint8List x, final int xi, Uint8List y, final int yi, int n) {
    int i, d = 0;
    for (i = 0; i < n; i++) d |= (x[i + xi] ^ y[i + yi]) & 0xff;
    return (1 & (Int32(d - 1).shiftRightUnsigned(8).toInt())) - 1;
  }

  Uint8List randomBytes(int length) {
    Uint8List b = new Uint8List(length);
    _randomBytesInternal(b, length);
    return b;
  }

  // -------------------- private / protected functions -------------------- //

  static void _cleanup(final Uint8List input) {
    //    for (int i = 0; i < input.length; i++) {
    //      input[i] = 0;
    //    }
    input.clear();
  }

  void _randomBytesInternal(final Uint8List output, final int length) {
    Uint8List v = this._secureRandom.nextBytes(length);
    for (int i = 0; i < length; i++) {
      output[i] = v[i];
    }
    _cleanup(v);
  }
}
