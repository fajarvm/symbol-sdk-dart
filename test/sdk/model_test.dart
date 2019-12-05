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

// account
import 'model/account/account_info_test.dart' as account_info_test;
import 'model/account/account_names_test.dart' as account_names_test;
import 'model/account/account_test.dart' as account_test;
import 'model/account/account_type_test.dart' as account_type_test;
import 'model/account/address_test.dart' as address_test;
import 'model/account/multisig_account_graph_info_test.dart' as multisig_account_graph_info_test;
import 'model/account/multisig_account_info_test.dart' as multisig_account_info_test;
import 'model/account/public_account_test.dart' as public_account_test;

// blockchain
import 'model/blockchain/block_info_test.dart' as block_info_test;
import 'model/blockchain/blockchain_score_test.dart' as blockchain_score_test;
import 'model/blockchain/blockchain_storage_info_test.dart' as blockchain_storage_info_test;
import 'model/blockchain/network_type_test.dart' as network_type_test;

// common
import 'model/common/id_generator_test.dart' as id_generator_test;
import 'model/common/id_test.dart' as id_test;
import 'model/common/uint64_test.dart' as uint64_test;

// diagnostic
import 'model/diagnostic/server_info_test.dart' as server_info_test;

// message
import 'model/message/encrypted_message_test.dart' as encrypted_message_test;
import 'model/message/message_type_test.dart' as message_type_test;
import 'model/message/persistent_harvesting_delegation_message_test.dart'
    as persistent_harvesting_delegation_message_test;
import 'model/message/plain_message_test.dart' as plain_message_test;


// metadata
import 'model/metadata/metadata_entry_test.dart' as metadata_entry_test;
import 'model/metadata/metadata_test.dart' as metadata_test;
import 'model/metadata/metadata_type_test.dart' as metadata_type_test;

// mosaic
import 'model/mosaic/mosaic_flags_test.dart' as mosaic_flags_test;
import 'model/mosaic/mosaic_id_test.dart' as mosaic_id_test;
import 'model/mosaic/mosaic_info_test.dart' as mosaic_info_test;
import 'model/mosaic/mosaic_names_test.dart' as mosaic_names_test;
import 'model/mosaic/mosaic_nonce_test.dart' as mosaic_nonce_test;
import 'model/mosaic/mosaic_supply_type_test.dart' as mosaic_supply_type_test;
import 'model/mosaic/mosaic_test.dart' as mosaic_test;
import 'model/mosaic/network_currency_mosaic_test.dart' as network_currency_mosaic_test;
import 'model/mosaic/network_harvest_mosaic_test.dart' as network_harvest_mosaic_test;

// namespace
import 'model/namespace/address_alias_test.dart' as address_alias_test;
import 'model/namespace/alias_test.dart' as alias_test;
import 'model/namespace/alias_type_test.dart' as alias_type_test;
import 'model/namespace/empty_alias_test.dart' as empty_alias_test;
import 'model/namespace/mosaic_alias_test.dart' as mosaic_alias_test;
import 'model/namespace/namespace_id_test.dart' as namespace_id_test;
import 'model/namespace/namespace_info_test.dart' as namespace_info_test;
import 'model/namespace/namespace_name_test.dart' as namespace_name_test;
import 'model/namespace/namespace_registration_type_test.dart' as namespace_registration_type_test;

// node
import 'model/node/node_info_test.dart' as node_info_test;
import 'model/node/node_time_test.dart' as node_time_test;
import 'model/node/role_type_test.dart' as role_type_test;

// receipt
import 'model/receipt/artifact_expiry_receipt_test.dart' as artifact_expiry_receipt_test;
import 'model/receipt/balance_change_receipt_test.dart' as balance_change_receipt_test;
import 'model/receipt/balance_transfer_receipt_test.dart' as balance_transfer_receipt_test;
import 'model/receipt/inflation_receipt_test.dart' as inflation_receipt_test;
import 'model/receipt/receipt_source_test.dart' as receipt_source_test;
import 'model/receipt/receipt_type_test.dart' as receipt_type_test;
import 'model/receipt/receipt_version_test.dart' as receipt_version_test;
import 'model/receipt/resolution_entry_test.dart' as resolution_entry_test;
import 'model/receipt/resolution_statement_test.dart' as resolution_statement_test;
import 'model/receipt/resolution_type_test.dart' as resolution_type_test;
import 'model/receipt/statement_test.dart' as statement_test;
import 'model/receipt/transaction_statement_test.dart' as transaction_statement_test;

// restriction
import 'model/restriction/account_restriction_modification_type_test.dart'
    as account_restriction_modification_type_test;
import 'model/restriction/account_restriction_test.dart' as account_restriction_test;
import 'model/restriction/account_restriction_type_test.dart' as account_restriction_type_test;
import 'model/restriction/account_restrictions_info_test.dart' as account_restrictions_info_test;
import 'model/restriction/account_restrictions_test.dart' as account_restrictions_test;

// transaction
import 'model/transaction/deadline_test.dart' as deadline_test;
import 'model/transaction/hash_type_test.dart' as hash_type_test;
import 'model/transaction/signed_transaction_test.dart' as signed_transaction_test;
import 'model/transaction/transaction_info_test.dart' as transaction_info_test;
import 'model/transaction/transaction_test.dart' as transaction_test;
import 'model/transaction/transaction_type_test.dart' as transaction_type_test;
import 'model/transaction/transaction_version_test.dart' as transaction_version_test;
import 'model/transaction/verifiable_transaction_test.dart' as verifiable_transaction_test;

void main() {
  // account
  group('Account:', () {
    account_info_test.main();
    account_names_test.main();
    account_test.main();
    address_test.main();
    account_type_test.main();
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

  // common
  group('Common models:', () {
    id_test.main();
    id_generator_test.main();
    uint64_test.main();
  });

  // diagnostic
  group('Diagnostic models:', () {
    server_info_test.main();
  });

  // message
  group('Message:', () {
    message_type_test.main();
    plain_message_test.main();
    encrypted_message_test.main();
    persistent_harvesting_delegation_message_test.main();
  });

  // metadata
  group('Metadata:', (){
    metadata_type_test.main();
    metadata_entry_test.main();
    metadata_test.main();
  });

  // mosaic
  group('Mosaic:', () {
    mosaic_flags_test.main();
    mosaic_id_test.main();
    mosaic_info_test.main();
    mosaic_names_test.main();
    mosaic_nonce_test.main();
    mosaic_supply_type_test.main();
    mosaic_test.main();
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
    namespace_registration_type_test.main();
  });

  // node
  group('Node:', () {
    node_info_test.main();
    node_time_test.main();
    role_type_test.main();
  });

  // receipt
  group('Receipt:', () {
    artifact_expiry_receipt_test.main();
    balance_change_receipt_test.main();
    balance_transfer_receipt_test.main();
    inflation_receipt_test.main();
    receipt_source_test.main();
    receipt_type_test.main();
    receipt_version_test.main();
    resolution_entry_test.main();
    resolution_statement_test.main();
    resolution_type_test.main();
    statement_test.main();
    transaction_statement_test.main();
  });

  group('Restriction:', () {
    account_restriction_modification_type_test.main();
    account_restriction_test.main();
    account_restriction_type_test.main();
    account_restrictions_info_test.main();
    account_restrictions_test.main();
  });

  // transaction
  group('Transaction:', () {
    deadline_test.main();
    hash_type_test.main();
    signed_transaction_test.main();
    transaction_info_test.main();
    transaction_test.main();
    transaction_type_test.main();
    transaction_version_test.main();
    verifiable_transaction_test.main();
  });
}
