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

library nem2_sdk_dart.sdk.api;

import 'model.dart';

dynamic resolve(dynamic object) {
  // TODO: create a function to resolve an object
}

/// Format the given parameter object into string.
String parameterToString(dynamic value) {
  if (value == null) {
    return '';
  } else if (value is DateTime) {
    return value.toUtc().toIso8601String();
  } else if (value is AccountRestrictionTypeEnum) {
    return AccountRestrictionTypeEnum.encode(value).toString();
  } else if (value is AliasTypeEnum) {
    return AliasTypeEnum.encode(value).toString();
  } else if (value is MosaicPropertyIdEnum) {
    return MosaicPropertyIdEnum.encode(value).toString();
  } else if (value is NamespaceTypeEnum) {
    return NamespaceTypeEnum.encode(value).toString();
  } else if (value is RolesTypeEnum) {
    return RolesTypeEnum.encode(value).toString();
  } else {
    return value.toString();
  }
}
