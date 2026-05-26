import 'package:fresh_leaf/app/modules/order_wallet_payment/controllers/order_wallet_payment_controller.dart';
import 'package:get/get.dart';

class OrderWalletPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderWalletPaymentController>(OrderWalletPaymentController.new);
  }
}
