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
import 'model/mosaic/mosaic_name_test.dart' as mosaic_name_test;
import 'model/mosaic/mosaic_properties_test.dart' as mosaic_properties_test;
import 'model/mosaic/mosaic_supply_type_test.dart' as mosaic_supply_type_test;
import 'model/mosaic/mosaic_test.dart' as mosaic_test;
import 'model/mosaic/xem_test.dart' as xem_test;
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
import 'model/transaction/transaction_helper_test.dart' as transaction_helper_test;
import 'model/transaction/transaction_info_test.dart' as transaction_info_test;
import 'model/transaction/transaction_type_test.dart' as transaction_type_test;
import 'model/transaction/uint64_test.dart' as uint64_test;

void main() {
  // account
  account_test.main();
  account_info_test.main();
  address_test.main();
  multisig_account_graph_info_test.main();
  multisig_account_info_test.main();
  public_account_test.main();

  // blockchain
  block_info_test.main();
  blockchain_score_test.main();
  blockchain_storage_info_test.main();
  network_type_test.main();

  // mosaic
  mosaic_test.main();
  mosaic_id_test.main();
  mosaic_info_test.main();
  mosaic_name_test.main();
  mosaic_properties_test.main();
  mosaic_supply_type_test.main();
  xem_test.main();

  // namespace
  namespace_id_test.main();
  namespace_info_test.main();
  namespace_name_test.main();
  namespace_type_test.main();

  // transaction
  deadline_test.main();
  hash_type_test.main();
  id_generator_test.main();
  message_type_test.main();
  plain_message_test.main();
  secure_message_test.main();
  signed_transaction_test.main();
  transaction_helper_test.main();
  transaction_info_test.main();
  transaction_type_test.main();
  uint64_test.main();
}
