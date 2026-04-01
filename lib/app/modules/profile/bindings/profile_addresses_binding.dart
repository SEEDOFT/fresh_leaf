import 'package:fresh_leaf/app/modules/profile/controllers/profile_addresses_controller.dart';
import 'package:get/get.dart';

class ProfileAddressesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileAddressesController>(ProfileAddressesController.new);
  }
}
