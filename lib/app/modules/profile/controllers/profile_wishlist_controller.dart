import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/models/product_info.dart';
import 'package:fresh_leaf/shared/helpers/product_share_helper.dart';
import 'package:get/get.dart';

enum WishlistSortType {
  newest,
  priceLowHigh,
  priceHighLow,
  az,
}

class WishlistItem {
  WishlistItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.price,
    required this.tag,
    required this.savedOrder,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final double price;
  final String tag;
  final int savedOrder;
}

class ProfileWishlistController extends GetxController {
  final RxList<WishlistItem> items = <WishlistItem>[
    WishlistItem(
      title: 'Baby Spinach',
      subtitle: '150g fresh pack',
      imageUrl:
          'https://images.unsplash.com/photo-1576045057995-568f588f82fb?q=80&w=900',
      price: 2.90,
      tag: 'Leafy',
      savedOrder: 1,
    ),
    WishlistItem(
      title: 'Organic Avocado',
      subtitle: 'Ready to eat',
      imageUrl:
          'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?q=80&w=900',
      price: 3.40,
      tag: 'Fruit',
      savedOrder: 2,
    ),
    WishlistItem(
      title: 'Heirloom Tomatoes',
      subtitle: 'Farm picked',
      imageUrl:
          'https://images.unsplash.com/photo-1546094096-0df4bcaaa337?q=80&w=900',
      price: 4.20,
      tag: 'Seasonal',
      savedOrder: 3,
    ),
  ].obs;
  final RxString selectedCategory = 'All'.obs;
  final Rx<WishlistSortType> selectedSort = WishlistSortType.newest.obs;

  List<String> get categories {
    const defaults = <String>['All', 'Leafy', 'Fruit', 'Seasonal'];
    final tags = items.map((item) => item.tag).toSet().toList()..sort();
    final merged = <String>[...defaults];
    for (final tag in tags) {
      if (!merged.contains(tag)) {
        merged.add(tag);
      }
    }
    return merged;
  }

  List<WishlistItem> get visibleItems {
    final selected = selectedCategory.value;
    var list = List<WishlistItem>.from(items);
    if (selected != 'All') {
      list = list.where((item) => item.tag == selected).toList();
    }

    switch (selectedSort.value) {
      case WishlistSortType.newest:
        list.sort((a, b) => b.savedOrder.compareTo(a.savedOrder));
      case WishlistSortType.priceLowHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
      case WishlistSortType.priceHighLow:
        list.sort((a, b) => b.price.compareTo(a.price));
      case WishlistSortType.az:
        list.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
    }
    return list;
  }

  bool get hasActiveFilter => selectedCategory.value != 'All';

  String get category => selectedCategory.value;
  set category(String value) {
    selectedCategory.value = value;
  }

  WishlistSortType get sort => selectedSort.value;
  set sort(WishlistSortType value) {
    selectedSort.value = value;
  }

  String sortLabel(WishlistSortType sortType) {
    switch (sortType) {
      case WishlistSortType.newest:
        return 'wishlist_sort_newest'.tr;
      case WishlistSortType.priceLowHigh:
        return 'wishlist_sort_price_low_high'.tr;
      case WishlistSortType.priceHighLow:
        return 'wishlist_sort_price_high_low'.tr;
      case WishlistSortType.az:
        return 'wishlist_sort_az'.tr;
    }
  }

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

  Future<void> openProductDetail(WishlistItem item) async {
    final product = ProductInfo(
      title: item.title,
      subtitle: item.subtitle,
      description: 'seasonal_pick_description'.tr,
      imageUrl: item.imageUrl,
      tags: <String>[item.tag, 'organic'.tr],
      price: item.price,
      origin: 'local_farm'.tr,
      harvest: 'harvested_this_week'.tr,
      storage: 'refrigerate_extend_freshness'.tr,
      shareSlug: ProductShareHelper.resolveSlug(title: item.title),
    );
    await Get.toNamed<void>(
      AppRoutes.productDetail,
      arguments: product.toMap(),
    );
  }
}
