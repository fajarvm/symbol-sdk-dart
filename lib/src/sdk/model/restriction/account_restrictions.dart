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

library nem2_sdk_dart.sdk.model.restriction.account_restrictions;

import '../account/address.dart';
import 'account_restriction.dart';

/// Account restrictions structure describes restriction information for an account.
class AccountRestrictions {
  /// The address where the restrictions apply.
  final Address address;

  /// The restrictions.
  final List<AccountRestriction> restrictions;

  AccountRestrictions(this.address, this.restrictions);
}
