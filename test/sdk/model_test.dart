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

import 'package:test/test.dart';

import 'model/account/account_info_test.dart' as account_info_test;
import 'model/account/account_test.dart' as account_test;
import 'model/account/address_test.dart' as address_test;
import 'model/account/multisig_account_graph_info_test.dart' as multisig_account_graph_info_test;
import 'model/account/multisig_account_info_test.dart' as multisig_account_info_test;
import 'model/account/public_account_test.dart' as public_account_test;
import 'model/blockchain/block_info_test.dart' as block_info_test;
import 'model/blockchain/blockchain_score_test.dart' as blockchain_score_test;
import 'model/blockchain/blockchain_storage_info_test.dart' as blockchain_storage_info_test;
import 'model/blockchain/network_type_test.dart' as network_type_test;
import 'model/mosaic/mosaic_id_test.dart' as mosaic_id_test;
import 'model/mosaic/mosaic_info_test.dart' as mosaic_info_test;
import 'model/mosaic/mosaic_nonce_test.dart' as mosaic_nonce_test;
import 'model/mosaic/mosaic_properties_test.dart' as mosaic_properties_test;
import 'model/mosaic/mosaic_supply_type_test.dart' as mosaic_supply_type_test;
import 'model/mosaic/mosaic_test.dart' as mosaic_test;
import 'model/mosaic/network_currency_mosaic_test.dart' as network_currency_mosaic_test;
import 'model/mosaic/network_harvest_mosaic_test.dart' as network_harvest_mosaic_test;
import 'model/namespace/address_alias_test.dart' as address_alias_test;
import 'model/namespace/alias_test.dart' as alias_test;
import 'model/namespace/alias_type_test.dart' as alias_type_test;
import 'model/namespace/empty_alias_test.dart' as empty_alias_test;
import 'model/namespace/mosaic_alias_test.dart' as mosaic_alias_test;
import 'model/namespace/namespace_id_test.dart' as namespace_id_test;
import 'model/namespace/namespace_info_test.dart' as namespace_info_test;
import 'model/namespace/namespace_name_test.dart' as namespace_name_test;
import 'model/namespace/namespace_type_test.dart' as namespace_type_test;
import 'model/transaction/deadline_test.dart' as deadline_test;
import 'model/transaction/hash_type_test.dart' as hash_type_test;
import 'model/transaction/id_generator_test.dart' as id_generator_test;
import 'model/transaction/messages/message_type_test.dart' as message_type_test;
import 'model/transaction/messages/plain_message_test.dart' as plain_message_test;
import 'model/transaction/messages/secure_message_test.dart' as secure_message_test;
import 'model/transaction/signed_transaction_test.dart' as signed_transaction_test;
import 'model/transaction/transaction_info_test.dart' as transaction_info_test;
import 'model/transaction/transaction_test.dart' as transaction_test;
import 'model/transaction/transaction_type_test.dart' as transaction_type_test;
import 'model/transaction/transaction_version_test.dart' as transaction_version_test;
import 'model/transaction/uint64_test.dart' as uint64_test;
import 'model/transaction/verifiable_transaction_test.dart' as verifiable_transaction_test;

void main() {
  // account
  group('Account:', () {
    account_test.main();
    account_info_test.main();
    address_test.main();
    multisig_account_graph_info_test.main();
    multisig_account_info_test.main();
    public_account_test.main();
  });

  // blockchain
  group('Blockchain:', () {
    block_info_test.main();
    blockchain_score_test.main();
    blockchain_storage_info_test.main();
    network_type_test.main();
  });

  // mosaic
  group('Mosaic:', () {
    mosaic_test.main();
    mosaic_id_test.main();
    mosaic_info_test.main();
    mosaic_nonce_test.main();
    mosaic_properties_test.main();
    mosaic_supply_type_test.main();
    network_currency_mosaic_test.main();
    network_harvest_mosaic_test.main();
  });

  // namespace
  group('Namespace:', () {
    address_alias_test.main();
    alias_test.main();
    alias_type_test.main();
    empty_alias_test.main();
    mosaic_alias_test.main();
    namespace_id_test.main();
    namespace_info_test.main();
    namespace_name_test.main();
    namespace_type_test.main();
  });

  // transaction
  group('Transaction:', () {
    deadline_test.main();
    hash_type_test.main();
    id_generator_test.main();
    message_type_test.main();
    plain_message_test.main();
    secure_message_test.main();
    signed_transaction_test.main();
    transaction_info_test.main();
    transaction_test.main();
    transaction_type_test.main();
    transaction_version_test.main();
    uint64_test.main();
    verifiable_transaction_test.main();
  });
}
