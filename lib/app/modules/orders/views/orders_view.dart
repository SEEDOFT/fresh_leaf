import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/orders/controllers/orders_controller.dart';
import 'package:fresh_leaf/app/modules/orders/widgets/orders_widget.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:get/get.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final showAppBar = _showAppBarFromArgs();
    final scheme = Theme.of(context).colorScheme;

    return AppScaffold(
      appBar: showAppBar ? CustomAppBar(title: 'orders'.tr) : null,
      safeAreaTop: !showAppBar,
      scrollable: false,
      padding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!showAppBar) const OrdersTabTitleWidget(),
          if (!showAppBar) const SizedBox(height: 10),
          Obx(
            () => OrdersControlsWidget(
              selectedStatus: controller.selectedStatus,
              selectedSort: controller.selectedSort,
              onStatusChanged: (status) => controller.selectedStatus = status,
              onSortChanged: (sort) => controller.selectedSort = sort,
              scheme: scheme,
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => OrdersSortSummaryChipWidget(
              label: _sortLabel(controller.selectedSort),
              scheme: scheme,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? const OrdersLoadingWidget()
                  : controller.orders.isEmpty
                  ? const OrdersEmptyStateWidget()
                  : controller.filteredOrders.isEmpty
                  ? const OrdersEmptyStateWidget(filtered: true)
                  : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: OrdersListWidget(
                        key: ValueKey<String>(
                          '${controller.selectedStatus}'
                          '-${controller.selectedSort.name}'
                          '-${controller.filteredOrders.length}',
                        ),
                        groupedOrders: controller.groupedFilteredOrders,
                        scheme: scheme,
                        onOrderTap: (order) async => await Get.toNamed<void>(
                          AppRoutes.orderDetail,
                          arguments: order,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  bool _showAppBarFromArgs() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      return args['show_app_bar'] == true;
    }
    if (args is Map) {
      return args['show_app_bar'] == true;
    }
    return false;
  }

  String _sortLabel(OrderSortType sortType) {
    switch (sortType) {
      case OrderSortType.newest:
        return 'orders_sort_newest'.tr;
      case OrderSortType.oldest:
        return 'orders_sort_oldest'.tr;
      case OrderSortType.highestTotal:
        return 'orders_sort_highest_total'.tr;
    }
  }
}
