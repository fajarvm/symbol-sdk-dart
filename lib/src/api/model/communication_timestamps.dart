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

class CommunicationTimestamps {
  UInt64DTO sendTimestamp;

  UInt64DTO receiveTimestamp;

  CommunicationTimestamps();

  @override
  String toString() {
    return 'CommunicationTimestamps[sendTimestamp=$sendTimestamp, receiveTimestamp=$receiveTimestamp, ]';
  }

  CommunicationTimestamps.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    sendTimestamp = new UInt64DTO.fromJson(json['sendTimestamp']);
    receiveTimestamp = new UInt64DTO.fromJson(json['receiveTimestamp']);
  }

  Map<String, dynamic> toJson() {
    return {'sendTimestamp': sendTimestamp, 'receiveTimestamp': receiveTimestamp};
  }

  static List<CommunicationTimestamps> listFromJson(List<dynamic> json) {
    return json == null
        ? <CommunicationTimestamps>[]
        : json.map((value) => new CommunicationTimestamps.fromJson(value)).toList();
  }

  static Map<String, CommunicationTimestamps> mapFromJson(Map<String, Map<String, dynamic>> json) {
    var map = <String, CommunicationTimestamps>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((key, value) => map[key] = new CommunicationTimestamps.fromJson(value));
    }
    return map;
  }
}
