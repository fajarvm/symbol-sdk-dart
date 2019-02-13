library nem2_sdk_dart.sdk.model.blockchain.network_type;

class NetworkType {
  /// Main net network.
  static const int MAIN_NET = 0x68;

  /// Test net network.
  static const int TEST_NET = 0x98;

  /// Mijin net network.
  static const int MIJIN = 0x60;

  /// Mijin test net network.
  static const int MIJIN_TEST = 0x90;

  static bool isValidNetworkType(int networkType) {
    return networkType != null &&
        (networkType == MIJIN_TEST ||
            networkType == MIJIN ||
            networkType == TEST_NET ||
            networkType == MAIN_NET);
  }
}
