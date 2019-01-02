part of nem2_sdk_dart.core.crypto.ed25519;

class Ed25519Curve implements Curve {

  static final Ed25519Curve ED25519 = new Ed25519Curve();

  /// Gets the Ed25519 instance
  static Ed25519Curve ed25519() {
    return ED25519;
  }

  @override
  String getName() {
    return "ed25519";
  }

  @override
  BigInt getGroupOrder() {

  }

  @override
  BigInt getHalfGroupOrder() {

  }
}