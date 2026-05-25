import 'package:flutter/material.dart';

import 'package:fresh_leaf/core/models/cart_item.dart';
import 'package:fresh_leaf/shared/helpers/helper.dart';
import 'package:fresh_leaf/shared/widgets/app_network_image.dart';

class CheckoutItemRowWidget extends StatelessWidget {
  const CheckoutItemRowWidget({
    required this.item,
    super.key,
  });

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final total = item.subtotal;
    final price = item.vendorInventory?.price ?? 0.0;
    final currencySymbol = item.vendorInventory?.currencySymbol ?? r'$';
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          AppNetworkImage(
            url: item.vendorInventory?.displayImageUrl ?? '',
            width: 52,
            height: 52,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.vendorInventory?.displayTitle ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.quantity.toInt()}'
                  ' x'
                  ' $currencySymbol${formatPrice(price)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$currencySymbol${formatPrice(total)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: scheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
