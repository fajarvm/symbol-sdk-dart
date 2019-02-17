import 'core/crypto_test.dart' as crypto_test;
import 'core/utils_test.dart' as utils_test;

import 'sdk/model_test.dart' as model_test;

void main() {
  // core tests
  crypto_test.main();
  utils_test.main();

  // sdk tests
  model_test.main();
}
