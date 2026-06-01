import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/modules/product_detail/controllers/product_detail_controller.dart';
import 'package:fresh_leaf/core/controllers/wishlist_controller.dart';
import 'package:fresh_leaf/core/services/product_service.dart';
import 'package:get/get.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductDetailController>(
      () => ProductDetailController(
        wishlistController: Get.find<WishlistController>(),
        productService: Get.find<ProductService>(),
        cartController: Get.find<CartController>(),
      ),
    );
  }
}
