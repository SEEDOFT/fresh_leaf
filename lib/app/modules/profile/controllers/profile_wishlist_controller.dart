import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:get/get.dart';

class WishlistItem {
  const WishlistItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
    required this.tag,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final double price;
  final String tag;
}

class ProfileWishlistController extends GetxController {
  final RxList<WishlistItem> items = <WishlistItem>[
    const WishlistItem(
      title: 'Baby Spinach',
      subtitle: '150g fresh pack',
      imageUrl:
          'https://images.unsplash.com/photo-1576045057995-568f588f82fb?q=80&w=900',
      price: 2.90,
      tag: 'Leafy',
    ),
    const WishlistItem(
      title: 'Organic Avocado',
      subtitle: 'Ready to eat',
      imageUrl:
          'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?q=80&w=900',
      price: 3.40,
      tag: 'Fruit',
    ),
    const WishlistItem(
      title: 'Heirloom Tomatoes',
      subtitle: 'Farm picked',
      imageUrl:
          'https://images.unsplash.com/photo-1546094096-0df4bcaaa337?q=80&w=900',
      price: 4.20,
      tag: 'Seasonal',
    ),
  ].obs;

  void removeItem(WishlistItem item) {
    items.remove(item);
    Get.snackbar(
      'removed'.tr,
      'removed_from_wishlist'.trParams({'title': item.title}),
    );
  }

  void addToCart(WishlistItem item) {
    if (!Get.isRegistered<CartController>()) {
      Get.snackbar('unavailable'.tr, 'cart_not_ready'.tr);
      return;
    }

    Get.find<CartController>().addOrIncrementItem(
      title: item.title,
      subtitle: item.subtitle,
      imageUrl: item.imageUrl,
      price: item.price,
    );
    Get.snackbar(
      'added_to_cart'.tr,
      'added_to_cart_message'.trParams({'title': item.title}),
    );
  }
}
