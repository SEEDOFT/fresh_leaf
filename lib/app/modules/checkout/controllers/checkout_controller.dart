import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  final CartController cart = Get.find<CartController>();

  final TextEditingController noteController = TextEditingController();

  final RxString _selectedPayment = 'Cash on Delivery'.obs;
  final RxBool isPlacingOrder = false.obs;

  String get selectedPayment => _selectedPayment.value;
  set selectedPayment(String method) => _selectedPayment.value = method;

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

  Future<void> placeOrder() async {
    if (cart.items.isEmpty || isPlacingOrder.value) return;

    isPlacingOrder.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final itemCount = totalItems;
    cart.clearCart();
    isPlacingOrder.value = false;

    if (Get.isRegistered<DashboardController>()) {
      Get.back<void>();
      Get.find<DashboardController>().currentIndex = 3;
    } else {
      await Get.offNamed<void>(AppRoutes.orders);
    }

    Get.snackbar(
      'order_confirmed'.tr,
      (itemCount == 1 ? 'order_on_the_way_one' : 'order_on_the_way_other')
          .trParams({'count': '$itemCount'}),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.surface,
      colorText: Get.theme.colorScheme.onSurface,
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
