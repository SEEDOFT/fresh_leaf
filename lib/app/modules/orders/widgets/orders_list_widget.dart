import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import '../models/order.dart';
import 'order_item_widget.dart';

class OrdersListWidget extends StatelessWidget {
  const OrdersListWidget({
    super.key,
    required this.groupedOrders,
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
          'No orders in this status',
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
              _SectionHeader(title: section),
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
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Divider(
            thickness: 1,
            color: AppColors.grayBorder,
          ),
        ),
      ],
    );
  }
}
