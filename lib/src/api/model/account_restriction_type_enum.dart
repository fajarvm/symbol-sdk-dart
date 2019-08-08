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

part of nem2_sdk_dart.sdk.api.model;

class AccountRestrictionTypeEnum {
  /// The underlying value of this enum member.
  int value;

  AccountRestrictionTypeEnum._internal(this.value);

  /// Type of account restriction: * 0x01 (1 decimal) - Allow only incoming transactions from a given address. * 0x02 (2 decimal) - Allow only incoming transactions containing a given mosaic identifier. * 0x05 (5 decimal) - Account restriction sentinel. * 0x41 (65 decimal) - Allow only outgoing transactions to a given address. * 0x44 (68 decimal) - Allow only outgoing transactions with a given transaction type. * 0x81 (129 decimal) - Block incoming transactions from a given address. * 0x82 (130 decimal) - Block incoming transactions containing a given mosaic identifier. * 0xC1 (193 decimal) - Block outgoing transactions to a given address. * 0xC4 (196 decimal) - Block outgoing transactions with a given transaction type.
  static AccountRestrictionTypeEnum number1_ = AccountRestrictionTypeEnum._internal(1);

  /// Type of account restriction: * 0x01 (1 decimal) - Allow only incoming transactions from a given address. * 0x02 (2 decimal) - Allow only incoming transactions containing a given mosaic identifier. * 0x05 (5 decimal) - Account restriction sentinel. * 0x41 (65 decimal) - Allow only outgoing transactions to a given address. * 0x44 (68 decimal) - Allow only outgoing transactions with a given transaction type. * 0x81 (129 decimal) - Block incoming transactions from a given address. * 0x82 (130 decimal) - Block incoming transactions containing a given mosaic identifier. * 0xC1 (193 decimal) - Block outgoing transactions to a given address. * 0xC4 (196 decimal) - Block outgoing transactions with a given transaction type.
  static AccountRestrictionTypeEnum number2_ = AccountRestrictionTypeEnum._internal(2);

  /// Type of account restriction: * 0x01 (1 decimal) - Allow only incoming transactions from a given address. * 0x02 (2 decimal) - Allow only incoming transactions containing a given mosaic identifier. * 0x05 (5 decimal) - Account restriction sentinel. * 0x41 (65 decimal) - Allow only outgoing transactions to a given address. * 0x44 (68 decimal) - Allow only outgoing transactions with a given transaction type. * 0x81 (129 decimal) - Block incoming transactions from a given address. * 0x82 (130 decimal) - Block incoming transactions containing a given mosaic identifier. * 0xC1 (193 decimal) - Block outgoing transactions to a given address. * 0xC4 (196 decimal) - Block outgoing transactions with a given transaction type.
  static AccountRestrictionTypeEnum number5_ = AccountRestrictionTypeEnum._internal(5);

  /// Type of account restriction: * 0x01 (1 decimal) - Allow only incoming transactions from a given address. * 0x02 (2 decimal) - Allow only incoming transactions containing a given mosaic identifier. * 0x05 (5 decimal) - Account restriction sentinel. * 0x41 (65 decimal) - Allow only outgoing transactions to a given address. * 0x44 (68 decimal) - Allow only outgoing transactions with a given transaction type. * 0x81 (129 decimal) - Block incoming transactions from a given address. * 0x82 (130 decimal) - Block incoming transactions containing a given mosaic identifier. * 0xC1 (193 decimal) - Block outgoing transactions to a given address. * 0xC4 (196 decimal) - Block outgoing transactions with a given transaction type.
  static AccountRestrictionTypeEnum number65_ = AccountRestrictionTypeEnum._internal(65);

  /// Type of account restriction: * 0x01 (1 decimal) - Allow only incoming transactions from a given address. * 0x02 (2 decimal) - Allow only incoming transactions containing a given mosaic identifier. * 0x05 (5 decimal) - Account restriction sentinel. * 0x41 (65 decimal) - Allow only outgoing transactions to a given address. * 0x44 (68 decimal) - Allow only outgoing transactions with a given transaction type. * 0x81 (129 decimal) - Block incoming transactions from a given address. * 0x82 (130 decimal) - Block incoming transactions containing a given mosaic identifier. * 0xC1 (193 decimal) - Block outgoing transactions to a given address. * 0xC4 (196 decimal) - Block outgoing transactions with a given transaction type.
  static AccountRestrictionTypeEnum number68_ = AccountRestrictionTypeEnum._internal(68);

  /// Type of account restriction: * 0x01 (1 decimal) - Allow only incoming transactions from a given address. * 0x02 (2 decimal) - Allow only incoming transactions containing a given mosaic identifier. * 0x05 (5 decimal) - Account restriction sentinel. * 0x41 (65 decimal) - Allow only outgoing transactions to a given address. * 0x44 (68 decimal) - Allow only outgoing transactions with a given transaction type. * 0x81 (129 decimal) - Block incoming transactions from a given address. * 0x82 (130 decimal) - Block incoming transactions containing a given mosaic identifier. * 0xC1 (193 decimal) - Block outgoing transactions to a given address. * 0xC4 (196 decimal) - Block outgoing transactions with a given transaction type.
  static AccountRestrictionTypeEnum number129_ = AccountRestrictionTypeEnum._internal(129);

  /// Type of account restriction: * 0x01 (1 decimal) - Allow only incoming transactions from a given address. * 0x02 (2 decimal) - Allow only incoming transactions containing a given mosaic identifier. * 0x05 (5 decimal) - Account restriction sentinel. * 0x41 (65 decimal) - Allow only outgoing transactions to a given address. * 0x44 (68 decimal) - Allow only outgoing transactions with a given transaction type. * 0x81 (129 decimal) - Block incoming transactions from a given address. * 0x82 (130 decimal) - Block incoming transactions containing a given mosaic identifier. * 0xC1 (193 decimal) - Block outgoing transactions to a given address. * 0xC4 (196 decimal) - Block outgoing transactions with a given transaction type.
  static AccountRestrictionTypeEnum number130_ = AccountRestrictionTypeEnum._internal(130);

  /// Type of account restriction: * 0x01 (1 decimal) - Allow only incoming transactions from a given address. * 0x02 (2 decimal) - Allow only incoming transactions containing a given mosaic identifier. * 0x05 (5 decimal) - Account restriction sentinel. * 0x41 (65 decimal) - Allow only outgoing transactions to a given address. * 0x44 (68 decimal) - Allow only outgoing transactions with a given transaction type. * 0x81 (129 decimal) - Block incoming transactions from a given address. * 0x82 (130 decimal) - Block incoming transactions containing a given mosaic identifier. * 0xC1 (193 decimal) - Block outgoing transactions to a given address. * 0xC4 (196 decimal) - Block outgoing transactions with a given transaction type.
  static AccountRestrictionTypeEnum number193_ = AccountRestrictionTypeEnum._internal(193);

  /// Type of account restriction: * 0x01 (1 decimal) - Allow only incoming transactions from a given address. * 0x02 (2 decimal) - Allow only incoming transactions containing a given mosaic identifier. * 0x05 (5 decimal) - Account restriction sentinel. * 0x41 (65 decimal) - Allow only outgoing transactions to a given address. * 0x44 (68 decimal) - Allow only outgoing transactions with a given transaction type. * 0x81 (129 decimal) - Block incoming transactions from a given address. * 0x82 (130 decimal) - Block incoming transactions containing a given mosaic identifier. * 0xC1 (193 decimal) - Block outgoing transactions to a given address. * 0xC4 (196 decimal) - Block outgoing transactions with a given transaction type.
  static AccountRestrictionTypeEnum number196_ = AccountRestrictionTypeEnum._internal(196);

  AccountRestrictionTypeEnum.fromJson(dynamic data) {
    switch (data) {
      case 1:
        value = data;
        break;
      case 2:
        value = data;
        break;
      case 5:
        value = data;
        break;
      case 65:
        value = data;
        break;
      case 68:
        value = data;
        break;
      case 129:
        value = data;
        break;
      case 130:
        value = data;
        break;
      case 193:
        value = data;
        break;
      case 196:
        value = data;
        break;
      default:
        throw ArgumentError('Unknown enum value to decode: $data');
    }
  }

  static dynamic encode(AccountRestrictionTypeEnum data) {
    return data.value;
  }
}
