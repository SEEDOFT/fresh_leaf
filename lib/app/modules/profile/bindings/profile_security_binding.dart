import 'package:fresh_leaf/app/modules/profile/controllers/profile_security_controller.dart';
import 'package:get/get.dart';

class ProfileSecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSecurityController>(ProfileSecurityController.new);
  }
}
