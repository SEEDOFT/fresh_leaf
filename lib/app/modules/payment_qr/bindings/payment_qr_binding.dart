import 'package:fresh_leaf/app/modules/payment_qr/controllers/payment_qr_controller.dart';
import 'package:get/get.dart';

class PaymentQrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentQrController>(PaymentQrController.new);
  }
}
