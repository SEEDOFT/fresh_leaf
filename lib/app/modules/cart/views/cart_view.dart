import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/widgets/cart_widget.dart';
import 'package:fresh_leaf/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    void handleCheckout() {
      final totalItems = controller.items.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );

      controller.clearCart();

      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().changeIndex(3);
      } else {
        Get.offNamed(AppRoutes.orders);
      }

      Get.snackbar(
        'Order Placed',
        'Your order for $totalItems item${totalItems == 1 ? '' : 's'} has been placed.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        colorText: AppColors.textDark,
        borderRadius: 14,
        margin: const EdgeInsets.all(12),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -120,
              left: -80,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: AppColors.accentLime.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: -100,
              right: -70,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.accentPeach.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Column(
              children: [
                Obx(
                  () => CartHeaderWidget(
                    itemCount: controller.items.length,
                    onClear: controller.clearCart,
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (controller.items.isEmpty) {
                      return const CartEmptyWidget();
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      itemCount: controller.items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final item = controller.items[index];
                        return CartItemCardWidget(
                          item: item,
                          onMinus: () => controller.decreaseQuantity(index),
                          onPlus: () => controller.increaseQuantity(index),
                          onRemove: () => controller.items.removeAt(index),
                        );
                      },
                    );
                  }),
                ),
                Obx(
                  () => controller.items.isEmpty
                      ? const SizedBox.shrink()
                      : CartSummaryWidget(
                          subtotal: controller.subtotal,
                          deliveryFee: controller.deliveryFee,
                          total: controller.total,
                          itemCount: controller.items.length,
                          width: screenWidth - 20,
                          onCheckout: handleCheckout,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
