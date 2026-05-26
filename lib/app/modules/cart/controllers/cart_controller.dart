import 'dart:async';

import 'package:fresh_leaf/core/models/cart_item.dart' as core_models;
import 'package:fresh_leaf/core/models/money_display.dart';
import 'package:fresh_leaf/core/services/cart_service.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final CartService _cartService = Get.find<CartService>();

  final RxList<core_models.CartItem> items = <core_models.CartItem>[].obs;
  final Rx<MoneyDisplay> totalDisplay = MoneyDisplay.empty.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    unawaited(fetchCart());
  }

  Future<void> fetchCart() async {
    isLoading.value = true;
    try {
      final snapshot = await _cartService.getCartSnapshot();
      items.assignAll(snapshot.items);
      totalDisplay.value = snapshot.totalDisplay;
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

  MoneyDisplay get subtotalDisplay {
    if (!totalDisplay.value.isEmpty) return totalDisplay.value;
    return items.fold<MoneyDisplay>(
      MoneyDisplay.empty,
      (sum, item) => MoneyDisplay(
        usd: sum.usd + item.resolvedSubtotalDisplay.usd,
        khr: sum.khr + item.resolvedSubtotalDisplay.khr,
      ),
    );
  }

  MoneyDisplay get grandTotalDisplay => subtotalDisplay;

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
    totalDisplay.value = MoneyDisplay.empty;
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
