import 'package:fresh_leaf/app/modules/profile/controllers/profile_pin_controller.dart';
import 'package:get/get.dart';

class ProfilePinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePinController>(ProfilePinController.new);
  }
}
