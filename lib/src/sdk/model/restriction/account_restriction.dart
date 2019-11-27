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

library nem2_sdk_dart.sdk.model.restriction.account_restriction;

import 'account_restriction_type.dart';

/// Account restriction structure describes restriction information.
class AccountRestriction {
  /// Account restriction type.
  final AccountRestrictionType restrictionType;

  /// Restriction values.
  final List<Object> values;

  AccountRestriction(this.restrictionType, this.values);
}
