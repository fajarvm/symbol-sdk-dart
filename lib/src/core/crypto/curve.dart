part of nem2_sdk_dart.core.crypto;

/// Interface for getting information for a curve
abstract class Curve {

  /// Returns the name of the curve
  String getName();

  /// Returns the group order
  BigInt getGroupOrder();

  /// Returns the group order / 2
  BigInt getHalfGroupOrder();
}