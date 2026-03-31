import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/orders/models/order.dart';
import 'package:get/get.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    super.key,
    required this.order,
    required this.width,
  });

  final Order order;
  final double width;

  @override
  Widget build(BuildContext context) {
    final delivered = order.status == 'Delivered';
    final scheme = Theme.of(context).colorScheme;
    final statusBg = delivered
        ? scheme.primaryContainer.withValues(alpha: 0.6)
        : scheme.secondaryContainer.withValues(alpha: 0.6);
    final statusColor = delivered ? scheme.primary : scheme.secondary;
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: statusBg,
                ),
                child: Text(
                  order.status == 'Delivered'
                      ? 'delivered'.tr
                      : order.status == 'Processing'
                      ? 'processing'.tr
                      : order.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                order.date,
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '\$${order.total.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            (order.items.length == 1
                    ? 'items_in_order_one'
                    : 'items_in_order_other')
                .trParams({'count': '${order.items.length}'}),
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
