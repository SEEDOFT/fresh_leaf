import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/controllers/wishlist_controller.dart';
import 'package:fresh_leaf/core/models/product_info.dart';
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

  List<ProductInfo> get items => wishlistController.items;
  bool get isLoading => wishlistController.isLoading;

  List<String> get categories {
    const defaults = <String>['All'];
    final tags = items.expand((item) => item.tags).toSet().toList()..sort();
    return [...defaults, ...tags];
  }

  List<ProductInfo> get visibleItems {
    final selected = selectedCategory.value;
    var list = List<ProductInfo>.from(items);
    if (selected != 'All') {
      list = list.where((item) => item.tags.contains(selected)).toList();
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

  Future<void> removeItem(ProductInfo item) async {
    await wishlistController.toggleWishlist(item);
  }

  void addToCart(ProductInfo item) {
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

  Future<void> openProductDetail(ProductInfo item) async {
    await Get.toNamed<void>(
      AppRoutes.productDetail,
      arguments: item,
    );
  }
}
