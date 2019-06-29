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

import 'data_input.dart';
import 'data_output.dart';

class DataInputStream extends DataInput {
  DataInputStream(Uint8List data) : super.fromUint8List(data);

  int read() {
    return readByte();
  }

  String readString() {
    int length = readInt();
    List<int> bytes = readBytes(length);
    return utf8.decode(bytes);
  }

  List<int> readIntArray() {
    var l = readInt();
    var result = List<int>(l);
    for (int i = 0; i < l; i++) {
      result[i] = readInt();
    }
    return result;
  }

  List<double> readFloatArray() {
    var l = readInt();
    var result = List<double>(l);
    for (int i = 0; i < l; i++) {
      result[i] = readFloat();
    }
    return result;
  }

  List<double> readDoubleArray() {
    var l = readInt();
    var result = List<double>(l);
    for (int i = 0; i < l; i++) {
      result[i] = readDouble();
    }
    return result;
  }
}

class DataOutputStream extends DataOutput {
  void writeString(String input) {
    if (input == null) {
      throw new ArgumentError('Input string cannot be null');
    }
    final List<int> bytesNeeded = utf8.encode(input);
    if (bytesNeeded.length > 65535) {
      // ignore: prefer_const_constructors
      throw new FormatException('Length cannot be greater than 65535');
    }
    writeInt(bytesNeeded.length);
    write(bytesNeeded);
  }

  void writeIntArray(List<int> input) {
    writeInt(input.length);
    for (int i = 0; i < input.length; i++) {
      writeInt(input[i]);
    }
  }

  void writeFloatArray(List<double> input) {
    writeInt(input.length);
    for (int i = 0; i < input.length; i++) {
      writeFloat(input[i]);
    }
  }

  void writeDoubleArray(List<double> input) {
    writeInt(input.length);
    for (int i = 0; i < input.length; i++) {
      writeDouble(input[i]);
    }
  }
}
