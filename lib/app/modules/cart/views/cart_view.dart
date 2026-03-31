import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/widgets/cart_widget.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key, this.asPanel = false});

  final bool asPanel;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    void handleCheckout() {
      if (asPanel) {
        Get.back();
      }
      Get.toNamed(AppRoutes.checkout);
    }

    final content = SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: scheme.primaryContainer.withValues(alpha: 0.26),
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
                color: scheme.secondaryContainer.withValues(alpha: 0.42),
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
    );

    if (asPanel) {
      return Material(
        color: scaffoldBg,
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: content,
    );
  }
}
