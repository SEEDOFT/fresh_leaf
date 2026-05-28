import 'dart:async';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/controllers/wishlist_controller.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/services/wishlist_service.dart';
import 'package:get/get.dart';

enum WishlistSortType {
  newest,
  priceLowHigh,
  priceHighLow,
  az,
}

class ProfileWishlistController extends GetxController {
  ProfileWishlistController({required this.wishlistService}) {
    wishlistController = Get.find<WishlistController>();
  }
  final WishlistService wishlistService;
  late final WishlistController wishlistController;

  final RxString selectedCategory = 'All'.obs;
  final Rx<WishlistSortType> selectedSort = WishlistSortType.newest.obs;

  List<VendorInventory> get items => wishlistController.items;
  bool get isLoading => wishlistController.isLoading.value;

  List<String> get categories {
    const defaults = <String>['All'];
    final tags =
        items
            .map((item) => item.certificationType ?? '')
            .where((e) => e.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    return [...defaults, ...tags];
  }

  List<VendorInventory> get visibleItems {
    final selected = selectedCategory.value;
    var list = List<VendorInventory>.from(items);
    if (selected != 'All') {
      list = list.where((item) => item.certificationType == selected).toList();
    }

    switch (selectedSort.value) {
      case WishlistSortType.newest:
        list.sort((a, b) => b.id.compareTo(a.id));
      case WishlistSortType.priceLowHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
      case WishlistSortType.priceHighLow:
        list.sort((a, b) => b.price.compareTo(a.price));
      case WishlistSortType.az:
        list.sort(
          (a, b) => a.displayTitle.toLowerCase().compareTo(
            b.displayTitle.toLowerCase(),
          ),
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

  Future<void> removeItem(VendorInventory item) async {
    await wishlistController.toggleWishlist(item);
  }

  void addToCart(VendorInventory item) {
    if (!Get.isRegistered<CartController>()) {
      Get.snackbar('unavailable'.tr, 'cart_not_ready'.tr);
      return;
    }

    unawaited(Get.find<CartController>().addToCart(item.id, 1));
    Get.snackbar(
      'added_to_cart'.tr,
      'added_to_cart_message'.trParams({'title': item.displayTitle}),
    );
  }

  Future<void> openProductDetail(VendorInventory item) async {
    await Get.toNamed<void>(
      AppRoutes.productDetail,
      arguments: item,
    );
  }
}
