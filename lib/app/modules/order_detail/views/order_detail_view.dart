import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import '../controllers/order_detail_controller.dart';
import '../widgets/order_detail_item_card.dart';
import '../widgets/order_summary_card.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppColors.textDark,
          ),
          onPressed: Get.back,
        ),
        title: Obx(
          () => Text(
            controller.order.value == null
                ? 'Order Details'
                : 'Order ${controller.order.value!.id}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: Obx(() {
        final order = controller.order.value;
        if (order == null) {
          return const Center(
            child: Text(
              'Order not found',
              style: TextStyle(color: AppColors.textLight),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          children: [
            OrderSummaryCard(order: order, width: screenWidth - 32),
            const SizedBox(height: 18),
            const Text(
              'Ordered Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: OrderDetailItemCard(
                  item: item,
                  width: screenWidth - 32,
                  onOpenProduct: () {
                    final product = controller.toProductInfo(item);
                    Get.toNamed(AppRoutes.productDetail, arguments: product);
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
                  backgroundColor: AppColors.darkGreen,
                  minimumSize: Size(screenWidth - 32, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Reorder Everything',
                  style: TextStyle(
                    color: Colors.white,
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
