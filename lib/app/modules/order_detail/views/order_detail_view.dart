import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/order_detail/controllers/order_detail_controller.dart';
import 'package:fresh_leaf/app/modules/order_detail/widgets/order_detail_widget.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
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
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: scheme.onSurface,
          ),
          onPressed: Get.back<void>,
        ),
        title: Obx(
          () => Text(
            controller.order.value == null
                ? 'order_details'.tr
                : 'Order ${controller.order.value!.id}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
              fontSize: 16,
            ),
          ),
        ),
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
                    final product = controller.toProductInfo(item);
                    await Get.toNamed<void>(
                      AppRoutes.productDetail,
                      arguments: product,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: screenWidth - 32,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  minimumSize: Size(screenWidth - 32, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'reorder_everything'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
