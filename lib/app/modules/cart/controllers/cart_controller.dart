import 'dart:async';
import 'package:fresh_leaf/core/models/cart_item.dart' as core_models;
import 'package:fresh_leaf/core/services/cart_service.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final CartService _cartService = Get.find<CartService>();

  final RxList<core_models.CartItem> items = <core_models.CartItem>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    unawaited(fetchCart());
  }

  Future<void> fetchCart() async {
    isLoading.value = true;
    try {
      final fetchedItems = await _cartService.getCart();
      items.assignAll(fetchedItems);
    } finally {
      isLoading.value = false;
    }
  }

  double get subtotal {
    return items.fold(
      0,
      (sum, item) => sum + item.subtotal,
    );
  }

  double get total => subtotal;

  Future<void> increaseQuantity(int index) async {
    final current = items[index];
    final success = await _cartService.updateCartItem(
      current.id,
      current.quantity + 1,
    );
    if (success) {
      await fetchCart();
    }
  }

  Future<void> decreaseQuantity(int index) async {
    final current = items[index];
    if (current.quantity <= 1) {
      final success = await _cartService.removeCartItem(current.id);
      if (success) {
        items.removeAt(index);
      }
      return;
    }
    final success = await _cartService.updateCartItem(
      current.id,
      current.quantity - 1,
    );
    if (success) {
      await fetchCart();
    }
  }

  void clearCart() {
    items.clear();
  }

  Future<void> addToCart(int vendorInventoryId, double quantity) async {
    final success = await _cartService.addToCart(vendorInventoryId, quantity);
    if (success) {
      await fetchCart();
    } else {
      Get.snackbar('error'.tr, 'failed_to_add_to_cart'.tr);
    }
  }
}
