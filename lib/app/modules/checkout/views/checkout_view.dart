import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import '../controllers/checkout_controller.dart';
import '../widgets/checkout_widget.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: scheme.onSurface,
          ),
          onPressed: Get.back,
        ),
        title: Text(
          'Checkout',
          style: TextStyle(
            color: scheme.onSurface,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.cart.items.isEmpty) {
          return const CheckoutEmptyWidget();
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          children: [
            CheckoutDeliveryCardWidget(
              onChangeAddress: () => Get.toNamed(AppRoutes.addresses),
            ),
            const SizedBox(height: 14),
            CheckoutPaymentMethodsWidget(
              methods: controller.paymentMethods,
              selectedMethod: controller.selectedPayment.value,
              onSelect: controller.selectPayment,
            ),
            const SizedBox(height: 14),
            Container(
              width: screenWidth - 32,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.grayBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Items',
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
                border: Border.all(color: AppColors.grayBorder),
              ),
              child: TextField(
                controller: controller.noteController,
                minLines: 2,
                maxLines: 3,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add delivery note (optional)',
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
              deliveryFee: controller.deliveryFee,
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
