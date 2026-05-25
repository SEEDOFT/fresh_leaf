import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/models/order.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:fresh_leaf/shared/widgets/app_card.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    required this.order,
    required this.width,
    super.key,
  });

  final Order order;
  final double width;

  @override
  Widget build(BuildContext context) {
    final delivered = order.statusName == 'DELIVERED';
    final scheme = Theme.of(context).colorScheme;
    final statusBg = delivered
        ? scheme.primaryContainer.withValues(alpha: 0.6)
        : scheme.secondaryContainer.withValues(alpha: 0.6);
    final statusColor = delivered ? scheme.primary : scheme.secondary;
    return AppCard(
      width: width,
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
                  order.statusName == 'DELIVERED'
                      ? 'delivered'.tr
                      : order.statusName == 'PENDING'
                      ? 'pending'.tr
                      : order.statusName == 'PREPARING'
                      ? 'processing'.tr
                      : order.statusName ?? 'unknown'.tr,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                order.createdAt != null
                    ? DateFormat('MMM d, yyyy').format(order.createdAt!)
                    : '',
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
            '\$${formatPrice(order.totalAmount)}',
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
