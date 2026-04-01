import 'package:fresh_leaf/app/modules/profile/controllers/profile_wishlist_controller.dart';
import 'package:get/get.dart';

class ProfileWishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileWishlistController>(ProfileWishlistController.new);
  }
}
