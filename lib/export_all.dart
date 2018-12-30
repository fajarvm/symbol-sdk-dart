/**
 * Organizing a library package
 *
 * Library packages are easiest to maintain, extend, and test when you create small,
 * individual libraries, referred to as mini libraries. In most cases, each class
 * should be in its own mini library, unless you have a situation where two classes
 * are tightly coupled.
 *
 * Note: You may have heard of the part directive, which allows you to split a library
 * into multiple Dart files. We recommend that you avoid using part and create mini libraries instead.
 *
 * Create a “main” library file directly under lib, lib/<package-name>.dart, that exports all of the public APIs.
 * This allows the user to get all of a library’s functionality by importing a single file.
 */

/// This the main library that exports all classes of the NEM2 SDK Dart project.
library nem2_sdk_dart.export_all;

/// Export any libraries intended for clients of this package.
export "package:nem2_sdk_dart/core.dart";
export "package:nem2_sdk_dart/sdk.dart";