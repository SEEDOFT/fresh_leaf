import 'package:fresh_leaf/app/modules/order_detail/controllers/order_detail_controller.dart';
import 'package:fresh_leaf/core/services/order_service.dart';
import 'package:fresh_leaf/core/services/storage_service.dart';
import 'package:get/get.dart';

class OrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDetailController>(
      () => OrderDetailController(
        orderService: Get.find<OrderService>(),
        storageService: Get.find<StorageService>(),
      ),
    );
  }
}
