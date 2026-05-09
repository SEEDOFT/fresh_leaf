import 'package:fresh_leaf/app/modules/profile/controllers/profile_wishlist_controller.dart';
import 'package:fresh_leaf/core/services/wishlist_service.dart';
import 'package:get/get.dart';

class ProfileWishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileWishlistController>(
      () => ProfileWishlistController(
        wishlistService: Get.find<WishlistService>(),
      ),
    );
  }
}
