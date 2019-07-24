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

library nem2_sdk_dart.sdk.model.namespace.namespace_name;

import 'namespace_id.dart';

/// The namespace name info structure describes basic information of a namespace and name.
class NamespaceName {
  /// The namespace id.
  final NamespaceId namespaceId;

  /// The namespace name.
  final String name;

  /// The parent namespace id. The [parentId] is optional.
  final NamespaceId parentId;

  NamespaceName(this.namespaceId, this.name, [this.parentId]);
}
