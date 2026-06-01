import 'package:fresh_leaf/app/modules/order_wallet_payment/controllers/order_wallet_payment_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/order_service.dart';
import 'package:get/get.dart';

class OrderWalletPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderWalletPaymentController>(
      () => OrderWalletPaymentController(
        orderService: Get.find<OrderService>(),
        apiClient: Get.find<ApiClient>(),
      ),
    );
  }
}
