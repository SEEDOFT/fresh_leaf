import 'package:fresh_leaf/app/modules/profile/controllers/profile_privacy_controller.dart';
import 'package:get/get.dart';

class ProfilePrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePrivacyController>(ProfilePrivacyController.new);
  }
}
