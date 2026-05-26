import 'package:fresh_leaf/app/modules/order_external_payment/controllers/order_external_payment_controller.dart';
import 'package:get/get.dart';

class OrderExternalPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderExternalPaymentController>(
      OrderExternalPaymentController.new,
    );
  }
}
