import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/order_detail/controllers/order_detail_controller.dart';
import 'package:fresh_leaf/app/modules/order_detail/widgets/order_detail_widget.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:fresh_leaf/shared/widgets/primary_button.dart';
import 'package:get/get.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: CustomAppBar(
        title: controller.order.value == null
            ? 'order_details'.tr
            : 'Order ${controller.order.value!.orderNumber}',
      ),
      body: Obx(() {
        if (controller.isCheckingAccess.value) {
          return Center(
            child: CircularProgressIndicator(
              color: scheme.primary,
            ),
          );
        }

        final order = controller.order.value;
        if (order == null) {
          return Center(
            child: Text(
              'order_not_found'.tr,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          children: [
            OrderSummaryCard(order: order, width: screenWidth - 32),
            const SizedBox(height: 18),
            Text(
              'ordered_items'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: OrderDetailItemCard(
                  item: item,
                  width: screenWidth - 32,
                  onOpenProduct: () async {
                    final vendorInventory = item.vendorInventory;
                    if (vendorInventory != null) {
                      await Get.toNamed<void>(
                        AppRoutes.productDetail,
                        arguments: vendorInventory,
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            PrimaryButton(
              onPressed: () {},
              label: 'reorder_everything'.tr,
              borderRadius: 14,
              height: 50,
            ),
            if (order.statusName == 'PENDING') ...[
              const SizedBox(height: 12),
              PrimaryButton(
                onPressed: controller.isUpdating.value
                    ? null
                    : controller.cancelOrder,
                label: 'cancel_order'.tr,
                borderRadius: 14,
                height: 50,
                backgroundColor: scheme.errorContainer,
                foregroundColor: scheme.onErrorContainer,
              ),
            ],
            if (order.statusName == 'DELIVERED' ||
                order.statusName == 'PREPARING') ...[
              const SizedBox(height: 12),
              PrimaryButton(
                onPressed: controller.isUpdating.value
                    ? null
                    : controller.confirmReceipt,
                label: 'confirm_receipt'.tr,
                borderRadius: 14,
                height: 50,
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
              ),
            ],
          ],
        );
      }),
    );
  }
}
