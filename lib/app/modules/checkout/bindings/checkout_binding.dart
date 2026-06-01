import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:fresh_leaf/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:fresh_leaf/core/services/api_client.dart';
import 'package:fresh_leaf/core/services/cart_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CheckoutController>()) {
      Get.lazyPut<CheckoutController>(
        () => CheckoutController(
          cartController: Get.find<CartController>(),
          cartService: Get.find<CartService>(),
          apiClient: Get.find<ApiClient>(),
          storageService: Get.find<StorageService>(),
          dashboardController: Get.find<DashboardController>(),
        ),
      );
    }
  }
}
