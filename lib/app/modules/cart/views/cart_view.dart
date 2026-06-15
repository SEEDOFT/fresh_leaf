import 'dart:async';

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

                final grouped = controller.groupedItems;
                final entries = grouped.entries.toList();

                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    20.scaled,
                    8.scaled,
                    20.scaled,
                    16.scaled,
                  ),
                  itemCount: entries.length,
                  separatorBuilder: (_, _) => SizedBox(height: 24.scaled),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final vendorItems = entry.value;
                    final vendorName =
                        vendorItems.first.vendorInventory?.vendorName ??
                        'Vendor';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.scaled),
                          child: Row(
                            children: [
                              Icon(
                                Icons.storefront_outlined,
                                size: 20.scaled,
                                color: Get.theme.colorScheme.primary,
                              ),
                              SizedBox(width: 8.scaled),
                              Text(
                                vendorName,
                                style: Get.theme.textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        ...vendorItems.map((item) {
                          final originalIndex = controller.items.indexOf(item);
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: item == vendorItems.last ? 0 : 14.scaled,
                            ),
                            child: CartItemCardWidget(
                              item: item,
                              onMinus: () =>
                                  controller.decreaseQuantity(originalIndex),
                              onPlus: () =>
                                  controller.increaseQuantity(originalIndex),
                              onRemove: () =>
                                  controller.removeItem(originalIndex),
                              onTap: () {
                                if (item.vendorInventory != null) {
                                  unawaited(Get.toNamed<void>(
                                    AppRoutes.productDetail,
                                    arguments: item.vendorInventory,
                                  ));
                                }
                              },
                            ),
                          );
                        }),
                      ],
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
