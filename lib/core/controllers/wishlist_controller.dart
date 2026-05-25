import 'dart:async';

import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/services/wishlist_service.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  WishlistController({required this.wishlistService});

  final WishlistService wishlistService;

  final RxList<VendorInventory> _items = <VendorInventory>[].obs;
  final RxBool _isLoading = false.obs;

  List<VendorInventory> get items => _items;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    unawaited(fetchWishlist());
  }

  Future<void> fetchWishlist() async {
    _isLoading.value = true;
    try {
      final result = await wishlistService.getWishlist();
      _items.assignAll(result);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> toggleWishlist(VendorInventory product) async {
    final isFav = isFavorite(product.id);

    // Optimistic UI update
    if (isFav) {
      _items.removeWhere((item) => item.id == product.id);
    } else {
      _items.add(product);
    }

    final success = await wishlistService.toggleWishlist(product.id);

    if (!success) {
      // Revert if failed
      if (isFav) {
        _items.add(product);
      } else {
        _items.removeWhere((item) => item.id == product.id);
      }
      Get.snackbar('error'.tr, 'failed_to_update_wishlist'.tr);
    }
  }

  bool isFavorite(int id) {
    return _items.any((item) => item.id == id);
  }
}
