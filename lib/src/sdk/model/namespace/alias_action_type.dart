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

library nem2_sdk_dart.sdk.model.namespace.alias_action_type;

/// The alias type.
///
/// The alias action type. Supported actions are:
/// * 0: Link an alias.
/// * 1: Unlink an alias.
class AliasActionType {
  static const String _INVALID_ALIAS_ACTION_TYPE = 'invalid alias action type';

  static const int LINK = 0;

  static const int UNLINK = 1;

  static const AliasActionType _singleton = AliasActionType._();

  const AliasActionType._();

  factory AliasActionType() {
    return _singleton;
  }

  static int getAliasActionType(final int type) {
    switch (type) {
      case LINK:
        return AliasActionType.LINK;
      case UNLINK:
        return AliasActionType.UNLINK;
      default:
        throw new ArgumentError(_INVALID_ALIAS_ACTION_TYPE);
    }
  }
}
