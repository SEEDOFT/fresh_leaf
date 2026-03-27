import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/widgets/cart_widget.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const CartHeaderWidget(),
            Expanded(
              child: Obx(() {
                if (controller.items.isEmpty) {
                  return const CartEmptyWidget();
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  itemCount: controller.items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
                    return CartItemCardWidget(
                      item: item,
                      onMinus: () => controller.decreaseQuantity(index),
                      onPlus: () => controller.increaseQuantity(index),
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
                      width: screenWidth,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
