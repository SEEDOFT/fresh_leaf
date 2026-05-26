import 'package:flutter/material.dart';
import 'package:fresh_leaf/core/models/order.dart';
import 'package:fresh_leaf/shared/widgets/money_amount_text.dart';
import 'package:get/get.dart';

class OrderDetailItemCard extends StatelessWidget {
  const OrderDetailItemCard({
    required this.item,
    required this.width,
    required this.onOpenProduct,
    super.key,
  });

  final OrderItem item;
  final double width;
  final VoidCallback onOpenProduct;

  @override
  Widget build(BuildContext context) {
    final quantity = item.quantity.toInt();
    final total = item.subtotal;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.productNameSnapshot,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              MoneyAmountText(
                amount: total,
                display: item.resolvedSubtotalDisplay,
                primaryStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$quantity x ${item.resolvedUnitPriceDisplay.primaryText}',
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: width - 28,
            child: OutlinedButton.icon(
              onPressed: item.vendorInventory != null ? onOpenProduct : null,
              icon: const Icon(Icons.open_in_new, size: 15),
              label: Text(
                'open_product'.tr,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: scheme.primary,
                side: BorderSide(color: scheme.outline.withValues(alpha: 0.65)),
                minimumSize: Size(width - 28, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
