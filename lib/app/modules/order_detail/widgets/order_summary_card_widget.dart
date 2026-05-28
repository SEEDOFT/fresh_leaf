import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/models/order.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:fresh_leaf/shared/widgets/app_card.dart';
import 'package:fresh_leaf/shared/widgets/exchange_rate_text.dart';
import 'package:fresh_leaf/shared/widgets/money_amount_text.dart';
import 'package:get/get.dart';

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
    final delivered = order.statusId == 4; // 4 is DELIVERED
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildBadge(
                      text: order.status,
                      bg: statusBg,
                      textColor: statusColor,
                    ),
                    if (order.paymentStatusId != null)
                      _buildBadge(
                        text: order.paymentStatus,
                        bg: scheme.surfaceContainerHighest,
                        textColor: scheme.onSurfaceVariant,
                      ),
                    if (order.orderTypeId != null)
                      _buildBadge(
                        text: order.orderType,
                        bg: scheme.surfaceContainerHighest,
                        textColor: scheme.onSurfaceVariant,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formatDateTime(order.createdAt),
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          MoneyAmountText(
            amount: order.totalAmount,
            display: order.resolvedTotalAmountDisplay,
            textAlign: TextAlign.start,
            primaryStyle: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          ExchangeRateText(
            display: order.resolvedTotalAmountDisplay,
            textAlign: TextAlign.start,
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

  Widget _buildBadge({
    required String text,
    required Color bg,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
