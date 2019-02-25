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
}
