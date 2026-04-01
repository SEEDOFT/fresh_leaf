import 'package:fresh_leaf/app/modules/profile/controllers/profile_pin_password_verify_controller.dart';
import 'package:get/get.dart';

class ProfilePinPasswordVerifyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePinPasswordVerifyController>(
      ProfilePinPasswordVerifyController.new,
    );
  }
}
