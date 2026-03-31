import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailItemCard extends StatelessWidget {
  const OrderDetailItemCard({
    super.key,
    required this.item,
    required this.width,
    required this.onOpenProduct,
  });

  final Map<String, dynamic> item;
  final double width;
  final VoidCallback onOpenProduct;

  @override
  Widget build(BuildContext context) {
    final quantity = (item['quantity'] as num?)?.toInt() ?? 1;
    final unitPrice = (item['price'] as num?)?.toDouble() ?? 0.0;
    final total = unitPrice * quantity;
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
                  item['name'] as String? ?? 'product'.tr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$quantity x \$${unitPrice.toStringAsFixed(2)}',
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
              onPressed: onOpenProduct,
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
