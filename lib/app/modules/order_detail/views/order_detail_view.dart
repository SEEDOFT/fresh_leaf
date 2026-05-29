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

    return Obx(() {
      return Scaffold(
        backgroundColor: scaffoldBg,
        appBar: CustomAppBar(
          title: controller.order.value == null
              ? 'order_details'.tr
              : 'order_title'.trParams({
                  'number': controller.order.value!.orderNumber,
                }),
        ),
        body: Builder(
          builder: (context) {
            if (controller.isCheckingAccess.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: scheme.primary,
                ),
              );
            }

            final order = controller.order.value;
            if (order == null) {
              if (controller.isLoadingDetails.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: scheme.primary,
                  ),
                );
              }
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
                if (order.deliveryCompanyName != null ||
                    order.preparationProofPhoto != null) ...[
                  const SizedBox(height: 12),
                  OrderDeliveryInfoCard(order: order, width: screenWidth - 32),
                ],
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
                if (order.items.isEmpty && controller.isLoadingDetails.value)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: scheme.primary,
                      ),
                    ),
                  ),
                if (!(order.items.isEmpty && controller.isLoadingDetails.value))
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
                if (order.statusId == 1) ...[
                  // 1 is PENDING
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
                if (order.statusId == 4 || // 4 is DELIVERED
                    order.statusId == 3) ...[
                  // 3 is PREPARING
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
          },
        ),
      );
    });
  }
}
