import 'package:fresh_leaf/app/modules/wishlist/controllers/wishlist_controller.dart';
import 'package:get/get.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WishlistController>(WishlistController.new);
  }
}
