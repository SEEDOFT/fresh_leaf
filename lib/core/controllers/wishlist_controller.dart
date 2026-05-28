import 'dart:async';

import 'package:fresh_leaf/core/mixins/paginated_list_mixin.dart';
import 'package:fresh_leaf/core/models/paginated_response.dart';
import 'package:fresh_leaf/core/models/vendor_inventory.dart';
import 'package:fresh_leaf/core/services/wishlist_service.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController
    with PaginatedListMixin<VendorInventory> {
  WishlistController({required this.wishlistService});

  final WishlistService wishlistService;

  @override
  Future<PaginatedResponse<VendorInventory>> fetchPage(int page) {
    return wishlistService.getWishlist(page: page);
  }

  Future<void> fetchWishlist() async {
    await refreshList();
  }

  Future<void> toggleWishlist(VendorInventory product) async {
    final isFav = isFavorite(product.id);

    // Optimistic UI update
    if (isFav) {
      items.removeWhere((item) => item.id == product.id);
    } else {
      items.add(product);
    }

    final success = await wishlistService.toggleWishlist(product.id);

    if (!success) {
      // Revert if failed
      if (isFav) {
        items.add(product);
      } else {
        items.removeWhere((item) => item.id == product.id);
      }
      Get.snackbar('error'.tr, 'failed_to_update_wishlist'.tr);
    }
  }

  bool isFavorite(int id) {
    return items.any((item) => item.id == id);
  }
}
