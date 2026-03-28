import 'package:get/get.dart';
import '../controllers/profile_addresses_controller.dart';

class ProfileAddressesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileAddressesController>(() => ProfileAddressesController());
  }
}
