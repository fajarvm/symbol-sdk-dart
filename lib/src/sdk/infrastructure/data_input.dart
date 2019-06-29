// MIT License
//
// Copyright (c) 2018 Jeff Lee
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'dart:convert';
import 'dart:typed_data';

// A port of Java's DataInput class
class DataInput {
  Uint8List data;
  int _fileLength;
  ByteData view;
  int _offset = 0;

  int get offset => _offset;

  int get fileLength => _fileLength;

  DataInput.fromUint8List(this.data) {
    this.view = ByteData.view(data.buffer);
    _fileLength = data.lengthInBytes;
  }

  /// Returns the byte(-128 - 127) at [offset]. if [eofException] is false then
  /// if it reaches the end of the stream it will return -129.
  /// Otherwise it will throw an exception.
  int readByte([bool eofException = true]) {
    if (offset < fileLength) {
      return view.getInt8(_offset++);
    } else if (eofException) {
      throw RangeError('Reached end of file');
    } else {
      return -129;
    }
  }

  Uint8List readBytes(int numBytes) {
    if ((_offset + numBytes) <= fileLength) {
      int old_offset = _offset;
      _offset += numBytes;
      pad();
      return Uint8List.fromList(data.getRange(old_offset, old_offset + numBytes).toList());
    } else {
      throw RangeError('Reached end of file');
    }
  }

  /// Returns the byte(0-255) at [offset]. if [eofException] is false then
  /// if it reaches the end of the stream it will return -1, Otherwise it will
  /// throw an exception.
  int readUnsignedByte([bool eofException = true]) {
    if (offset < fileLength) {
      return view.getUint8(_offset++);
    } else if (eofException) {
      throw RangeError('Reached end of file');
    } else {
      return -129;
    }
  }

  int readShort([Endian endian = Endian.big]) {
    var old_offset = _offset;
    _offset += 2;
    return view.getInt16(old_offset, endian);
  }

  int readUnsignedShort([Endian endian = Endian.big]) {
    var old_offset = _offset;
    _offset += 2;
    return view.getUint16(old_offset, endian);
  }

  int readInt([Endian endian = Endian.big]) {
    var old_offset = _offset;
    _offset += 4;
    return view.getInt32(old_offset, endian);
  }

  int readLong([Endian endian = Endian.big]) {
    var old_offset = _offset;
    _offset += 8;
    return view.getInt64(old_offset, endian);
  }

  double readFloat([Endian endian = Endian.big]) {
    var old_offset = _offset;
    _offset += 4;
    return view.getFloat32(old_offset, endian);
  }

  double readDouble([Endian endian = Endian.big]) {
    var old_offset = _offset;
    _offset += 8;
    return view.getFloat64(old_offset, endian);
  }

  String readLine([Endian endian = Endian.big]) {
    var byte = readUnsignedByte(false);
    if (byte == -1) {
      return null;
    }

    StringBuffer result = StringBuffer();
    while (byte != -1 && byte != 0x0A) {
      if (byte != 0x0D) {
        result.writeCharCode(byte);
      }
      byte = readUnsignedByte(false);
    }
    return result.toString();
  }

  String readChar([Endian endian = Endian.big]) {
    return String.fromCharCode(readShort(endian));
  }

  bool readBoolean() {
    return readByte() != 0;
  }

  void readFully(List bytes, {int len, int off, Endian endian = Endian.big}) {
    if (len != null || off != null) {
      if ((len != null && off == null) || (len == null && off != null)) {
        throw ArgumentError('You must supply both [len] and [off] values.');
      }
      if (len < 0 || off < 0) {
        throw RangeError('$off - $len is out of bounds');
      }
      if (len == 0) return;
    }

    if (len != null) {
      bytes.addAll(data.getRange(off, len));
    } else {
      fillList(bytes, readBytes(bytes.length));
    }
  }

  String readUtf([Endian endian = Endian.big]) {
    int length = readShort(endian);
    List<int> bytes = readBytes(length);
    return utf8.decode(bytes);
  }

  int skipBytes(int n) {
    _offset += n;
    if (_offset > fileLength) {
      var change = _offset - fileLength;
      _offset = fileLength;
      return n - change;
    }
    return n;
  }

  void fillList(List one, List two) {
    for (int x = 0; x < one.length; x++) {
      if (x >= two.length) return;
      one[x] = two[x];
    }
  }

  void pad() {
    int pad = 0;
    int mod = _offset % 4;
    if (mod > 0) {
      pad = 4 - mod;
    }

    while (pad-- > 0) {
      int b = readByte();
      if (b != 0) {
        throw Exception('non-zero padding');
      }
    }
  }
}
