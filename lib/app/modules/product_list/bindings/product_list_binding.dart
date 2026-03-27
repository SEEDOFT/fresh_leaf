import 'package:get/get.dart';
import 'package:fresh_leaf/app/modules/product_list/controllers/product_list_controller.dart';

class ProductListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductListController>(
      () => ProductListController(),
    );
  }
}
