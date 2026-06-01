import 'package:fresh_leaf/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:fresh_leaf/app/modules/order_external_payment/controllers/order_external_payment_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:get/get.dart';

class OrderExternalPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderExternalPaymentController>(
      () => OrderExternalPaymentController(
        apiClient: Get.find<ApiClient>(),
        dashboardController: Get.find<DashboardController>(),
      ),
    );
  }
}
