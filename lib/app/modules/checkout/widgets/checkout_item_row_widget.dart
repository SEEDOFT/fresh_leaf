import 'package:flutter/material.dart';

import 'package:fresh_leaf/core/models/cart_item.dart';
import 'package:fresh_leaf/shared/widgets/app_network_image.dart';
import 'package:fresh_leaf/shared/widgets/money_amount_text.dart';

class CheckoutItemRowWidget extends StatelessWidget {
  const CheckoutItemRowWidget({
    required this.item,
    required this.onTap,
    super.key,
  });

  final CartItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final total = item.subtotal;
    final unitPriceDisplay = item.resolvedUnitPriceDisplay;
    final totalDisplay = item.resolvedSubtotalDisplay;
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
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
                    ' ${item.vendorInventory?.unitName ?? ''}'
                    ' x'
                    ' ${unitPriceDisplay.primaryText}',
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            MoneyAmountText(
              amount: total,
              display: totalDisplay,
              primaryStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: scheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
