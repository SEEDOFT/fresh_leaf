import 'package:get/get.dart';
import '../controllers/profile_personal_details_controller.dart';

class ProfilePersonalDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePersonalDetailsController>(
      () => ProfilePersonalDetailsController(),
    );
  }
}
