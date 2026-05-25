import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:fresh_leaf/app/modules/checkout/widgets/checkout_widget.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:get/get.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scheme = Theme.of(context).colorScheme;

    return AppScaffold(
      appBar: CustomAppBar(title: 'checkout'.tr),
      body: Obx(() {
        if (controller.cart.items.isEmpty) {
          return const CheckoutEmptyWidget();
        }

        return Column(
          children: [
            Obx(
              () => CheckoutDeliveryCardWidget(
                address: controller.deliveryAddress.value,
                onChangeAddress: controller.changeDeliveryAddress,
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => CheckoutPaymentMethodsWidget(
                options: controller.paymentOptions,
                selectedOptionId: controller.selectedOptionId.value,
                onSelect: controller.selectPaymentOption,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: screenWidth - 32,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: scheme.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'order_items'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...controller.cart.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CheckoutItemRowWidget(item: item),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: screenWidth - 32,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: scheme.outline),
              ),
              child: TextField(
                controller: controller.noteController,
                minLines: 2,
                maxLines: 3,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'delivery_note_hint'.tr,
                  hintStyle: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            CheckoutSummaryCardWidget(
              subtotal: controller.subtotal,
              discount: controller.discount,
              total: controller.grandTotal,
              isPlacingOrder: controller.isPlacingOrder.value,
              onPlaceOrder: controller.placeOrder,
            ),
          ],
        );
      }),
    );
  }
}
