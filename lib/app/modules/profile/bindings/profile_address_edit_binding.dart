import 'package:get/get.dart';

import '../controllers/profile_address_edit_controller.dart';

class ProfileAddressEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileAddressEditController>(
      () => ProfileAddressEditController(),
    );
  }
}
