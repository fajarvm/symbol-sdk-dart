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

// The tweetnacl-dart library is licensed under MIT. Copyright (c) 2018 Jeff Lee.
// For a complete library, refer to: github.com/jspschool/tweetnacl-dart
//
// README: This is copied from tweeetnacl/nacl.fast.js and is updated with custom hash functions.

library symbol_sdk_dart.core.crypto.catapult_nacl;

import 'dart:core';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:tweetnacl/tweetnacl.dart' as nacl;

/// This class contains a selected collection of TweetNaCl cryptographic related operations.
class CatapultNacl extends nacl.TweetNaclFast {
  static final Int64List _gf0 = Int64List.fromList([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);//16
  static final Int64List _gf1 = Int64List.fromList([1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);//16

  static final Int64List _D = Int64List.fromList([
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
  ]);

  static final Int64List _D2 = Int64List.fromList([
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
  ]);
  static final Int64List _I = Int64List.fromList([
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
  ]);

  static Int64List gf([final Int64List init]) {
    final Int64List r = new Int64List(16);
    if (init != null) {
      for (int i = 0; i < init.length; i++) {
        r[i] = init[i];
      }
    }
    return r;
  }

  static void pack(Uint8List r, List<Int64List> p) {
    Int64List tx = gf();
    Int64List ty = gf();
    Int64List zi = gf();

    _inv25519(zi, 0, p[2], 0);

    _M(tx, p[0], zi);
    _M(ty, p[1], zi);

    _pack25519(r, ty, 0);

    r[31] ^= _par25519(tx) << 7;
  }

  // Developer's note:
  // This is a custom unpack() function inline with the JavaScript/TypeScript implementation
  // of TweetNaclFast.unpack(). The TweetNacFast implementation for Dart has no unpack() and
  // only has the unpackneg() which gives a different result.
  static int unpack(List<Int64List> r, Uint8List p) {
    Int64List t = gf(), chk = gf(), num = gf(), den = gf(), den2 = gf(), den4 = gf(), den6 = gf();

    _set25519(r[2], _gf1);
    unpack25519(r[1], p);
    _S(num, r[1]);
    _M(den, num, _D);
    _Z(num, num, r[2]);
    _A(den, r[2], den);

    _S(den2, den);
    _S(den4, den2);
    _M(den6, den4, den2);
    _M(t, den6, num);
    _M(t, t, den);

    _pow2523(t, t);
    _M(t, t, num);
    _M(t, t, den);
    _M(t, t, den);
    _M(r[0], t, den);

    _S(chk, r[0]);
    _M(chk, chk, den);
    if (_neq25519(chk, num) != 0) _M(r[0], r[0], _I);

    _S(chk, r[0]);
    _M(chk, chk, den);
    if (_neq25519(chk, num) != 0) return -1;

    if (_par25519(r[0]) != (Int32(p[31] & 0xFF).shiftRightUnsigned(7).toInt()))
      _Z(r[0], _gf0, r[0]);

    _M(r[3], r[0], r[1]);

    return 0;
  }

  static void scalarmult(
      List<Int64List> p, List<Int64List> q, Uint8List s, final int soff) {
    int i;

    _set25519(p[0], _gf0);
    _set25519(p[1], _gf1);
    _set25519(p[2], _gf1);
    _set25519(p[3], _gf0);

    for (i = 255; i >= 0; --i) {
      int b = ((Int32(s[(i / 8 + soff).toInt()]).shiftRightUnsigned(i & 7)).toInt() & 1);

      _cswap(p, q, b);
      _add(q, p);
      _add(p, p);
      _cswap(p, q, b);
    }
  }

  static Uint8List secureRandomBytes(int len) {
    return nacl.TweetNaclFast.randombytes(len);
  }


  // ------------------------------ private / protected functions ------------------------------ //

  static void _A(Int64List o, Int64List a, Int64List b) {
    _A_off(o, 0, a, 0, b, 0);
  }

  static void _A_off(Int64List o, final int ooff, Int64List a, final int aoff,
      Int64List b, final int boff) {
    int i;
    for (i = 0; i < 16; i++) o[i + ooff] = a[i + aoff] + b[i + boff];
  }

  static void _Z(Int64List o, Int64List a, Int64List b) {
    _Z_off(o, 0, a, 0, b, 0);
  }

  static void _Z_off(Int64List o, final int ooff, Int64List a, final int aoff,
      Int64List b, final int boff) {
    int i;
    for (i = 0; i < 16; i++) o[i + ooff] = a[i + aoff] - b[i + boff];
  }

  static void _M(Int64List o, Int64List a, Int64List b) {
    _M_off(o, 0, a, 0, b, 0);
  }

  static void _M_off(Int64List o, final int ooff, Int64List a, final int aoff,
      Int64List b, final int boff) {
    int v,
        c,
        t0 = 0,
        t1 = 0,
        t2 = 0,
        t3 = 0,
        t4 = 0,
        t5 = 0,
        t6 = 0,
        t7 = 0,
        t8 = 0,
        t9 = 0,
        t10 = 0,
        t11 = 0,
        t12 = 0,
        t13 = 0,
        t14 = 0,
        t15 = 0,
        t16 = 0,
        t17 = 0,
        t18 = 0,
        t19 = 0,
        t20 = 0,
        t21 = 0,
        t22 = 0,
        t23 = 0,
        t24 = 0,
        t25 = 0,
        t26 = 0,
        t27 = 0,
        t28 = 0,
        t29 = 0,
        t30 = 0,
        b0 = b[0 + boff],
        b1 = b[1 + boff],
        b2 = b[2 + boff],
        b3 = b[3 + boff],
        b4 = b[4 + boff],
        b5 = b[5 + boff],
        b6 = b[6 + boff],
        b7 = b[7 + boff],
        b8 = b[8 + boff],
        b9 = b[9 + boff],
        b10 = b[10 + boff],
        b11 = b[11 + boff],
        b12 = b[12 + boff],
        b13 = b[13 + boff],
        b14 = b[14 + boff],
        b15 = b[15 + boff];

    v = a[0 + aoff];
    t0 += v * b0;
    t1 += v * b1;
    t2 += v * b2;
    t3 += v * b3;
    t4 += v * b4;
    t5 += v * b5;
    t6 += v * b6;
    t7 += v * b7;
    t8 += v * b8;
    t9 += v * b9;
    t10 += v * b10;
    t11 += v * b11;
    t12 += v * b12;
    t13 += v * b13;
    t14 += v * b14;
    t15 += v * b15;
    v = a[1 + aoff];
    t1 += v * b0;
    t2 += v * b1;
    t3 += v * b2;
    t4 += v * b3;
    t5 += v * b4;
    t6 += v * b5;
    t7 += v * b6;
    t8 += v * b7;
    t9 += v * b8;
    t10 += v * b9;
    t11 += v * b10;
    t12 += v * b11;
    t13 += v * b12;
    t14 += v * b13;
    t15 += v * b14;
    t16 += v * b15;
    v = a[2 + aoff];
    t2 += v * b0;
    t3 += v * b1;
    t4 += v * b2;
    t5 += v * b3;
    t6 += v * b4;
    t7 += v * b5;
    t8 += v * b6;
    t9 += v * b7;
    t10 += v * b8;
    t11 += v * b9;
    t12 += v * b10;
    t13 += v * b11;
    t14 += v * b12;
    t15 += v * b13;
    t16 += v * b14;
    t17 += v * b15;
    v = a[3 + aoff];
    t3 += v * b0;
    t4 += v * b1;
    t5 += v * b2;
    t6 += v * b3;
    t7 += v * b4;
    t8 += v * b5;
    t9 += v * b6;
    t10 += v * b7;
    t11 += v * b8;
    t12 += v * b9;
    t13 += v * b10;
    t14 += v * b11;
    t15 += v * b12;
    t16 += v * b13;
    t17 += v * b14;
    t18 += v * b15;
    v = a[4 + aoff];
    t4 += v * b0;
    t5 += v * b1;
    t6 += v * b2;
    t7 += v * b3;
    t8 += v * b4;
    t9 += v * b5;
    t10 += v * b6;
    t11 += v * b7;
    t12 += v * b8;
    t13 += v * b9;
    t14 += v * b10;
    t15 += v * b11;
    t16 += v * b12;
    t17 += v * b13;
    t18 += v * b14;
    t19 += v * b15;
    v = a[5 + aoff];
    t5 += v * b0;
    t6 += v * b1;
    t7 += v * b2;
    t8 += v * b3;
    t9 += v * b4;
    t10 += v * b5;
    t11 += v * b6;
    t12 += v * b7;
    t13 += v * b8;
    t14 += v * b9;
    t15 += v * b10;
    t16 += v * b11;
    t17 += v * b12;
    t18 += v * b13;
    t19 += v * b14;
    t20 += v * b15;
    v = a[6 + aoff];
    t6 += v * b0;
    t7 += v * b1;
    t8 += v * b2;
    t9 += v * b3;
    t10 += v * b4;
    t11 += v * b5;
    t12 += v * b6;
    t13 += v * b7;
    t14 += v * b8;
    t15 += v * b9;
    t16 += v * b10;
    t17 += v * b11;
    t18 += v * b12;
    t19 += v * b13;
    t20 += v * b14;
    t21 += v * b15;
    v = a[7 + aoff];
    t7 += v * b0;
    t8 += v * b1;
    t9 += v * b2;
    t10 += v * b3;
    t11 += v * b4;
    t12 += v * b5;
    t13 += v * b6;
    t14 += v * b7;
    t15 += v * b8;
    t16 += v * b9;
    t17 += v * b10;
    t18 += v * b11;
    t19 += v * b12;
    t20 += v * b13;
    t21 += v * b14;
    t22 += v * b15;
    v = a[8 + aoff];
    t8 += v * b0;
    t9 += v * b1;
    t10 += v * b2;
    t11 += v * b3;
    t12 += v * b4;
    t13 += v * b5;
    t14 += v * b6;
    t15 += v * b7;
    t16 += v * b8;
    t17 += v * b9;
    t18 += v * b10;
    t19 += v * b11;
    t20 += v * b12;
    t21 += v * b13;
    t22 += v * b14;
    t23 += v * b15;
    v = a[9 + aoff];
    t9 += v * b0;
    t10 += v * b1;
    t11 += v * b2;
    t12 += v * b3;
    t13 += v * b4;
    t14 += v * b5;
    t15 += v * b6;
    t16 += v * b7;
    t17 += v * b8;
    t18 += v * b9;
    t19 += v * b10;
    t20 += v * b11;
    t21 += v * b12;
    t22 += v * b13;
    t23 += v * b14;
    t24 += v * b15;
    v = a[10 + aoff];
    t10 += v * b0;
    t11 += v * b1;
    t12 += v * b2;
    t13 += v * b3;
    t14 += v * b4;
    t15 += v * b5;
    t16 += v * b6;
    t17 += v * b7;
    t18 += v * b8;
    t19 += v * b9;
    t20 += v * b10;
    t21 += v * b11;
    t22 += v * b12;
    t23 += v * b13;
    t24 += v * b14;
    t25 += v * b15;
    v = a[11 + aoff];
    t11 += v * b0;
    t12 += v * b1;
    t13 += v * b2;
    t14 += v * b3;
    t15 += v * b4;
    t16 += v * b5;
    t17 += v * b6;
    t18 += v * b7;
    t19 += v * b8;
    t20 += v * b9;
    t21 += v * b10;
    t22 += v * b11;
    t23 += v * b12;
    t24 += v * b13;
    t25 += v * b14;
    t26 += v * b15;
    v = a[12 + aoff];
    t12 += v * b0;
    t13 += v * b1;
    t14 += v * b2;
    t15 += v * b3;
    t16 += v * b4;
    t17 += v * b5;
    t18 += v * b6;
    t19 += v * b7;
    t20 += v * b8;
    t21 += v * b9;
    t22 += v * b10;
    t23 += v * b11;
    t24 += v * b12;
    t25 += v * b13;
    t26 += v * b14;
    t27 += v * b15;
    v = a[13 + aoff];
    t13 += v * b0;
    t14 += v * b1;
    t15 += v * b2;
    t16 += v * b3;
    t17 += v * b4;
    t18 += v * b5;
    t19 += v * b6;
    t20 += v * b7;
    t21 += v * b8;
    t22 += v * b9;
    t23 += v * b10;
    t24 += v * b11;
    t25 += v * b12;
    t26 += v * b13;
    t27 += v * b14;
    t28 += v * b15;
    v = a[14 + aoff];
    t14 += v * b0;
    t15 += v * b1;
    t16 += v * b2;
    t17 += v * b3;
    t18 += v * b4;
    t19 += v * b5;
    t20 += v * b6;
    t21 += v * b7;
    t22 += v * b8;
    t23 += v * b9;
    t24 += v * b10;
    t25 += v * b11;
    t26 += v * b12;
    t27 += v * b13;
    t28 += v * b14;
    t29 += v * b15;
    v = a[15 + aoff];
    t15 += v * b0;
    t16 += v * b1;
    t17 += v * b2;
    t18 += v * b3;
    t19 += v * b4;
    t20 += v * b5;
    t21 += v * b6;
    t22 += v * b7;
    t23 += v * b8;
    t24 += v * b9;
    t25 += v * b10;
    t26 += v * b11;
    t27 += v * b12;
    t28 += v * b13;
    t29 += v * b14;
    t30 += v * b15;

    t0 += 38 * t16;
    t1 += 38 * t17;
    t2 += 38 * t18;
    t3 += 38 * t19;
    t4 += 38 * t20;
    t5 += 38 * t21;
    t6 += 38 * t22;
    t7 += 38 * t23;
    t8 += 38 * t24;
    t9 += 38 * t25;
    t10 += 38 * t26;
    t11 += 38 * t27;
    t12 += 38 * t28;
    t13 += 38 * t29;
    t14 += 38 * t30;
// t15 left as is

// first car
    c = 1;
    v = t0 + c + 65535;
    c = v >> 16;
    t0 = v - c * 65536;
    v = t1 + c + 65535;
    c = v >> 16;
    t1 = v - c * 65536;
    v = t2 + c + 65535;
    c = v >> 16;
    t2 = v - c * 65536;
    v = t3 + c + 65535;
    c = v >> 16;
    t3 = v - c * 65536;
    v = t4 + c + 65535;
    c = v >> 16;
    t4 = v - c * 65536;
    v = t5 + c + 65535;
    c = v >> 16;
    t5 = v - c * 65536;
    v = t6 + c + 65535;
    c = v >> 16;
    t6 = v - c * 65536;
    v = t7 + c + 65535;
    c = v >> 16;
    t7 = v - c * 65536;
    v = t8 + c + 65535;
    c = v >> 16;
    t8 = v - c * 65536;
    v = t9 + c + 65535;
    c = v >> 16;
    t9 = v - c * 65536;
    v = t10 + c + 65535;
    c = v >> 16;
    t10 = v - c * 65536;
    v = t11 + c + 65535;
    c = v >> 16;
    t11 = v - c * 65536;
    v = t12 + c + 65535;
    c = v >> 16;
    t12 = v - c * 65536;
    v = t13 + c + 65535;
    c = v >> 16;
    t13 = v - c * 65536;
    v = t14 + c + 65535;
    c = v >> 16;
    t14 = v - c * 65536;
    v = t15 + c + 65535;
    c = v >> 16;
    t15 = v - c * 65536;
    t0 += c - 1 + 37 * (c - 1);

// second car
    c = 1;
    v = t0 + c + 65535;
    c = v >> 16;
    t0 = v - c * 65536;
    v = t1 + c + 65535;
    c = v >> 16;
    t1 = v - c * 65536;
    v = t2 + c + 65535;
    c = v >> 16;
    t2 = v - c * 65536;
    v = t3 + c + 65535;
    c = v >> 16;
    t3 = v - c * 65536;
    v = t4 + c + 65535;
    c = v >> 16;
    t4 = v - c * 65536;
    v = t5 + c + 65535;
    c = v >> 16;
    t5 = v - c * 65536;
    v = t6 + c + 65535;
    c = v >> 16;
    t6 = v - c * 65536;
    v = t7 + c + 65535;
    c = v >> 16;
    t7 = v - c * 65536;
    v = t8 + c + 65535;
    c = v >> 16;
    t8 = v - c * 65536;
    v = t9 + c + 65535;
    c = v >> 16;
    t9 = v - c * 65536;
    v = t10 + c + 65535;
    c = v >> 16;
    t10 = v - c * 65536;
    v = t11 + c + 65535;
    c = v >> 16;
    t11 = v - c * 65536;
    v = t12 + c + 65535;
    c = v >> 16;
    t12 = v - c * 65536;
    v = t13 + c + 65535;
    c = v >> 16;
    t13 = v - c * 65536;
    v = t14 + c + 65535;
    c = v >> 16;
    t14 = v - c * 65536;
    v = t15 + c + 65535;
    c = v >> 16;
    t15 = v - c * 65536;
    t0 += c - 1 + 37 * (c - 1);

    o[0 + ooff] = t0;
    o[1 + ooff] = t1;
    o[2 + ooff] = t2;
    o[3 + ooff] = t3;
    o[4 + ooff] = t4;
    o[5 + ooff] = t5;
    o[6 + ooff] = t6;
    o[7 + ooff] = t7;
    o[8 + ooff] = t8;
    o[9 + ooff] = t9;
    o[10 + ooff] = t10;
    o[11 + ooff] = t11;
    o[12 + ooff] = t12;
    o[13 + ooff] = t13;
    o[14 + ooff] = t14;
    o[15 + ooff] = t15;
  }

  static void _S(Int64List o, Int64List a) {
    _S_off(o, 0, a, 0);
  }

  static void _S_off(Int64List o, final int ooff, Int64List a, final int aoff) {
    _M_off(o, ooff, a, aoff, a, aoff);
  }

  static void _set25519(Int64List r, Int64List a) {
    int i;
    for (i = 0; i < 16; i++) r[i] = a[i];
  }

  static void _car25519(Int64List o) {
    int i;
    int v, c = 1;
    for (i = 0; i < 16; i++) {
      v = o[i] + c + 65535;
      c = v >> 16;
      o[i] = v - c * 65536;
    }
    o[0] += c - 1 + 37 * (c - 1);
  }


  static void _sel25519_off(
      Int64List p, final int poff, Int64List q, final int qoff, int b) {
    int t, c = ~(b - 1);
    for (int i = 0; i < 16; i++) {
      t = c & (p[i + poff] ^ q[i + qoff]);
      p[i + poff] ^= t;
      q[i + qoff] ^= t;
    }
  }

  static void _pack25519(Uint8List o, Int64List n, final int noff) {
    int i, j, b;
    Int64List m = gf(), t = gf();
    for (i = 0; i < 16; i++) t[i] = n[i + noff];
    _car25519(t);
    _car25519(t);
    _car25519(t);
    for (j = 0; j < 2; j++) {
      m[0] = t[0] - 0xffed;
      for (i = 1; i < 15; i++) {
        m[i] = t[i] - 0xffff - ((m[i - 1] >> 16) & 1);
        m[i - 1] &= 0xffff;
      }
      m[15] = t[15] - 0x7fff - ((m[14] >> 16) & 1);
      b = ((m[15] >> 16) & 1);
      m[14] &= 0xffff;
      _sel25519_off(t, 0, m, 0, 1 - b);
    }
    for (i = 0; i < 16; i++) {
      o[2 * i] = (t[i] & 0xff).toInt();
      o[2 * i + 1] = (t[i] >> 8);
    }
  }

  static int _neq25519(Int64List a, Int64List b) {
    return _neq25519_off(a, 0, b, 0);
  }

  static int _neq25519_off(Int64List a, final int aoff, Int64List b, final int boff) {
    Uint8List c = Uint8List(32), d = Uint8List(32);
    _pack25519(c, a, aoff);
    _pack25519(d, b, boff);
    return _crypto_verify_32(c, 0, d, 0);
  }

  static int _par25519(Int64List a) {
    return _par25519_off(a, 0);
  }

  static int _par25519_off(Int64List a, final int aoff) {
    Uint8List d = Uint8List(32);
    _pack25519(d, a, aoff);
    return (d[0] & 1);
  }

  static void unpack25519(Int64List o, Uint8List n) {
    int i;
    for (i = 0; i < 16; i++)
      o[i] = (n[2 * i] & 0xff) + (((n[2 * i + 1] << 8) & 0xffff));
    o[15] &= 0x7fff;
  }

  static int _vn(Uint8List x, final int xoff, Uint8List y, final int yoff, int n) {
    int i,d = 0;
    for (i = 0; i < n; i++) d |= (x[i + xoff] ^ y[i + yoff]) & 0xff;
    return (1 & (Int32(d - 1).shiftRightUnsigned(8).toInt())) - 1;
  }

  static void _inv25519(Int64List o, final int ooff, Int64List i, final int ioff) {
    Int64List c = gf();
    int a;
    for (a = 0; a < 16; a++) c[a] = i[a + ioff];
    for (a = 253; a >= 0; a--) {
      _S_off(c, 0, c, 0);
      if (a != 2 && a != 4) _M_off(c, 0, c, 0, i, ioff);
    }
    for (a = 0; a < 16; a++) o[a + ooff] = c[a];
  }

  static void _pow2523(Int64List o, Int64List i) {
    Int64List c = gf();
    int a;

    for (a = 0; a < 16; a++) c[a] = i[a];

    for (a = 250; a >= 0; a--) {
      _S_off(c, 0, c, 0);
      if (a != 1) _M_off(c, 0, c, 0, i, 0);
    }

    for (a = 0; a < 16; a++) o[a] = c[a];
  }

  static int _crypto_verify_32(Uint8List x, final int xoff, Uint8List y, final int yoff) {
    return _vn(x, xoff, y, yoff, 32);
  }

  static int crypto_verify_32(Uint8List x, Uint8List y) {
    return _crypto_verify_32(x, 0, y, 0);
  }

  ///private static void add(gf p[4],gf q[4])
  static void _add(List<Int64List> p, List<Int64List> q) {
    Int64List a = gf();
    Int64List b = gf();
    Int64List c = gf();
    Int64List d = gf();
    Int64List t = gf();
    Int64List e = gf();
    Int64List f = gf();
    Int64List g = gf();
    Int64List h = gf();

    Int64List p0 = p[0];
    Int64List p1 = p[1];
    Int64List p2 = p[2];
    Int64List p3 = p[3];

    Int64List q0 = q[0];
    Int64List q1 = q[1];
    Int64List q2 = q[2];
    Int64List q3 = q[3];

    _Z_off(a, 0, p1, 0, p0, 0);
    _Z_off(t, 0, q1, 0, q0, 0);
    _M_off(a, 0, a, 0, t, 0);
    _A_off(b, 0, p0, 0, p1, 0);
    _A_off(t, 0, q0, 0, q1, 0);
    _M_off(b, 0, b, 0, t, 0);
    _M_off(c, 0, p3, 0, q3, 0);
    _M_off(c, 0, c, 0, _D2, 0);
    _M_off(d, 0, p2, 0, q2, 0);

    _A_off(d, 0, d, 0, d, 0);
    _Z_off(e, 0, b, 0, a, 0);
    _Z_off(f, 0, d, 0, c, 0);
    _A_off(g, 0, d, 0, c, 0);
    _A_off(h, 0, b, 0, a, 0);

    _M_off(p0, 0, e, 0, f, 0);
    _M_off(p1, 0, h, 0, g, 0);
    _M_off(p2, 0, g, 0, f, 0);
    _M_off(p3, 0, e, 0, h, 0);
  }

  static void _cswap(List<Int64List> p, List<Int64List> q, int b) {
    int i;

    for (i = 0; i < 4; i++) _sel25519_off(p[i], 0, q[i], 0, b);
  }
}
