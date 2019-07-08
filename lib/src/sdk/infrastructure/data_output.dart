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

// A port of Java's DataOutput class
class DataOutput {
  List<int> data = [];
  int offset = 0;
  final Uint8List _buffer = Uint8List(8);
  ByteData _view;

  int get fileLength => data.length;

  List<int> get bytes => data;

  DataOutput() {
    _view = ByteData.view(_buffer.buffer);
  }

  void write(List<int> bytes) {
    int bytesLength = bytes.length;
    data.addAll(bytes);
    offset += bytesLength;
    pad();
  }

  void writeBoolean(bool value, [Endian endian = Endian.big]) {
    writeByte(value ? 1 : 0, endian);
  }

  void writeByte(int value, [Endian endian = Endian.big]) {
    data.add(value);
    offset += 1;
  }

  void writeChar(int value, [Endian endian = Endian.big]) {
    writeShort(value, endian);
  }

  void writeChars(String charString, [Endian endian = Endian.big]) {
    for (int x = 0; x <= charString.length; x++) {
      writeChar(charString.codeUnitAt(x), endian);
    }
  }

  void writeFloat(double v, [Endian endian = Endian.big]) {
    _view.setFloat32(0, v, endian);
    write(_buffer.getRange(0, 4).toList());
  }

  void writeDouble(double v, [Endian endian = Endian.big]) {
    _view.setFloat64(0, v, endian);
    write(_buffer.getRange(0, 8).toList());
  }

  void writeShort(int value, [Endian endian = Endian.big]) {
    _view.setInt16(0, value, endian);
    write(_buffer.getRange(0, 2).toList());
  }

  void writeInt(int value, [Endian endian = Endian.big]) {
    _view.setInt32(0, value, endian);
    write(_buffer.getRange(0, 4).toList());
  }

  void writeLong(int value, [Endian endian = Endian.big]) {
    _view.setInt64(0, value, endian);
    write(_buffer.getRange(0, 8).toList());
  }

  void writeUtf(String utfString, [Endian endian = Endian.big]) {
    if (utfString == null) {
      throw new ArgumentError('String cannot be null');
    }
    List<int> bytesNeeded = utf8.encode(utfString);
    if (bytesNeeded.length > 65535) {
      throw const FormatException('Length cannot be greater than 65535');
    }
    writeShort(bytesNeeded.length, endian);
    write(bytesNeeded);
  }

  void pad() {
    int pad = 0;
    int mod = offset % 4;
    if (mod > 0) {
      pad = 4 - mod;
    }
    while (pad-- > 0) {
      writeByte(0);
    }
  }
}
