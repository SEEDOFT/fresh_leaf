import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/orders/controllers/orders_controller.dart';
import 'package:fresh_leaf/shared/widgets/app_filter_bar.dart';
import 'package:get/get.dart';

class OrdersControlsWidget extends StatelessWidget {
  const OrdersControlsWidget({
    required this.controller,
    required this.selectedStatusId,
    required this.statusCounts,
    required this.onStatusChanged,
    required this.scheme,
    super.key,
  });

  final OrdersController controller;
  final int selectedStatusId;
  final Map<int, int> statusCounts;
  final ValueChanged<int> onStatusChanged;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
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
            badgeTextBuilder: (filterId) {
              if (filterId == 0) return null;
              if (filterId == 4 || filterId == 5) return null;
              final count = statusCounts[filterId] ?? 0;
              if (count == 0) return null;
              return count > 99 ? '99+' : count.toString();
            },
          ),
        ),
      ],
    );
  }
}
