import 'package:fresh_leaf/app/modules/profile/controllers/profile_settings_controller.dart';
import 'package:get/get.dart';

class ProfileSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSettingsController>(ProfileSettingsController.new);
  }
}
