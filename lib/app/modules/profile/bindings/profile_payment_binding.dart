import 'package:fresh_leaf/app/modules/profile/controllers/profile_payment_controller.dart';
import 'package:get/get.dart';

class ProfilePaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilePaymentController>(ProfilePaymentController.new);
  }
}
