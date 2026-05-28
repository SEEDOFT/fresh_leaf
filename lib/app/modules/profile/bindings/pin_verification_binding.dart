import 'package:fresh_leaf/app/modules/profile/controllers/pin_verification_controller.dart';
import 'package:get/get.dart';

class PinVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PinVerificationController>(
      PinVerificationController.new,
    );
  }
}
