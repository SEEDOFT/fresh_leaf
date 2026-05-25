import 'package:fresh_leaf/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:get/get.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CheckoutController>()) {
      Get.lazyPut<CheckoutController>(CheckoutController.new);
    }
  }
}
