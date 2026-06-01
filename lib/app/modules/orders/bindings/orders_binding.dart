import 'package:fresh_leaf/app/modules/orders/controllers/orders_controller.dart';
import 'package:fresh_leaf/core/services/order_service.dart';
import 'package:get/get.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersController>(
      () => OrdersController(orderService: Get.find<OrderService>()),
    );
  }
}
