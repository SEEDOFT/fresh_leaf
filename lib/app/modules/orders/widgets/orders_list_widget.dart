import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/orders/widgets/order_item_widget.dart';
import 'package:fresh_leaf/core/models/order.dart';
import 'package:fresh_leaf/shared/widgets/app_section_header.dart';
import 'package:get/get.dart';

class OrdersListWidget extends StatelessWidget {
  const OrdersListWidget({
    required this.groupedOrders,
    super.key,
    this.onOrderTap,
  });

  final Map<String, List<Order>> groupedOrders;
  final ValueChanged<Order>? onOrderTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (groupedOrders.isEmpty) {
      return Center(
        child: Text(
          'no_orders_in_status'.tr,
          style: TextStyle(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    final sectionKeys = groupedOrders.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: sectionKeys.length,
      itemBuilder: (context, sectionIndex) {
        final section = sectionKeys[sectionIndex];
        final sectionOrders = groupedOrders[section] ?? const <Order>[];

        return Padding(
          padding: EdgeInsets.only(
            bottom: sectionIndex == sectionKeys.length - 1 ? 0 : 14,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSectionHeader(
                title: _translateSection(section),
                style: AppSectionHeaderStyle.divider,
                horizontalPadding: 0,
              ),
              const SizedBox(height: 10),
              ...sectionOrders.map(
                (order) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: OrderItemWidget(
                    order: order,
                    onTap: onOrderTap == null ? null : () => onOrderTap!(order),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _translateSection(String section) {
    switch (section) {
      case 'Today':
        return 'today'.tr;
      case 'This Week':
        return 'this_week'.tr;
      case 'This Month':
        return 'this_month'.tr;
      default:
        return 'earlier'.tr;
    }
  }
}
