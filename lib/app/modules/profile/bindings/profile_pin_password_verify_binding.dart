import 'package:get/get.dart';
import '../controllers/profile_pin_password_verify_controller.dart';

class ProfilePinPasswordVerifyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePinPasswordVerifyController>(
      () => ProfilePinPasswordVerifyController(),
    );
  }
}
