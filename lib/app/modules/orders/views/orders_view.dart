import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/orders/controllers/orders_controller.dart';
import 'package:fresh_leaf/app/modules/orders/widgets/orders_widget.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:get/get.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            const OrdersHeader(),
            const SizedBox(height: 14),
            Obx(
              () => OrdersFilterBar(
                filters: controller.statusFilters,
                selected: controller.selectedStatus,
                onChanged: (status) => controller.selectedStatus = status,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(
                () => controller.isLoading.value
                    ? const OrdersLoadingWidget()
                    : controller.orders.isEmpty
                    ? const EmptyOrdersWidget()
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        child: OrdersListWidget(
                          key: ValueKey<String>(
                            '${controller.selectedStatus}'
                            '-${controller.filteredOrders.length}',
                          ),
                          groupedOrders: controller.groupedFilteredOrders,
                          onOrderTap: (order) async => await Get.toNamed<void>(
                            AppRoutes.orderDetail,
                            arguments: order.toMap(),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
