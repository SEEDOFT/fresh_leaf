import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/models/order.dart';
import 'package:get/get.dart';

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({required this.order, super.key, this.onTap});

  final Order order;
  final VoidCallback? onTap;

  bool get _delivered => order.status == 'Delivered';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final borderColor = scheme.outline.withValues(alpha: 0.22);
    final badgeBg = _delivered
        ? scheme.primaryContainer.withValues(alpha: 0.65)
        : scheme.secondaryContainer.withValues(alpha: 0.7);
    final badgeText = _delivered ? scheme.primary : scheme.secondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              scheme.surfaceContainerHighest.withValues(alpha: 0.28),
              scheme.surface,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
          ),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, 8),
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
                    _translatedStatus,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: badgeText,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.receipt_long_rounded,
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
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: scheme.primary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surface.withValues(alpha: 0.76),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: scheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'view'.tr,
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
            ((order.items.length - previewCount) == 1
                    ? 'more_items_one'
                    : 'more_items_other')
                .trParams({
                  'count': '${order.items.length - previewCount}',
                }),
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

  String get _translatedStatus {
    switch (order.status) {
      case 'Delivered':
        return 'delivered'.tr;
      case 'Processing':
        return 'processing'.tr;
      default:
        return order.status;
    }
  }
}
