import 'package:fresh_leaf/app/modules/order_detail/controllers/order_detail_controller.dart';
import 'package:get/get.dart';

class OrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDetailController>(OrderDetailController.new);
  }
}
