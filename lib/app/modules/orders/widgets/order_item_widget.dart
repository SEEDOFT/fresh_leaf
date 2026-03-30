import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/theme/app_colors.dart';
import '../models/order.dart';

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({super.key, required this.order, this.onTap});

  final Order order;
  final VoidCallback? onTap;

  bool get _delivered => order.status == 'Delivered';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final badgeBg = _delivered
        ? AppColors.accentLime.withValues(alpha: 0.25)
        : AppColors.accentPeach.withValues(alpha: 0.35);
    final badgeText = _delivered
        ? AppColors.primaryDarkGreen
        : AppColors.accentBrown;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.grayBorder.withValues(alpha: 0.7),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
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
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: badgeText,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.receipt_long,
                  size: 16,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  order.id,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              order.date,
              style: TextStyle(
                fontSize: 13,
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            ..._buildItemPreview(
              textColor: scheme.onSurface,
              mutedColor: scheme.onSurfaceVariant,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Text(
                  '\$${order.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDarkGreen,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'View',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: scheme.onSurface,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItemPreview({
    required Color textColor,
    required Color mutedColor,
  }) {
    final previewCount = order.items.length > 2 ? 2 : order.items.length;
    final previewItems = order.items.take(previewCount);

    final rows = previewItems
        .map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Text(
                  '${item['quantity']}x',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item['name'] as String? ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: textColor,
                    ),
                  ),
                ),
                Text(
                  '\$${((item['price'] as num?) ?? 0).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 13,
                    color: mutedColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();

    if (order.items.length > previewCount) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            '+${order.items.length - previewCount} more item(s)',
            style: TextStyle(
              fontSize: 12,
              color: mutedColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
    return rows;
  }
}
