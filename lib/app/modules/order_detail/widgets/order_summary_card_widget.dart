import 'package:flutter/material.dart';
import 'package:fresh_leaf/app/modules/orders/models/order.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';

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
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grayBorder),
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
                  color: delivered
                      ? AppColors.accentLime.withValues(alpha: 0.25)
                      : AppColors.accentPeach.withValues(alpha: 0.25),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: delivered
                        ? AppColors.primaryDarkGreen
                        : AppColors.accentBrown,
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
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryDarkGreen,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${order.items.length} item(s) in this order',
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
