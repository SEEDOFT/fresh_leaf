import 'package:fresh_leaf/app/modules/product_list/controllers/product_list_controller.dart';
import 'package:fresh_leaf/core/services/product_service.dart';
import 'package:get/get.dart';

class ProductListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductListController>(
      () => ProductListController(productService: Get.find<ProductService>()),
    );
  }
}
