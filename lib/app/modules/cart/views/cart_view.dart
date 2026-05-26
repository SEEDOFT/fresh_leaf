import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/cart/controllers/cart_controller.dart';
import 'package:fresh_leaf/app/modules/cart/widgets/cart_widget.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/shared/helpers/responsive_helper.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:get/get.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key, this.asPanel = false});

  final bool asPanel;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scheme = Theme.of(context).colorScheme;

    Future<void> handleCheckout() async {
      if (asPanel) {
        Get.back<void>();
      }
      await Get.toNamed<void>(AppRoutes.checkout);
    }

    final content = Stack(
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
                if (controller.isLoading.value && controller.items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.items.isEmpty) {
                  return const CartEmptyWidget();
                }

                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    20.scaled,
                    8.scaled,
                    20.scaled,
                    16.scaled,
                  ),
                  itemCount: controller.items.length,
                  separatorBuilder: (_, _) => SizedBox(height: 14.scaled),
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
                      total: controller.total,
                      subtotalDisplay: controller.subtotalDisplay,
                      totalDisplay: controller.grandTotalDisplay,
                      itemCount: controller.items.length,
                      width: screenWidth - 20,
                      onCheckout: handleCheckout,
                    ),
            ),
          ],
        ),
      ],
    );

    return AppScaffold(
      scrollable: false,
      padding: EdgeInsets.zero,
      body: content,
    );
  }
}
