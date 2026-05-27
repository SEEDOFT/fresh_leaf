import 'package:fresh_leaf/app/modules/vendor_profile/controllers/vendor_profile_controller.dart';
import 'package:get/get.dart';

class VendorProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorProfileController>(
      VendorProfileController.new,
    );
  }
}
