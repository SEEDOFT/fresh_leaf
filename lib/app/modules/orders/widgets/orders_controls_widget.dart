import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/orders/controllers/orders_controller.dart';
import 'package:fresh_leaf/shared/widgets/app_filter_bar.dart';
import 'package:get/get.dart';

class OrdersControlsWidget extends StatelessWidget {
  const OrdersControlsWidget({
    required this.selectedStatusId,
    required this.selectedSort,
    required this.onStatusChanged,
    required this.onSortChanged,
    required this.scheme,
    super.key,
  });

  final int selectedStatusId;
  final OrderSortType selectedSort;
  final ValueChanged<int> onStatusChanged;
  final ValueChanged<OrderSortType> onSortChanged;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();
    return Row(
      children: [
        Expanded(
          child: AppFilterBar<int>(
            filters: controller.statusFilters
                .map((e) => e['id'] as int)
                .toList(),
            selectedFilter: selectedStatusId,
            onChanged: onStatusChanged,
            labelBuilder: (filterId) {
              final filter = controller.statusFilters.firstWhere(
                (e) => e['id'] == filterId,
              );
              final name = filter['name'] as String;
              switch (name) {
                case 'Pending':
                  return 'pending'.tr;
                case 'Confirmed':
                  return 'confirmed'.tr;
                case 'Preparing':
                  return 'preparing'.tr;
                case 'Out for Delivery':
                  return 'out_for_delivery'.tr;
                case 'Delivered':
                  return 'delivered'.tr;
                case 'Cancelled':
                  return 'cancelled'.tr;
                case 'Awaiting Payment':
                  return 'awaiting_payment'.tr;
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
