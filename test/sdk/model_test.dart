import 'model/account/account_test.dart' as account_test;
import 'model/account/address_test.dart' as address_test;
import 'model/account/public_account_test.dart' as public_account_test;
import 'model/mosaic/mosaic_test.dart' as mosaic_test;
import 'model/mosaic/mosaic_id_test.dart' as mosaic_id_test;

main() {
  account_test.main();
  address_test.main();
  public_account_test.main();
  mosaic_test.main();
  mosaic_id_test.main();
}
