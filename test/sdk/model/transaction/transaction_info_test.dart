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

library nem2_sdk_dart.test.sdk.model.transaction.transaction_info_test;

import 'package:test/test.dart';

import 'package:nem2_sdk_dart/sdk.dart' show TransactionInfo, Uint64;

void main() {
  group('TransactionInfo', () {
    test('Can create a transaction info for transactions as retrieved by listener', () {
      final transactionInfo = TransactionInfo.create(
          Uint64(121855),
          'B6C7648A3DDF71415650805E9E7801424FE03BBEE7D21F9C57B60220D3E95B2F',
          'B6C7648A3DDF71415650805E9E7801424FE03BBEE7D21F9C57B60220D3E95B2F');

      expect(transactionInfo.height, equals(Uint64(121855)));
      expect(transactionInfo.index, isNull);
      expect(transactionInfo.aggregateHash, isNull);
      expect(transactionInfo.aggregateId, isNull);
      expect(transactionInfo.hash, isNotEmpty);
      expect(transactionInfo.hash,
          equals('B6C7648A3DDF71415650805E9E7801424FE03BBEE7D21F9C57B60220D3E95B2F'));
      expect(transactionInfo.merkleComponentHash, isNotEmpty);
      expect(transactionInfo.merkleComponentHash,
          equals('B6C7648A3DDF71415650805E9E7801424FE03BBEE7D21F9C57B60220D3E95B2F'));
    });

    test('Can create a transaction info for standalone transactions', () {
      final transactionInfo = TransactionInfo.create(
          Uint64(121855),
          'B6C7648A3DDF71415650805E9E7801424FE03BBEE7D21F9C57B60220D3E95B2F',
          'B6C7648A3DDF71415650805E9E7801424FE03BBEE7D21F9C57B60220D3E95B2F',
          index: 1,
          id: '5A3D23889CD1E800015929A9');

      expect(transactionInfo.height, equals(Uint64(121855)));
      expect(transactionInfo.aggregateHash, isNull);
      expect(transactionInfo.aggregateId, isNull);
      expect(transactionInfo.hash, isNotEmpty);
      expect(transactionInfo.hash,
          equals('B6C7648A3DDF71415650805E9E7801424FE03BBEE7D21F9C57B60220D3E95B2F'));
      expect(transactionInfo.merkleComponentHash, isNotEmpty);
      expect(transactionInfo.merkleComponentHash,
          equals('B6C7648A3DDF71415650805E9E7801424FE03BBEE7D21F9C57B60220D3E95B2F'));
      expect(transactionInfo.id, isNotEmpty);
      expect(transactionInfo.id, equals('5A3D23889CD1E800015929A9'));
      expect(transactionInfo.index, isNotNull);
      expect(transactionInfo.index, 1);
    });

    test('Can create a transaction info for aggregate inner transactions', () {
      final transactionInfo = TransactionInfo.createAggregate(
          Uint64(121855),
          1,
          '5A3D23889CD1E800015929A9',
          '3D28C804EDD07D5A728E5C5FFEC01AB07AFA5766AE6997B38526D36015A4D006',
          '5A0069D83F17CF0001777E55');

      expect(transactionInfo.height, equals(Uint64(121855)));
      expect(transactionInfo.hash, isNull);
      expect(transactionInfo.merkleComponentHash, isNull);
      expect(transactionInfo.index, isNotNull);
      expect(transactionInfo.index, 1);
      expect(transactionInfo.id, isNotEmpty);
      expect(transactionInfo.id, equals('5A3D23889CD1E800015929A9'));
      expect(transactionInfo.aggregateId, isNotEmpty);
      expect(transactionInfo.aggregateId, equals('5A0069D83F17CF0001777E55'));
      expect(transactionInfo.aggregateHash, isNotEmpty);
      expect(transactionInfo.aggregateHash,
          equals('3D28C804EDD07D5A728E5C5FFEC01AB07AFA5766AE6997B38526D36015A4D006'));
    });
  });
}
