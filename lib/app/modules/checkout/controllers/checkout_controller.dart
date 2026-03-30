import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';

class CheckoutController extends GetxController {
  final CartController cart = Get.find<CartController>();

  final TextEditingController noteController = TextEditingController();

  final RxString selectedPayment = 'Cash on Delivery'.obs;
  final RxBool isPlacingOrder = false.obs;

  final List<String> paymentMethods = const <String>[
    'Cash on Delivery',
    'Credit/Debit Card',
    'ABA Pay',
  ];

  double get subtotal => cart.subtotal;
  double get deliveryFee => cart.deliveryFee;
  double get discount => subtotal >= 25 ? 2.00 : 0.0;
  double get grandTotal => subtotal + deliveryFee - discount;

  int get totalItems => cart.items.fold<int>(
    0,
    (sum, item) => sum + item.quantity,
  );

  void selectPayment(String method) {
    selectedPayment.value = method;
  }

  Future<void> placeOrder() async {
    if (cart.items.isEmpty || isPlacingOrder.value) return;

    isPlacingOrder.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final itemCount = totalItems;
    cart.clearCart();
    isPlacingOrder.value = false;

    if (Get.isRegistered<DashboardController>()) {
      Get.back();
      Get.find<DashboardController>().changeIndex(3);
    } else {
      Get.offNamed(AppRoutes.orders);
    }

    Get.snackbar(
      'Order Confirmed',
      'Your order with $itemCount item${itemCount == 1 ? '' : 's'} is on the way.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.white,
      colorText: Colors.black87,
      borderRadius: 14,
      margin: const EdgeInsets.all(12),
    );
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}
