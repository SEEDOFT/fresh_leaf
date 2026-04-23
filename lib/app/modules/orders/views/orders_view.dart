import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/orders/controllers/orders_controller.dart';
import 'package:fresh_leaf/app/modules/orders/widgets/orders_widget.dart';
import 'package:fresh_leaf/app/routes/app_routes.dart';
import 'package:fresh_leaf/shared/widgets/app_filter_bar.dart';
import 'package:fresh_leaf/shared/widgets/app_scaffold.dart';
import 'package:fresh_leaf/shared/widgets/custom_app_bar.dart';
import 'package:get/get.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final showAppBar = _showAppBarFromArgs();
    return AppScaffold(
      appBar: showAppBar ? CustomAppBar(title: 'orders'.tr) : null,
      safeAreaTop: !showAppBar,
      scrollable: false,
      padding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!showAppBar) const _OrdersTabTitle(),
          if (!showAppBar) const SizedBox(height: 10),
          Obx(
            () => _OrdersControls(
              selectedStatus: controller.selectedStatus,
              selectedSort: controller.selectedSort,
              onStatusChanged: (status) => controller.selectedStatus = status,
              onSortChanged: controller.setSort,
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => _SortSummaryChip(
              label: _sortLabel(controller.selectedSort),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? const OrdersLoadingWidget()
                  : controller.orders.isEmpty
                  ? const EmptyOrdersWidget()
                  : controller.filteredOrders.isEmpty
                  ? const EmptyOrdersWidget(filtered: true)
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

class _OrdersControls extends StatelessWidget {
  const _OrdersControls({
    required this.selectedStatus,
    required this.selectedSort,
    required this.onStatusChanged,
    required this.onSortChanged,
  });

  final String selectedStatus;
  final OrderSortType selectedSort;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<OrderSortType> onSortChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: AppFilterBar(
            filters: const <String>['All', 'Processing', 'Delivered'],
            selectedFilter: selectedStatus,
            onChanged: onStatusChanged,
            labelBuilder: (filter) {
              switch (filter) {
                case 'Processing':
                  return 'processing'.tr;
                case 'Delivered':
                  return 'delivered'.tr;
                default:
                  return 'tag_all'.tr;
              }
            },
          ),
        ),
        PopupMenuButton<OrderSortType>(
          initialValue: selectedSort,
          onSelected: onSortChanged,
          itemBuilder: (context) => <PopupMenuEntry<OrderSortType>>[
            PopupMenuItem<OrderSortType>(
              value: OrderSortType.newest,
              child: Text('orders_sort_newest'.tr),
            ),
            PopupMenuItem<OrderSortType>(
              value: OrderSortType.oldest,
              child: Text('orders_sort_oldest'.tr),
            ),
            PopupMenuItem<OrderSortType>(
              value: OrderSortType.highestTotal,
              child: Text('orders_sort_highest_total'.tr),
            ),
          ],
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.swap_vert_rounded,
              size: 18,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _SortSummaryChip extends StatelessWidget {
  const _SortSummaryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: scheme.outline.withValues(alpha: 0.16)),
        ),
        child: Text(
          '${'orders_sort'.tr}: $label',
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _OrdersTabTitle extends StatelessWidget {
  const _OrdersTabTitle();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'orders'.tr,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'orders_subtitle'.tr,
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
