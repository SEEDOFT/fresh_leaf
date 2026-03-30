import 'package:get/get.dart';
import '../controllers/profile_wishlist_controller.dart';

class ProfileWishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileWishlistController>(() => ProfileWishlistController());
  }
}
