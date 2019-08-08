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

class ApiException implements Exception {
  int code = 0;
  String message;
  Exception innerException;
  StackTrace stackTrace;

  ApiException(this.code, this.message);

  ApiException.withInner(this.code, this.message, this.innerException, this.stackTrace);

  @override
  String toString() {
    if (message == null) return 'ApiException';

    if (innerException == null) {
      return 'ApiException $code: $message';
    }

    return 'ApiException $code: $message (Inner exception: $innerException)'
        '\n'
        '\n'
        '${stackTrace.toString()}';
  }
}
