import 'package:fresh_leaf/app/modules/profile/controllers/profile_personal_details_controller.dart';
import 'package:get/get.dart';

class ProfilePersonalDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePersonalDetailsController>(
      ProfilePersonalDetailsController.new,
    );
  }
}
